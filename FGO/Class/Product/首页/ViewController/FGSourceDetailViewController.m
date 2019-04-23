//
//  FGSourceDetailViewController.m
//  FGO
//
//  Created by 孔志林 on 2019/1/2.
//  Copyright © 2019年 KMingMing. All rights reserved.
//

#import "FGSourceDetailViewController.h"
#import "FGMainVIiewModel.h"
#import "FGSourceDetailModel.h"
#import "FGSourrceDetailTableViewCell.h"
@interface FGSourceDetailViewController ()<UITableViewDelegate, UITableViewDataSource>
/**  tableView    */
@property (nonatomic, strong) UITableView *tableView;
/**  数据源    */
@property (nonatomic, strong) NSArray *dataArray;
/**  model    */
@property (nonatomic, strong) FGSourceDetailModel *sourceDetailModel;
@end

@implementation FGSourceDetailViewController

#pragma mark - Life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self p_config];
    [self p_createUI];
    
    NSDictionary *params = @{@"materialId" : self.model.ID, @"model" : @"1"};
    [[FGMainVIiewModel sharedInstance] getSourceDetail:params success:^(id obj, NSURLSessionDataTask *dataTask) {
        self.sourceDetailModel = obj;
        NSArray *drops = self.sourceDetailModel.drops;
        if (drops.count>5) {
            self.dataArray = [drops subarrayWithRange:NSMakeRange(0, 5)];
        }else
        {
            self.dataArray = [NSArray arrayWithArray:drops];
        }
        [self.tableView reloadData];
    } failure:^(id err) {
        
    }];
}
- (void)setModel:(FGCalcuteCountModel *)model
{
    _model = model;
    self.title = model.name;
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

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FGSourrceDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FGSourrceDetailTableViewCell"];
    cell.model = self.dataArray[indexPath.section];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50.0f;
}
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    return [NSString stringWithFormat:@"第几个模块%ld",section];
//}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewHeaderFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"UITableViewHeaderFooterView"];
    if (!view) {
        view = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"UITableViewHeaderFooterView"];
        view.contentView.backgroundColor = [UIColor whiteColor];
        UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        leftLabel.tag = 100;
        leftLabel.textColor = [UIColor p_rgbColorR:50 G:156 B:48];
        leftLabel.adjustsFontSizeToFitWidth = YES;
        
        UILabel *rightLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        rightLabel.tag = 101;
        rightLabel.textAlignment = NSTextAlignmentRight;
        rightLabel.adjustsFontSizeToFitWidth = YES;
        
        [view.contentView addSubview:leftLabel];
        [view.contentView addSubview:rightLabel];
        [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(15);
            make.centerY.equalTo(0);
            make.width.equalTo((MainWidth - 30)*.6);
            make.height.equalTo(30);
        }];
        [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(0);
            make.right.equalTo(-15);
            make.height.equalTo(30);
            make.width.equalTo((MainWidth - 30)*.4);
        }];
    }
    UILabel *leftLb = [view viewWithTag:100];
    UILabel *rightLb = [view viewWithTag:101];
    FGSourceDetailDropsModel *dropModel = self.dataArray[section];
    leftLb.text = dropModel.name;
    rightLb.text = dropModel.ap;
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return @" ";
}


//
#pragma mark - Lazy load
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, MainHeight - HeightOfStaAndNav - HeightOfFromBottom) style:UITableViewStyleGrouped]; //UITableViewStylePlain,section头部固定在顶部。UITableViewStyleGrouped,头部向上
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];//去掉底部多余线条
        _tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);//分割线两边距离为10
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//        _tableView.separatorColor = [UIColor redColor];//分割线颜色
        _tableView.estimatedRowHeight = 150; //行高
        [_tableView registerClass:[FGSourrceDetailTableViewCell class] forCellReuseIdentifier:@"FGSourrceDetailTableViewCell"];
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

@end
