//
//  FGSourcePlanViewController.m
//  FGO
//
//  Created by 孔志林 on 2018/12/12.
//  Copyright © 2018年 KMingMing. All rights reserved.
//

#import "FGSourcePlanViewController.h"
#import "FGSourePlanTableViewCell.h"
#import "FGUIPikerView.h"
#import "JQFMDB.h"
#import "FGHeroModel.h"
#import "FGSourecePlanDetialViewController.h"
#import "FGHeroDetailModel.h"
#import "FGSaveJNModel.h"
@interface FGSourcePlanViewController ()<UITableViewDelegate, UITableViewDataSource, FGUIPikerViewDelegate>
/**  tableView    */
@property (nonatomic, strong) UITableView *tableView;
/**  数据源    */
@property (nonatomic, strong) NSArray *dataArray;
/**  pickerView    */
@property (nonatomic, strong) FGUIPikerView *pickerView;
/**  db    */
@property (nonatomic, strong) JQFMDB *db;
/**  <##>    */
@property (nonatomic, strong) UIButton *kcscBtn;
/**      */
@property (nonatomic, strong) NSMutableArray *planModels;
@end

@implementation FGSourcePlanViewController
#pragma mark - Life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self p_config];
    [self p_createUI];
    [self p_readLikeHero];
}
- (void)p_readLikeHero
{
    NSArray *likes = [self.db jq_lookupTable:kTableName(@"likeHero") dicOrModel:[FGHeroModel class] whereFormat:nil];
    if (![NSArray isNullOrEmptyArray:likes]) {
        self.dataArray = likes;
        [self.dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            FGHeroModel *model = obj;
            
            FGSourcePlanModel *planModl = [FGSourcePlanModel new];
            planModl.imagePath = model.imgPath;
            planModl.linJi = @"0-4";
            planModl.jiNengOne = @"1-10";
            planModl.jiNengTwo = @"1-10";
            planModl.jiNengThree = @"1-10";
            
            NSArray *data= [[JQFMDB shareDatabase] jq_lookupTable:kHeroLevel dicOrModel:[FGHeroSkillModel class] whereFormat:[NSString stringWithFormat:@"where servantId = '%@'",model.ID]];
            if (![NSArray isNullOrEmptyArray:data]) {
                FGHeroSkillModel *skillModel = data[0];
                NSArray *skillArr = [NSKeyedUnarchiver unarchiveObjectWithData:skillModel.skillLevel];
                FGSaveJNModel *saveLevel1 = (FGSaveJNModel *)skillArr[0];
                FGSaveJNModel *saveLevel2 = (FGSaveJNModel *)skillArr[1];
                FGSaveJNModel *saveLevel3 = (FGSaveJNModel *)skillArr[2];

                planModl.linJi = [NSString stringWithFormat:@"%@-4",[skillModel.lingjiValue stringValue]];
                planModl.jiNengOne = [NSString stringWithFormat:@"%ld-10",(long)saveLevel1.level];
                planModl.jiNengTwo = [NSString stringWithFormat:@"%ld-10",(long)saveLevel2.level];
                planModl.jiNengThree = [NSString stringWithFormat:@"%ld-10",(long)saveLevel3.level];

                planModl.isChoose = YES;

                NSLog(@"");
            }

            
            
            
            planModl.ID = model.ID;
            planModl.clothFlag = model.clothFlag;
            [self.planModels addObject:planModl];
        }];
        [self.tableView reloadData];
    }
}
#pragma mark - Private methods
- (void)p_config
{
    self.planModels = [NSMutableArray array];
    self.navigationItem.title = @"素材规划";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem =  [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"KM_rightNvi"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemClick)];
}
- (void)p_createUI
{
    [self.view addSubview:self.tableView];
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0,MainHeight - HeightOfStaAndNav - HeightOfFromBottom - 60, MainWidth, 60)];
    footView.backgroundColor = kGrayColor;
    [footView addSubview:self.kcscBtn];
    [self.view addSubview:footView];
    
}

