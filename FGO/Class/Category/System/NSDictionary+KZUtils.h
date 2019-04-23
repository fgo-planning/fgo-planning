//
//  NSDictionary+KZUtils.h
//  KZBaseProject
//
//  Created by 孔志林 on 2018/6/7.
//  Copyright © 2018年 KMingMing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (KZUtils)
/**
 字符串回转成字典
 
 @param str 字典生成的字符串
 @return 字典
 */
+ (NSDictionary *)p_dicWithString:(NSString *)str;

/**字典是否为空,或元素个数是否为0
 *YES:不是字典类型或nil或空
 *NO: 是字典类型,且有元素;
 */
+(BOOL)isNullOrEmptyDictionary:(NSDictionary *)diction;

/**
 去除字典中的无效字符串，统一转成@""

 @return 字典
 */
- (NSDictionary *)p_emptrProperty;

/**
 jsonString转换成字典

 @param jsonString 入参jsonString
 @return 字典
 */
+ (NSDictionary *)p_dicWithJsonString:(NSString *)jsonString;
@end
