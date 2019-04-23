//
//  KZHelper.h
//  KZBaseProject
//
//  Created by 孔志林 on 2018/6/7.
//  Copyright © 2018年 KMingMing. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^LocationSuccessBlock)(NSDictionary *dic);

@interface KZHelper : NSObject
#pragma mark - 实例方法
/**  定位  */
- (void)p_startLocation:(LocationSuccessBlock)successBlock;

#pragma mark - 类方法
/**  单例  */
+ (instancetype)sharedInstance;
/**  获取当前控制器  */
+ (UIViewController *)p_getCurrentVC;


@end
