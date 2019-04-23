//
//  NSString+KZUtils.h
//  KZBaseProject
//
//  Created by 孔志林 on 2018/6/7.
//  Copyright © 2018年 KMingMing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (KZUtils)
/**字符串是否为空*/
+ (BOOL)isEmptyStr:(NSString *)string;
/**将空字符串转为@“”*/
+ (NSString *)p_emptyStr:(NSString *)string;

/**
 字典转成参数字符串，使用&拼接
 
 @param dic 字典
 @param encoding 是否编码
 @return 字符串
 */
+ (NSString *)p_stringWithDic:(NSDictionary *)dic encoding:(BOOL)encoding;

/**
 字典转成json字符串

 @param dic 入参字典
 @return jsonString
 */
+ (NSString *)p_jsonStringWithDic:(NSDictionary *)dic;

/**
 md5编码(不能解码)

 @param str 入参
 @return md5 string
 */
+ (NSString *)p_md5:(NSString *)str;

/**
 base64编码

 @param string 要编码的字符串
 @return base64编码后的字符串
 */
+ (NSString *)p_base64Encode:(NSString *)string;

/**
 base64解码

 @param base64String 要解码的base64字符串
 @return base64解码后的字符串
 */
+ (NSString *)p_base64Dencode:(NSString *)base64String;

/**
 URL编码

 @param string 要URL编码的字符串
 @return URL 编码后的字符串
 */
+ (NSString *)p_URLEncode:(NSString *)string;

/**
 URL解码

 @param urlEncodeStr 要URL解码的字符串
 @return URL解码后的字符串
 */
+ (NSString *)p_URLDencode:(NSString *)urlEncodeStr;
@end
