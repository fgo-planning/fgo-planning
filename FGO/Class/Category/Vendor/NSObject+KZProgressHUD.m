//
//  NSObject+KZProgressHUD.m
//  KZBaseProject
//
//  Created by 孔志林 on 2018/6/7.
//  Copyright © 2018年 KMingMing. All rights reserved.
//

#import "NSObject+KZProgressHUD.h"
#import <SVProgressHUD.h>
#import <MBProgressHUD.h>

static const NSTimeInterval interval = 1.0;

@implementation NSObject (KZProgressHUD)
#pragma mark - 转圈圈,可以用在下载时
- (void)p_SVProgressHUDBegin:(NSString *)message
{
    [SVProgressHUD showWithStatus:message];
    //    [SVProgressHUD dismissWithDelay:interval];
}
#pragma mark 成功
- (void)p_SVProgressHUDSuccess:(NSString *)message
{
    [SVProgressHUD showSuccessWithStatus:message];
    [SVProgressHUD dismissWithDelay:interval];
}
#pragma mark 失败
- (void)p_SVProgressHUDError:(NSString *)message
{
    [SVProgressHUD showErrorWithStatus:message];
    [SVProgressHUD dismissWithDelay:interval];
}
#pragma mark 移除
- (void)p_SVProgressHUDDismiss
{
    [SVProgressHUD dismiss];
}


#pragma mark 菊花
- (void)p_showMBProgressHUD
{
    UIViewController *vc = [KZHelper p_getCurrentVC];
    [MBProgressHUD showHUDAddedTo:vc.view animated:YES];
}
- (void)p_hideMBProgressHUD
{
    UIViewController *vc = [KZHelper p_getCurrentVC];
    [MBProgressHUD hideHUDForView:vc.view animated:YES];
    
}
#pragma mark 纯文字toast
- (void)p_toast:(NSString *)message
{
    UIViewController *vc = [KZHelper p_getCurrentVC];
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:vc.view];
    [vc.view addSubview:hud];
    hud.labelText = message;
    hud.mode = MBProgressHUDModeText;//设置模式.菊花、纯文字等
    hud.yOffset = HeightOfMainScreen / 2.0 - 300;//y轴偏移量
    hud.animationType = MBProgressHUDAnimationFade; //动画类型

//    hud.activityIndicatorColor = [UIColor greenColor];//设置菊花颜色,不起作用哦
//    hud.color = [UIColor purpleColor];//hud的背景色
//    hud.labelColor = [UIColor redColor];//文字颜色
//    hud.detailsLabelText = @"这是detilsLabelText";
//    hud.dimBackground = YES;//出现时会有个背景，哎呦，不错哦
    
    [hud showAnimated:YES whileExecutingBlock:^{
        sleep(2);//设置多少秒后隐藏
    } completionBlock:^{
        //        [hud removeFromSuperview];
        [MBProgressHUD hideHUDForView:vc.view animated:YES];
    }];
}
@end
