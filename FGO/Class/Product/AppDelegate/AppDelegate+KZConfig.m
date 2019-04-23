//
//  AppDelegate+KZConfig.m
//  KZBaseProject
//
//  Created by 孔志林 on 2018/6/7.
//  Copyright © 2018年 KMingMing. All rights reserved.
//

#import "AppDelegate+KZConfig.h"
#import <AFNetworkActivityIndicatorManager.h>
#import <AFNetworkReachabilityManager.h>
#import <MLTransition.h>
#import <IQKeyboardManager.h>
#import <SVProgressHUD.h>
#import "KZBaseUINavigationController.h"
#import "KZBaseUITabBarController.h"
#import "FGMainViewController.h"
#import "FGSettingViewController.h"

@implementation AppDelegate (KZConfig)
#pragma mark 解决自定义按钮右划返回失败
- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //自定义左上角返回按钮, 导致右划返回失效
    [MLTransition validatePanBackWithMLTransitionGestureRecognizerType:MLTransitionGestureRecognizerTypeScreenEdgePan];
    return YES;
}
#pragma mark - 禁止ipad横屏
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(nullable UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait;
}
#pragma mark 设置根视图控制器
- (void)p_setRootViewController
{
    [self captureException];//捕获异常
    
    self.window = [[UIWindow alloc] initWithFrame:BoundsOfMainScreen];
    self.window.backgroundColor = [UIColor whiteColor];
    
    FGMainViewController *mainVC = [FGMainViewController new];
    mainVC.navigationItem.title = @"首页";
    mainVC.tabBarItem.title = @"首页";
    mainVC.tabBarItem.image = [UIImage imageNamed:@"main_off"];
    mainVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"main_on"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];;
    KZBaseUINavigationController *mainNV = [[KZBaseUINavigationController alloc] initWithRootViewController:mainVC];
    
    FGSettingViewController *settingVC = [FGSettingViewController new];
    settingVC.navigationItem.title = @"设置";
    settingVC.tabBarItem.title = @"设置";
    settingVC.tabBarItem.image = [UIImage imageNamed:@"setting_off"];
    settingVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"setting_on"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    KZBaseUINavigationController *settingNV = [[KZBaseUINavigationController alloc] initWithRootViewController:settingVC];
    
    KZBaseUITabBarController *tabBarVC = [KZBaseUITabBarController new];
    tabBarVC.viewControllers = @[mainNV, settingNV];
    
    self.window.rootViewController = tabBarVC;
    [self.window makeKeyAndVisible];
}
#pragma mark - 捕获异常
- (void)captureException
{
    NSSetUncaughtExceptionHandler(&UncaughtExceptionHandler);
}
/**
 *  获取异常崩溃信息
 */
void UncaughtExceptionHandler(NSException *exception) {

    NSArray *callStack = [exception callStackSymbols];
    NSString *reason = [exception reason];
    NSString *name = [exception name];
    NSString *content = [NSString stringWithFormat:@"========异常错误报告========\nname:%@\nreason:\n%@\ncallStackSymbols:\n%@",name,reason,[callStack componentsJoinedByString:@"\n"]];
    NSLog(@"%@",content);
    
    /**
     *  把异常崩溃信息保存下次打开提示用户发送给开发者
     */
    [[NSUserDefaults standardUserDefaults] setObject:content forKey:@"mainUrl"];

}

