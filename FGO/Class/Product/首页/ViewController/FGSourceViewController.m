//
//  FGSourceViewController.m
//  FGO
//
//  Created by 孔志林 on 2018/11/12.
//  Copyright © 2018年 KMingMing. All rights reserved.
//

#import "FGSourceViewController.h"
#import "FGSourceInfoViewController.h"
#import "FGMainVIiewModel.h"
@interface FGSourceViewController ()
@property (nonatomic, strong) NSArray *models;
@end

@implementation FGSourceViewController
#pragma mark - Life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self p_config];
    [self p_createUI];
    [self p_loadData];
}

#pragma mark - Private methods
- (void)p_loadData
{
    [[FGMainVIiewModel sharedInstance] getSource:^(id obj, NSURLSessionDataTask *dataTask) {
        self.models = obj;
        [self reloadData];
    } failure:^(id err) {
        
    }];
}
- (void)p_config
{
    self.navigationItem.title = @"素材信息";
    self.navigationItem.rightBarButtonItem =  [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@""] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemClick)];
    [self p_defaultSetting];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    //        button.backgroundColor = [UIColor redColor];
    button.frame = CGRectMake(0, 0, 30, 30);
    [button setImage:[UIImage imageNamed:@"FG_back"] forState:UIControlStateNormal];
    button.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 10);
    [button addTarget:self action:@selector(p_popViewController) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = item;

}
- (void)p_popViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)p_defaultSetting
{
    self.titles = @[@"素材数",@"技能石",@"职阶棋"];
    self.menuItemWidth = MainWidth/self.titles.count;
    self.progressWidth = MainWidth / (self.titles.count + 2);
    self.menuViewStyle = WMMenuViewStyleLine;
    self.titleColorSelected = kSelectedColor;
    //    self.progressColor = [UIColor redColor];//底下线条颜色
    self.view.backgroundColor = kGrayColor;
    [self reloadData];
}

- (void)p_createUI
{
}
- (void)rightBarButtonItemClick
{
    
}
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController
{
    return self.titles.count;
}

- (__kindof UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index
{
    FGSourceInfoViewController *vc = [FGSourceInfoViewController new];
    if (index == 0) {
        vc.isSuCai = YES;
    }
    vc.models = self.models[index];
    return vc;
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index
{
    return self.titles[index];
}
- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView
{
    return CGRectMake(0, 0, MainWidth, 40);
}
- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView
{
    CGFloat distance = pageController.menuView.height + 10;
    return CGRectMake(0, pageController.menuView.bottom + 10, MainWidth, MainHeight - HeightOfStaAndNav - distance);
}


@end
