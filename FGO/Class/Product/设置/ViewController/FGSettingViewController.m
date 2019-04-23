//
//  FGSettingViewController.m
//  FGO
//
//  Created by 孔志林 on 2018/10/24.
//  Copyright © 2018年 KMingMing. All rights reserved.
//

#import "FGSettingViewController.h"
#import "FGCountViewController.h"
#import "FGVPNViewController.h"
@interface FGSettingViewController ()<UITableViewDelegate, UITableViewDataSource>
/**  tableView    */
@property (nonatomic, strong) UITableView *tableView;
/**  数据源    */
@property (nonatomic, strong) NSArray *dataArray;
@end

@implementation FGSettingViewController
#pragma mark - Life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self p_config];
    [self p_createUI];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
}
#pragma mark - Private methods
- (void)p_config
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem =  [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"KM_rightNvi"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemClick)];
    
    //读取plist
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"setting" ofType:@"plist"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
    [dic setObject:@"1" forKey:@"ABC"];
    self.dataArray = dic[@"arr"];
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
    NSDictionary *dic = self.dataArray[indexPath.section];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell"];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = dic[@"title"];
    cell.detailTextLabel.text = dic[@"detail"];
    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    if (indexPath.section == 0) {
        cell.detailTextLabel.text = kName;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        FGCountViewController *vc = [FGCountViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }else if(indexPath.section == 1) {
        FGVPNViewController *vc = [FGVPNViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.0f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewHeaderFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"UITableViewHeaderFooterView"];
    if (!view) {
        view = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"UITableViewHeaderFooterView"];
    }
    NSDictionary *dic = self.dataArray[section];

    view.textLabel.text = dic[@"topTitle"];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.1f;
}
//- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
//{
//    return @" ";
//}
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    return [UIView new];
//}


#pragma mark - Lazy load
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, MainHeight - HeightOfStaAndNav - HeightOfTabBar) style:UITableViewStyleGrouped]; //UITableViewStylePlain,section头部固定在顶部。UITableViewStyleGrouped,头部向上
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];//去掉底部多余线条
        _tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);//分割线两边距离为10
        //        _tableView.separatorColor = [UIColor redColor];//分割线颜色
        _tableView.rowHeight = 40; //行高
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

@implementation FGSettingModel
@end
