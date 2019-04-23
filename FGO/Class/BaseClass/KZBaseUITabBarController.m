//
//  KZBaseUITabBarController.m
//  KZBaseProject
//
//  Created by 孔志林 on 2018/6/7.
//  Copyright © 2018年 KMingMing. All rights reserved.
//

#import "KZBaseUITabBarController.h"

@interface KZBaseUITabBarController ()<UITabBarControllerDelegate>

@end

@implementation KZBaseUITabBarController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self p_configure];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private methods
- (void)p_configure
{
    //设置文字属性正常状态
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor grayColor],NSFontAttributeName : [UIFont fontWithName:@"ArialMT" size:14]} forState:UIControlStateNormal];
    //设置选中状态文字属性
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor p_rgbColorR:42 G:165 B:20], NSFontAttributeName : [UIFont fontWithName:@"ArialMT" size:14]} forState:UIControlStateSelected];
    /**  设置此颜色可以配合设置选中状态图片颜色，也就是说只需要一张图片就够了。    */
    [[UITabBar appearance] setTintColor:[UIColor p_colorWithHexString:@"e1302a"]];
    //    [[UITabBar appearance] setTranslucent:NO];
    self.delegate = self;
    
//    [[UITabBar appearance] setShadowImage:[UIImage new]];
//    [[UITabBar appearance] setBackgroundImage:[UIImage p_imageWithColor:[UIColor whiteColor]]];

}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    if (tabBarController.selectedIndex == 3) {
        //判断是否登录。。。
    }
    return YES;
}

@end
