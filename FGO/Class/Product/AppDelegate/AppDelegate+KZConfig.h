//
//  AppDelegate+KZConfig.h
//  KZBaseProject
//
//  Created by 孔志林 on 2018/6/7.
//  Copyright © 2018年 KMingMing. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (KZConfig)
/**
 设置根视图控制器
 */
- (void)p_setRootViewController;
/**
 全局设置
 */
- (void)p_setGlobalConfig;
/**  是否有网    */
@property (nonatomic, readonly, getter=isOnline) BOOL online;
/**  是否是wifi    */
@property (nonatomic, readonly, getter=isWifi) BOOL wifi;
@end
