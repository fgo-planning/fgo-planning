//
//  FGSourceInfoViewController.m
//  FGO
//
//  Created by 孔志林 on 2018/11/12.
//  Copyright © 2018年 KMingMing. All rights reserved.
//

#import "FGSourceInfoViewController.h"
#import "FGSourceModel.h"
#import "FGAddCountView.h"
#import "JQFMDB.h"
@interface FGSourceInfoViewController ()<UITableViewDelegate, UITableViewDataSource, FGAddCountViewDelegate>
/**  tableView    */
@property (nonatomic, strong) UITableView *tableView;
/**  数据源    */
@property (nonatomic, strong) NSArray *dataArray;
/**  <##>    */
@property (nonatomic, strong) NSArray *headTitles;
/**  <##>    */
@property (nonatomic, strong) JQFMDB *db;
@end

@implementation FGSourceInfoViewController

#pragma mark - Life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self p_config];
    [self p_createUI];
}
#pragma mark - Private methods
- (void)p_config
{
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
#pragma mark - FGAddCountViewDelegate
- (void)FGAddCountView:(UITextField *)textFild index:(NSIndexPath *)indexPath
{
    FGSourceModel *model = self.models[indexPath.row];
    model.count = [textFild.text integerValue];
    //保存素材信息
    NSArray *models = [self.db jq_lookupTable:kTableName(@"sourceInfo") dicOrModel:[FGSourceModel class] whereFormat:[NSString stringWithFormat:@"where ID = %@",model.ID]];
    NSInteger count = models.count;
    
    NSInteger activityCount = 0;
    if (count == 0) {
        [self.db jq_insertTable:kTableName(@"sourceInfo") dicOrModel:model];
    }else{
        FGSourceModel *savedModel = models[0];
        model.activityCount = savedModel.activityCount;
        BOOL isUpdate = [self.db jq_updateTable:kTableName(@"sourceInfo") dicOrModel:model whereFormat:[NSString stringWithFormat:@"where ID = %@",model.ID]];
        NSLog(@"%d",isUpdate);
        
        activityCount = savedModel.activityCount;
    }

    NSInteger totalCount = [textFild.text integerValue] + activityCount;
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
//    cell.detailTextLabel.text = [NSString stringWithFormat:@"库存数量:%@",textFild.text];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"总:%ld(活动:%ld)", totalCount,activityCount];

    if (indexPath.row == 0) {
//        cell.detailTextLabel.text = [NSString stringWithFormat:@"库存数量:%@(万)",textFild.text];
        totalCount = [textFild.text integerValue] + activityCount/10000;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"总:%ld万(活动:%ld万)", totalCount,activityCount/10000];
    }
    
}
#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  self.models.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UITableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    FGSourceModel *model = self.models[indexPath.row];
    FGSourceModel *dbModel = [self.db jq_lookupTable:kTableName(@"sourceInfo") dicOrModel:[FGSourceModel class] whereFormat:[NSString stringWithFormat:@"where ID = %@",model.ID]].firstObject;
    
    NSArray *arraa = [self.db jq_lookupTable:kTableName(@"sourceInfo") dicOrModel:[FGSourceModel class] whereFormat:[NSString stringWithFormat:@"where ID = %@",model.ID]];
    
    cell.textLabel.text = model.name;
    NSInteger count = model.count;
    NSInteger activityCount = model.activityCount;
    if (dbModel) {
        count = dbModel.count;
        activityCount = dbModel.activityCount;
    }
    NSInteger totalCount = count + activityCount;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"总:%ld(活动:%ld)", totalCount,activityCount];
    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    FGAddCountView *rightView = [[FGAddCountView alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
    rightView.delegate = self;
    rightView.indexPath = indexPath;
    rightView.tf.text = @(count).stringValue;
    cell.accessoryView = rightView;
    
    if (self.isSuCai && indexPath.row == 0) {
        cell.imageView.image = [UIImage imageNamed:model.imgPath];
        totalCount = count + activityCount/10000;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"总:%ld万(活动:%ld万)", totalCount,activityCount/10000];
        cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
    }else {
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
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 1.0f;
//}
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    return @"";
//}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UILabel *lb = [UILabel new];
//    lb.backgroundColor = [UIColor lightGrayColor];
//    return lb;
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
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, MainHeight - HeightOfStaAndNav - 50) style:UITableViewStylePlain]; //UITableViewStylePlain,section头部固定在顶部。UITableViewStyleGrouped,头部向上
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];//去掉底部多余线条
        _tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);//分割线两边距离为10
        //        _tableView.separatorColor = [UIColor redColor];//分割线颜色
        _tableView.rowHeight = 60; //行高
        
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
- (JQFMDB *)db
{
        _db = [JQFMDB shareDatabase];
        BOOL isExist = [_db jq_isExistTable:kTableName(@"sourceInfo")];
        if (!isExist) {
            [_db jq_createTable:kTableName(@"sourceInfo") dicOrModel:[FGSourceModel class]];
        }
    return _db;
}
@end
