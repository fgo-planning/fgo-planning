//
//  KZBaseUINavigationController.m
//  KZBaseProject
//
//  Created by 孔志林 on 2018/6/7.
//  Copyright © 2018年 KMingMing. All rights reserved.
//

#import "KZBaseUINavigationController.h"

UIColor * navBackColor () {
    return [[UIColor blackColor] colorWithAlphaComponent:1];
}


@interface KZBaseUINavigationController ()

@end

@implementation KZBaseUINavigationController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self p_configure];
}
#pragma mark 重写系统方法,push时隐藏tabBar
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    //    [super pushViewController:viewController animated:animated];
    //    if (self.viewControllers.count > 1) {
    //        viewController.hidesBottomBarWhenPushed = YES;
    //    }
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
    
    //解决iphoneXS “tabBar偏移bug”
    if (IS_IPHONE_X && self.tabBarController) {
        CGRect frame = self.tabBarController.tabBar.frame;
        if (!CGRectEqualToRect(frame, CGRectZero) &&
            frame.origin.y != CGRectGetHeight([UIScreen mainScreen].bounds) -CGRectGetHeight(frame)) {
            frame.origin.y = CGRectGetHeight([UIScreen mainScreen].bounds) -CGRectGetHeight(frame);
        }
        self.tabBarController.tabBar.frame = frame;
    }
}
#pragma mark - 重写此方法使得子控制器中 -preferredStatusBarStyle 方法生效 当前的
- (UIViewController *)childViewControllerForStatusBarStyle
{
    return self.visibleViewController;
}

#pragma mark - Private methods
- (void)p_configure
{
    //导航栏和状态栏背景色
    //    [[UINavigationBar appearance] setBarTintColor:[UIColor redColor]];
    UIImage *image = [UIImage p_imageWithColor:navBackColor()];
    [[UINavigationBar appearance] setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
    //状态栏风格为黑色
    //    [[UINavigationBar appearance] setBarStyle:UIBarStyleDefault];
    //系统BarButtonItem字体颜色
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    //    [UINavigationBar appearance].translucent = YES;//透明
    //设置导航栏标题字体、颜色
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:18],NSForegroundColorAttributeName : [UIColor whiteColor]}];
    //设置导航条底部线条为透明
    self.navigationBar.shadowImage = [UIImage new];
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
@end
