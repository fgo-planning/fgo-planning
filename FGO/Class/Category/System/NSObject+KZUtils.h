//
//  NSObject+KZUtils.h
//  KZBaseProject
//
//  Created by 孔志林 on 2018/6/20.
//  Copyright © 2018年 KMingMing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (KZUtils)

/**
 alert弹窗

 @param title title
 @param message message
 @param sureBlock 点击确定按钮回调
 */
- (void)p_alertTitle:(NSString *)title
             message:(NSString *)message
           sureBlock:(void (^)(UIAlertAction *action))sureBlock;
@end
