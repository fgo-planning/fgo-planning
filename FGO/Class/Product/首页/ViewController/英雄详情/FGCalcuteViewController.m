//
//  FGCalcuteViewController.m
//  FGO
//
//  Created by 孔志林 on 2018/11/29.
//  Copyright © 2018年 KMingMing. All rights reserved.
//  素材计算

#import "FGCalcuteViewController.h"
#import "FGMainVIiewModel.h"
#import "FGCalcuteModel.h"
#import "JQFMDB.h"
#import "FGSourceModel.h"
#import "FGSourceDetailViewController.h"
@interface FGCalcuteViewController ()<UITableViewDelegate, UITableViewDataSource>
/**  tableView    */
@property (nonatomic, strong) UITableView *tableView;
/**  数据源    */
@property (nonatomic, strong) NSArray *dataArray;
/**  头部视图    */
@property (nonatomic, strong) UIView *headerView;
/**  扣除素材    */
@property (nonatomic, strong) UIButton *kcscBtn;
/**  模型    */
@property (nonatomic, strong) FGCalcuteModel *calcuteModel;
/**  db    */
@property (nonatomic, strong) JQFMDB *db;
/**  是否缺少    */
@property (nonatomic, assign) BOOL isQueShao;
/**  <##>    */
@property (nonatomic, strong) NSMutableDictionary *countDic;
@end

@implementation FGCalcuteViewController
#pragma mark - Life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self p_config];
    [self p_createUI];
    
    [[FGMainVIiewModel sharedInstance] getCalcute:self.params success:^(id obj, NSURLSessionDataTask *dataTask) {
        self.calcuteModel = obj;
        [self p_refreshUI];
    } failure:^(id err) {
        
    }];
}
- (void)p_refreshUI
{
    NSMutableArray *setSkills = [NSMutableArray array];
    [setSkills addObject:self.calcuteModel.rank];
    [setSkills addObjectsFromArray:self.calcuteModel.skill];
    
    [setSkills enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UILabel *lb = [self.headerView viewWithTag:idx + 200];
        lb.text = obj;
    }];
    
    self.dataArray = self.calcuteModel.material;
    [self.tableView reloadData];
}
#pragma mark 设置顶部头像
- (void)setImagePaths:(NSArray *)imagePaths
{
    _imagePaths = imagePaths;
    [imagePaths enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImageView *iv = [self.headerView viewWithTag:idx + 100];
        NSString *imagePath = [[NSBundle mainBundle] pathForResource:obj ofType:nil];
        if (imagePath) {
            iv.image = [UIImage imageWithContentsOfFile:imagePath];
        }else
        {
            [iv sd_setImageWithURL:[NSURL URLWithString:obj]];
        }
    }];
}
#pragma mark - Private methods
- (void)p_config
{
    self.navigationItem.title = @"计算素材";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem =  [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"KM_rightNvi"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemClick)];
}
- (void)p_createUI
{
    [self.view addSubview:self.tableView];
}
- (void)rightBarButtonItemClick
{
    
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count + 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UITableViewCell"];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.row == 0) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.imageView.image = [UIImage imageNamed:@"qb"];
        cell.textLabel.text = @"QP";
        cell.textLabel.text = [NSString stringWithFormat:@"QP*%ld万",[self.calcuteModel.qp integerValue]/10000];
        //先取出之前的
        FGSourceModel *detailModel = [self.db jq_lookupTable:kTableName(@"sourceInfo") dicOrModel:[FGSourceModel class] whereFormat:[NSString stringWithFormat:@"where ID = %@",@"1000"]].firstObject;
        NSInteger haveCount = detailModel.count + detailModel.activityCount/10000;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"拥有:%ld万(活动:%ld万)",haveCount,(long)detailModel.activityCount/10000];

        NSInteger needCount = [self.calcuteModel.qp integerValue]/10000;
        NSInteger syCount = haveCount - needCount; //计算剩余的个数
        [self.countDic setObject:@(syCount) forKey:@"1000"];
        if (syCount < 0) {
            self.isQueShao = YES;
            cell.detailTextLabel.text = [NSString stringWithFormat:@"拥有:%ld万(缺少:%ld万)",haveCount,-syCount];
            cell.detailTextLabel.textColor = [UIColor redColor];
        }
    }else
    {
        FGCalcuteCountModel *model = self.dataArray[indexPath.row - 1];
        cell.textLabel.text = model.name;
        cell.textLabel.text = [NSString stringWithFormat:@"%@*%@",model.name,model.count];
        //先取出之前的
        FGSourceModel *detailModel = [self.db jq_lookupTable:kTableName(@"sourceInfo") dicOrModel:[FGSourceModel class] whereFormat:[NSString stringWithFormat:@"where ID = %@",model.ID]].firstObject;
        NSInteger haveCount = detailModel.count + detailModel.activityCount;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"拥有:%ld(活动:%ld)",haveCount,(long)detailModel.activityCount];
        
        NSInteger needCount = [model.count integerValue];
        NSInteger syCount = haveCount - needCount; //计算剩余的个数
        [self.countDic setObject:@(syCount) forKey:model.ID];
        if (syCount < 0) {
            self.isQueShao = YES;
            cell.detailTextLabel.text = [NSString stringWithFormat:@"拥有:%ld(缺少:%ld)",haveCount,-syCount];
            cell.detailTextLabel.textColor = [UIColor redColor];
        }
        NSString *imagePath = [[NSBundle mainBundle] pathForResource:model.imgPath ofType:nil];
        if (imagePath) {
            cell.imageView.image = [UIImage imageWithContentsOfFile:imagePath];
        }else
        {
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:model.imgPath]];
        }
    }
    
    CGSize itemSize = CGSizeMake(45, 45);
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
    if (indexPath.row > 0) {
        FGCalcuteCountModel *model = self.dataArray[indexPath.row - 1];
        FGSourceDetailViewController *vc = [[FGSourceDetailViewController alloc] init];
        vc.model = model;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0f;
}
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    return [NSString stringWithFormat:@"第几个模块%ld",section];
//}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UITableViewCell *cell = [UITableViewCell new];
//    cell.accessoryType = UITableViewCellAccessoryCheckmark;
//    return cell;
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 0.1f;
//}
//- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
//{
//    return @" ";
//}
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    return [UIView new];
//}