- (UIButton *)kcscBtn
{
    if (!_kcscBtn) {
        _kcscBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _kcscBtn.backgroundColor = [UIColor p_rgbColorR:2 G:175 B:0];
        [_kcscBtn setTitle:@"计算素材" forState:UIControlStateNormal];
        [_kcscBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _kcscBtn.frame = CGRectMake(40, 5, MainWidth - 80, 50);
        _kcscBtn.layer.cornerRadius = 5;
        _kcscBtn.layer.masksToBounds = YES;
        [_kcscBtn addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _kcscBtn;
}

- (void)tapAction:(UIButton *)sender
{
    NSMutableArray *params = [NSMutableArray array];
    [self.planModels enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        FGSourcePlanModel *planModl = obj;
        if (planModl.isChoose) {
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            NSString *linji = [planModl.linJi stringByReplacingOccurrencesOfString:@"-" withString:@"_"];
            NSString *jnOne = [planModl.jiNengOne stringByReplacingOccurrencesOfString:@"-" withString:@"_"];
            NSString *jnTwo = [planModl.jiNengTwo stringByReplacingOccurrencesOfString:@"-" withString:@"_"];
            NSString *jnThree = [planModl.jiNengThree stringByReplacingOccurrencesOfString:@"-" withString:@"_"];
            [dic setObject:linji forKey:@"rank"];
            [dic setObject:jnOne forKey:@"skill1"];
            [dic setObject:jnTwo forKey:@"skill2"];
            [dic setObject:jnThree forKey:@"skill3"];
            [dic setObject:planModl.clothFlag forKey:@"clothFlag"];
            [dic setObject:planModl.ID forKey:@"servantId"];

            [params addObject:dic];
        }
    }];
    
    if (params.count == 0) {
        [self p_toast:@"请先勾选需要计算的英雄"];
        return;
    }
    NSDictionary *dic = @{@"param":params,
                          @"ownCount":@{},
                          @"model":@1};
    
    FGSourecePlanDetialViewController *vc = [FGSourecePlanDetialViewController new];
    vc.params = dic;
    [self.navigationController pushViewController:vc animated:YES];
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
    return self.planModels.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FGSourePlanTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FGSourePlanTableViewCell"];
    FGSourcePlanModel *planModl = self.planModels[indexPath.row];
    cell.model = planModl;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FGSourcePlanModel *planModl = self.planModels[indexPath.row];
    FGUIPikerView *pickView = [[FGUIPikerView alloc] initWithFrame:self.view.bounds];
    pickView.delegate = self;
    pickView.planModel = planModl;
    pickView.indexPath = indexPath;
    [self.view addSubview:pickView];
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



#pragma mark - FGUIPikerViewDelegate
- (void)FGUIPikerViewSure:(FGSourcePlanModel *)model index:(NSIndexPath *)indexPath
{
    FGSourePlanTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.model = model;
}

#pragma mark - Lazy load
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, MainHeight - HeightOfStaAndNav - HeightOfFromBottom - 60) style:UITableViewStylePlain]; //UITableViewStylePlain,section头部固定在顶部。UITableViewStyleGrouped,头部向上
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];//去掉底部多余线条
        _tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);//分割线两边距离为10
        //        _tableView.separatorColor = [UIColor redColor];//分割线颜色
        _tableView.rowHeight = [FGSourePlanTableViewCell p_getCellHeight]; //行高
        [_tableView registerClass:[FGSourePlanTableViewCell class] forCellReuseIdentifier:@"FGSourePlanTableViewCell"];
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
- (FGUIPikerView *)pickerView
{
    if (!_pickerView) {
        _pickerView = [[FGUIPikerView alloc] initWithFrame:self.view.bounds];
        _pickerView.delegate = self;
    }
    return _pickerView;
}
- (JQFMDB *)db
{
        _db = [JQFMDB shareDatabase];
        BOOL isAlready = [_db jq_isExistTable:kTableName(@"likeHero")];
        if (!isAlready) {
            [_db jq_createTable:kTableName(@"likeHero") dicOrModel:[FGHeroModel class]];
        }
    return _db;
}
@end
