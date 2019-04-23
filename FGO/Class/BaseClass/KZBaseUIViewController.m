//
//  KZBaseUIViewController.m
//  KZBaseProject
//
//  Created by 孔志林 on 2018/6/7.
//  Copyright © 2018年 KMingMing. All rights reserved.
//

#import "KZBaseUIViewController.h"

@interface KZBaseUIViewController ()

@end

@implementation KZBaseUIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self p_configure];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    /**  设置默认的导航栏颜色    */
//    [self p_setNavigationBarColor:[UIColor orangeColor] translucent:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private methods
- (void)p_configure
{
    NSUInteger count = self.navigationController.viewControllers.count;
    if (count > 1) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        //        button.backgroundColor = [UIColor redColor];
        button.frame = CGRectMake(0, 0, 30, 30);
        [button setImage:[UIImage imageNamed:@"FG_back"] forState:UIControlStateNormal];
        button.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 10);
        [button addTarget:self action:@selector(p_popViewController) forControlEvents:UIControlEventTouchUpInside];
        UIView *btView = [[UIView alloc] initWithFrame:button.frame];
        [btView addSubview:button];
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btView];
        self.navigationItem.leftBarButtonItem = item;
    }
}

- (void)p_popViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)p_setNavigationBarColor:(UIColor *)color translucent:(BOOL)isTranslucent
{
    self.navigationController.navigationBar.translucent = isTranslucent;
    UIImage *image = [UIImage p_imageWithColor:color];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
}
- (void)p_setStatusBarBlackTextColorBlack:(BOOL)isBlack
{
    [UIApplication sharedApplication].statusBarStyle = isBlack ? UIStatusBarStyleDefault : UIStatusBarStyleLightContent;
}
@end
