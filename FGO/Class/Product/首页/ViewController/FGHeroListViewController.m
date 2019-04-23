//
//  FGHeroListViewController.m
//  FGO
//
//  Created by 孔志林 on 2018/11/6.
//  Copyright © 2018年 KMingMing. All rights reserved.
//

#import "FGHeroListViewController.h"
#import "FGHeroModel.h"
#import "FGHeroDetailViewController.h"
@interface FGHeroListViewController ()<UITableViewDelegate, UITableViewDataSource>
/**  tableView    */
@property (nonatomic, strong) UITableView *tableView;
/**  数据源    */
@property (nonatomic, strong) NSArray *dataArray;
@end

@implementation FGHeroListViewController
#pragma mark - Life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self p_config];
    [self p_createUI];
}

#pragma mark - Private methods
- (void)p_config
{
    self.navigationItem.title = @"";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem =  [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@""] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemClick)];
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
    return self.models.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UITableViewCell"];
    }
    FGHeroModel *model = self.models[indexPath.row];
    cell.textLabel.text = model.name;
    cell.detailTextLabel.text = model.clazz;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@    ID: %@",model.clazz, model.heroID];
    
    FGVPNHeroModel *vpnModel = model.vpnModel;
    if (vpnModel.lv) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@    LV%@ %@/%@/%@",model.clazz, vpnModel.lv,vpnModel.skillLv1,vpnModel.skillLv2,vpnModel.skillLv3];
    }
    
    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:model.imgPath ofType:nil];
    if (imagePath) {
        cell.imageView.image = [UIImage imageWithContentsOfFile:imagePath];
    }else
    {
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:model.imgPath]];
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
    FGHeroDetailViewController *vc = [FGHeroDetailViewController new];
    FGHeroModel *model = self.models[indexPath.row];
    vc.ID = model.ID;
    vc.heroModel = model;
    vc.heroName = model.name;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Lazy load
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, MainHeight - HeightOfStaAndNav - HeightOfFromBottom - 100) style:UITableViewStylePlain]; //UITableViewStylePlain,section头部固定在顶部。UITableViewStyleGrouped,头部向上
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = YES;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];//去掉底部多余线条
        _tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);//分割线两边距离为10
        //        _tableView.separatorColor = [UIColor redColor];//分割线颜色
        _tableView.rowHeight = 60; //行高
        //        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    }
    return _tableView;
}
- (NSArray *)dataArray
{
    if (_dataArray) {
        _dataArray = [NSArray array];
    }
    return _dataArray;
}
@end
