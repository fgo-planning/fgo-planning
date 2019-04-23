//
//  NSObject+KZUtils.m
//  KZBaseProject
//
//  Created by 孔志林 on 2018/6/20.
//  Copyright © 2018年 KMingMing. All rights reserved.
//

#import "NSObject+KZUtils.h"

@implementation NSObject (KZUtils)
- (void)p_alertTitle:(NSString *)title message:(NSString *)message sureBlock:(void (^)(UIAlertAction *))sureBlock
{
    UIAlertController* alertVC = [UIAlertController alertControllerWithTitle:title
                                                                     message:message
                                                              preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel
                                                         handler:nil];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定"
                                                         style:UIAlertActionStyleDefault
                                                       handler:sureBlock];
    [alertVC addAction:cancleAction];
    [alertVC addAction:sureAction];
    UIViewController *vc = [KZHelper p_getCurrentVC];
    [vc presentViewController:alertVC animated:YES completion:nil];
}
@end
