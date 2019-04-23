//
//  NSObject+KZProgressHUD.h
//  KZBaseProject
//
//  Created by 孔志林 on 2018/6/7.
//  Copyright © 2018年 KMingMing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (KZProgressHUD)

/**  圆圈转，可以用于下载  */
- (void)p_SVProgressHUDBegin:(NSString *)message;
- (void)p_SVProgressHUDSuccess:(NSString *)message;
- (void)p_SVProgressHUDError:(NSString *)message;
- (void)p_SVProgressHUDDismiss;

/**
 菊花转圈圈,用户网络请求
 */
- (void)p_showMBProgressHUD;
- (void)p_hideMBProgressHUD;
/**  toast 只显示文字的弹窗,一段时间后消失   */
- (void)p_toast:(NSString *)message;
@end
