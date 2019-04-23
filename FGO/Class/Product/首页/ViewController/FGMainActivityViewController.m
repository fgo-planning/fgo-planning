//
//  FGMainActivityViewController.m
//  FGO
//
//  Created by 孔志林 on 2018/11/5.
//  Copyright © 2018年 KMingMing. All rights reserved.
//  活动列表

#import "FGMainActivityViewController.h"
#import "FGMainVIiewModel.h"
#import "FGActivityModel.h"
#import "FGActivityHeaderView.h"
#import "FGFMDBHelper.h"
#import "FGSourceModel.h"
#import "JQFMDB.h"

@interface FGMainActivityViewController ()<UITableViewDelegate, UITableViewDataSource, FGActivityHeaderViewDelegate>
/**  tableView    */
@property (nonatomic, strong) UITableView *tableView;
/**  数据源    */
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) JQFMDB *db;

@end

@implementation FGMainActivityViewController
#pragma mark - Life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self p_config];
    [self p_createUI];
    [self p_loadData];
}

#pragma mark - Private methods
//- (void)p_popViewController
//{
//    [super p_popViewController];
//    [[FGFMDBHelper sharedInstance] p_updateTable:@"activity" data:self.dataArray];
//}
- (void)p_loadData
{
    [[FGMainVIiewModel sharedInstance] getActivity:^(id obj, NSURLSessionDataTask *dataTask) {
        self.dataArray = obj;
        [self.tableView reloadData];
    } failure:^(id err) {
        
    }];
}
- (void)p_config
{
    self.navigationItem.title = @"活动列表";
    self.view.backgroundColor = [UIColor whiteColor];
}
- (void)p_createUI
{
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    FGActivityModel *activityModel = self.dataArray[section];
    NSArray *data = activityModel.material;
    BOOL isHide = activityModel.isHide;
    return isHide ? 0 : data.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell"];
        cell.backgroundColor = kGrayColor;
    }
    
    FGActivityModel *activityModel = self.dataArray[indexPath.section];
    FGActivityDetailModel *model = activityModel.material[indexPath.row];
    
    //取出数据库保存的数量
    FGSourceModel *detailModel = [self.db jq_lookupTable:kTableName(@"sourceInfo") dicOrModel:[FGSourceModel class] whereFormat:[NSString stringWithFormat:@"where ID = %@",model.ID]].firstObject;
    
    //现有个数
    NSInteger currentCount = detailModel.count + detailModel.activityCount;
    NSInteger activityCount = detailModel.activityCount;
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@*%@",model.name, model.count];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"现有:%ld(活动%ld)",currentCount ?: 0,activityCount ?:0];
    
    //如果是QP,把单位搞大一点
    if ([model.ID isEqualToString:@"1000"]) {
        currentCount = detailModel.count + detailModel.activityCount/10000;
        activityCount = activityCount/10000;
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@*%ld万",model.name, model.count.integerValue/10000];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"现有:%ld万(活动%ld万)",currentCount ?: 0,activityCount ?:0];
    }
    
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
    if (KImagePath(model.imgPath)) {
        cell.imageView.image = [UIImage imageWithContentsOfFile:KImagePath(model.imgPath)];
    }else
    {
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:model.imgPath]];
    }
    
    CGSize itemSize = CGSizeMake(30, 30);
    UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [cell.imageView.image drawInRect:imageRect];
    cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50.0f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    FGActivityHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"FGActivityHeaderView"];
    headerView.delegate = self;
    headerView.index = section;
    
    FGActivityModel *model = self.dataArray[section];
    headerView.leftLb.text = model.name;
    headerView.detailBtn.hidden = [model.type isEqualToString:@"1"] ? YES : NO;

    //读取数据库中的保存的
    FGActivityModel *dbModel = [self.db jq_lookupTable:kTableName(@"FGActivityModel") dicOrModel:[FGActivityModel class] whereFormat:[NSString stringWithFormat:@"where ID = %@",model.ID]].firstObject;
    headerView.swich.on = dbModel.swichON ?: NO;
    
    UITapGestureRecognizer *rg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHeader:)];
    headerView.tag = section +200;
    [headerView addGestureRecognizer:rg];
    return headerView;
}
- (void)tapHeader:(UITapGestureRecognizer *)sender
{
    NSInteger index = sender.view.tag - 200;//下标
    FGActivityModel *model = self.dataArray[index];
    model.hide = !model.hide;
    [self.dataArray enumerateObjectsUsingBlock:^(FGActivityModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx != index) {
            obj.hide = YES;
        }
    }];
    [self.tableView reloadData];
    if (!model.hide) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:index];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}
//- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
//{
//    return @" ";
//}
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    return [UIView new];
//}

#pragma mark - FGActivdetailityHeaderViewDelegate
- (void)headerView:(FGActivityHeaderView *)view tapDetailBtn:(NSInteger)index {
//    [self p_toast:@"点我干嘛！哼"];
}

- (void)headerView:(FGActivityHeaderView *)view tapSwich:(NSInteger)index {
    UISwitch *swich = view.swich;
    FGActivityModel *model = self.dataArray[index];
    if (swich.on) {
        model.swichON = YES;
    }else
    {
        model.swichON = NO;
    }
    
    [self p_showMBProgressHUD];

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSArray *activityS = [self.db jq_lookupTable:kTableName(@"FGActivityModel") dicOrModel:[FGActivityModel class] whereFormat:[NSString stringWithFormat:@"where ID = %@",model.ID]];
        if (activityS.count == 0) {
            [self.db jq_insertTable:kTableName(@"FGActivityModel") dicOrModel:model];
        }else
        {
            [self.db jq_updateTable:kTableName(@"FGActivityModel") dicOrModel:model whereFormat:[NSString stringWithFormat:@"where ID = %@",model.ID]];//插入数据，保存开关状态
        }
        [model.material enumerateObjectsUsingBlock:^(FGActivityDetailModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            //先取出之前的
            FGSourceModel *detailModel = [self.db jq_lookupTable:kTableName(@"sourceInfo") dicOrModel:[FGSourceModel class] whereFormat:[NSString stringWithFormat:@"where ID = %@",obj.ID]].firstObject;
            
            FGSourceModel *saveSourceModel = [FGSourceModel new];//创建一个用于保存的sourceModel;
            if (detailModel) {
                saveSourceModel = detailModel;
            }else
            {
                saveSourceModel.activityCount = 0;
                saveSourceModel.ID = obj.ID;
                saveSourceModel.count = 0;
            }
            
            if (model.swichON) {
                saveSourceModel.activityCount = saveSourceModel.activityCount + [obj.count integerValue];
            }else
            {
                saveSourceModel.activityCount = saveSourceModel.activityCount - obj.count.integerValue;
            }
            
            NSArray *sources = [self.db jq_lookupTable:kTableName(@"sourceInfo") dicOrModel:[FGSourceModel class] whereFormat:[NSString stringWithFormat:@"where ID = %@",saveSourceModel.ID]];
            if (sources.count == 0) {
                [self.db jq_insertTable:kTableName(@"sourceInfo") dicOrModel:saveSourceModel];
            }else
            {
                [self.db jq_updateTable:kTableName(@"sourceInfo") dicOrModel:saveSourceModel whereFormat:[NSString stringWithFormat:@"where ID = %@",saveSourceModel.ID]];//插入数据，保存开关状态
            }
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            
//            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationNone];
            
            [self.dataArray enumerateObjectsUsingBlock:^(FGActivityModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (!obj.hide) {
                    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:idx] withRowAnimation:UITableViewRowAnimationNone];
                }
            }];
            [self p_hideMBProgressHUD];
        });
    });
}

//      <UITableViewDelegate, UITableViewDataSource>
#pragma mark - Lazy load
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, MainHeight - HeightOfStaAndNav) style:UITableViewStyleGrouped]; //UITableViewStylePlain,section头部固定在顶部。UITableViewStyleGrouped,头部向上
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];//去掉底部多余线条
        _tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);//分割线两边距离为10
        //        _tableView.separatorColor = [UIColor redColor];//分割线颜色
        _tableView.rowHeight = 40; //行高
//        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
        [_tableView registerClass:[FGActivityHeaderView class] forHeaderFooterViewReuseIdentifier:@"FGActivityHeaderView"];
    }
    return _tableView;
}
- (NSArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSArray array];
    }
    return _dataArray;
}
- (JQFMDB *)db//保存打开的活动的素材个数
{
    if (!_db) {
        _db = [JQFMDB shareDatabase];
        BOOL isExist = [_db jq_isExistTable:kTableName(@"FGActivityModel")];
        if (!isExist) {
            [_db jq_createTable:kTableName(@"FGActivityModel") dicOrModel:[FGActivityModel class]];
        }
        BOOL isExistsourceInfo = [_db jq_isExistTable:kTableName(@"sourceInfo")];
        if (!isExistsourceInfo) {
            [_db jq_createTable:kTableName(@"sourceInfo") dicOrModel:[FGSourceModel class]];
        }

    }
    return _db;
}

@end