//      <UITableViewDelegate, UITableViewDataSource>
#pragma mark - Lazy load
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, MainHeight - HeightOfStaAndNav - HeightOfFromBottom) style:UITableViewStylePlain]; //UITableViewStylePlain,section头部固定在顶部。UITableViewStyleGrouped,头部向上
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);//分割线两边距离为10
        //        _tableView.separatorColor = [UIColor redColor];//分割线颜色
        _tableView.rowHeight = 60; //行高
        _tableView.tableHeaderView = self.headerView;
        
        UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, 60)];
        footView.backgroundColor = kGrayColor;
        [footView addSubview:self.kcscBtn];
        _tableView.tableFooterView = footView;//去掉底部多余线条

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
- (NSMutableDictionary *)countDic
{
    if (!_countDic) {
        _countDic = [NSMutableDictionary dictionary];
    }
    return _countDic;
}
- (UIView *)headerView
{
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, 60)];
        _headerView.backgroundColor = kGrayColor;
        for (int i = 0; i < 4; i++) {
            UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectZero];
            iv.tag = i+100;
            [_headerView addSubview:iv];
            [iv mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(7.5);
                make.left.equalTo(20 + i*60);
                make.size.equalTo(CGSizeMake(45, 45));
            }];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
            label.tag = i+200;
            label.textColor = [UIColor whiteColor];
            label.text = @"2->10";
            label.font = [UIFont systemFontOfSize:14 weight:UIFontWeightBold];
            [_headerView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(-7.5);
                make.left.equalTo(20 + i*60);
                make.size.equalTo(CGSizeMake(45, 20));
            }];
        }
        
    }
    return _headerView;
}
- (UIButton *)kcscBtn
{
    if (!_kcscBtn) {
        _kcscBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _kcscBtn.backgroundColor = [UIColor p_rgbColorR:2 G:175 B:0];
        [_kcscBtn setTitle:@"扣除素材" forState:UIControlStateNormal];
        [_kcscBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _kcscBtn.frame = CGRectMake(40, 5, MainWidth - 80, 50);
        _kcscBtn.layer.cornerRadius = 5;
        _kcscBtn.layer.masksToBounds = YES;
        [_kcscBtn addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _kcscBtn;
}
#pragma mark - 扣除素材
- (void)tapAction:(UIButton *)sender
{
    if (self.isQueShao) {
        [self p_SVProgressHUDError:@"素材不足"];
        return;
    }
    [self p_showMBProgressHUD];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self.countDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            //先取出之前的
            FGSourceModel *detailModel = [self.db jq_lookupTable:kTableName(@"sourceInfo") dicOrModel:[FGSourceModel class] whereFormat:[NSString stringWithFormat:@"where ID = %@",key]].firstObject;
            NSArray *a = [self.db jq_lookupTable:kTableName(@"sourceInfo") dicOrModel:[FGSourceModel class] whereFormat:[NSString stringWithFormat:@"where ID = %@",key]];
            NSInteger activityCount = detailModel.activityCount;
            if ([key isEqualToString:@"1000"]) {
                activityCount = detailModel.activityCount / 10000;
            }
            
            NSInteger syCount = [obj integerValue]; //剩余的个数
            detailModel.count = syCount - activityCount;
            BOOL isUpdate = [self.db jq_updateTable:kTableName(@"sourceInfo") dicOrModel:detailModel whereFormat:[NSString stringWithFormat:@"where ID = %@",key]];
            NSLog(@"%d",isUpdate);
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self p_hideMBProgressHUD];
            [self p_popViewController];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshSkillLevelNotification" object:nil];
        });
    });
}

- (JQFMDB *)db//保存打开的活动的素材个数
{
    if (!_db) {
        _db = [JQFMDB shareDatabase];
        BOOL isExistsourceInfo = [_db jq_isExistTable:kTableName(@"sourceInfo")];
        if (!isExistsourceInfo) {
            [_db jq_createTable:kTableName(@"sourceInfo") dicOrModel:[FGSourceModel class]];
        }
        
    }
    return _db;
}

@end