#pragma mark - 全局设置
- (void)p_setGlobalConfig
{
    [self configSTSniffingSDK];//抓包

    [self configIQKeyboardManager];
    [self configSVProgressHUD];
//    [self configiOS11];
//    [self sendErrorEmail];
    [self startMonitoring];
}
#pragma mark - 提示用户发送崩溃日志给开发者
- (void)sendErrorEmail
{
    NSString *content = [[NSUserDefaults standardUserDefaults] objectForKey:@"mainUrl"];
    if (content) {
        NSMutableString *mainUrl = [NSMutableString string];
        [mainUrl appendString:@"mailto:862176213@qq.com"];
        [mainUrl appendString:@"?subject=你的代码有Bug,报告拿走，告辞！"];
        [mainUrl appendFormat:@"&body=%@", content];
#if DEBUG
        UIAlertController *avc = [UIAlertController alertControllerWithTitle:@"出错啦" message:content preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [avc addAction:sure];

        [self.window.rootViewController presentViewController:avc animated:YES completion:^{
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"mainUrl"];
        }];
#else
        UIAlertController *avc = [UIAlertController alertControllerWithTitle:@"好像有异常" message:@"你愿意发送异常报告邮件给程序员小哥哥吗😊!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"算了" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *sure = [UIAlertAction actionWithTitle:@"好哒" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            NSString *mailPath = [mainUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:mailPath]];
        }];
        [avc addAction:cancle];
        [avc addAction:sure];
        [self.window.rootViewController presentViewController:avc animated:YES completion:^{
          [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"mainUrl"];
        }];
#endif
    }
}
#pragma mark - 注册Vpn
- (void)configSTSniffingSDK
{
    [self GET:@"https://www.baidu.com/" paramaters:nil success:^(NSURLSessionDataTask *dataTask, id response) {
        NSLog(@"成功");
    } failure:^(id error) {
        
    }];
    // 必须：启动后注册 AppId 和 设置 AppGroup
    [[STSniffingSDK sharedInstance] registerAppId:@"bbc9b93bbc7ec7ad0475d5d0aadfa1af"];
    [[STSniffingSDK sharedInstance] setExtensionGroup:@"group.com.fgopy.www.FGO"];
}
#pragma mark 设置键盘管理
- (void)configIQKeyboardManager
{
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;//控制整个功能是否启用。
    manager.shouldResignOnTouchOutside = YES;//控制点击背景是否收起键盘。
    manager.shouldToolbarUsesTextFieldTintColor = NO;//控制键盘上的工具条文字颜色是否用户自定义。
    manager.enableAutoToolbar = YES;//控制是否显示键盘上的工具条。
}
#pragma mark 配置SVProgressHUD
- (void)configSVProgressHUD
{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    [SVProgressHUD setBackgroundColor:[UIColor p_colorWithHexString:@"ff000000" alpha:0.7]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    
}
#pragma mark 监测网络活动
- (void)startMonitoring
{
    //监测网络活动
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    //监测网络状态
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"wifi");
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"3g/4g");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"没有网络");
                break;
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"未知网络");
                break;
            default:
                break;
        }
    }];
    [manager startMonitoring];
}
#pragma mark 监测是否有网
- (BOOL)isOnline
{
    AFNetworkReachabilityStatus status = [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus;
    switch (status) {
        case AFNetworkReachabilityStatusUnknown:
        case AFNetworkReachabilityStatusNotReachable: {
            return NO;
            break;
        }
        case AFNetworkReachabilityStatusReachableViaWWAN:
        case AFNetworkReachabilityStatusReachableViaWiFi: {
            return YES;
            break;
        }
    }
}
#pragma mark 检测是否是wifi
- (BOOL)isWifi
{
    AFNetworkReachabilityStatus status = [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus;
    switch (status) {
        case AFNetworkReachabilityStatusUnknown:
        case AFNetworkReachabilityStatusNotReachable:
        case AFNetworkReachabilityStatusReachableViaWWAN:
        {
            return NO;
            break;
        }
        case AFNetworkReachabilityStatusReachableViaWiFi: {
            return YES;
            break;
        }
    }
}
#pragma mark 适配iOS11
- (void)configiOS11
{
    /**  iOS11新增属性  */
    if (@available(iOS 11.0, *)) {
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
        
        // 去掉iOS11系统默认开启的self-sizing
        [UITableView appearance].estimatedRowHeight = 0;
        [UITableView appearance].estimatedSectionHeaderHeight = 0;
        [UITableView appearance].estimatedSectionFooterHeight = 0;
    } else {
        // Fallback on earlier versions
    }
}


@end
