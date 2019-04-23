//
//  NSString+KZUtils.m
//  KZBaseProject
//
//  Created by 孔志林 on 2018/6/7.
//  Copyright © 2018年 KMingMing. All rights reserved.
//

#import "NSString+KZUtils.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (KZUtils)
+ (NSString *)p_stringWithDic:(NSDictionary *)dic encoding:(BOOL)encoding
{
    NSArray *array = [dic allKeys];
    NSString *str = @"";
    for (int i = 0; i < array.count; i++) {
        NSString *key = array[i];
        if (i>0) {
            str = [str stringByAppendingString:[NSString stringWithFormat:@"&%@=%@",key,[dic objectForKey:key]]];
        }else
        {
            str = [str stringByAppendingString:[NSString stringWithFormat:@"%@=%@",key,[dic objectForKey:key]]];
        }
    }
    if (encoding) {
        return [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }else {
        return str;
    }
}

+ (BOOL)isEmptyStr:(NSString *)str
{
    if (str == nil || [str isKindOfClass:[NSNull class]]) {
        return YES;
    }
    NSString *string = [NSString stringWithFormat:@"%@",str];
    
    return string == (id)[NSNull null] || [string isEqualToString: @""] || string.length == 0 || [string isEqualToString:@"(null)" ] || [string isEqualToString:@"null"] |[string isEqualToString:@"<null>"]|| [string isEqualToString:@"0(NSNull)"];  //4.0.9增加
}

+ (NSString *)p_emptyStr:(NSString *)string
{
    if ([self isEmptyStr:string]) {
        return @"";
    }
    return string;
}

+ (NSString *)p_jsonStringWithDic:(NSDictionary *)dic
{
    if (!dic)
    {
        return @"";
    }else {
        /**  NSJSONWritingPrettyPrinted:使生成的数据更具可读性。  */
        NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
        if (data)
        {
            NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            return jsonString;
        }else {
            return @"";
        }
    }
}

+ (NSString *)p_md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

+ (NSString *)p_base64Encode:(NSString *)string
{
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    
//    NSData *base64Data = [data base64EncodedDataWithOptions:0];
//    NSString *baseString = [[NSString alloc]initWithData:base64Data encoding:NSUTF8StringEncoding];

    NSString *baseString = [data base64EncodedStringWithOptions:0];

    return baseString;
}

+ (NSString *)p_base64Dencode:(NSString *)base64String
{
    NSData *data = [[NSData alloc] initWithBase64EncodedString:base64String options:NSDataBase64DecodingIgnoreUnknownCharacters];
    
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    return string;
}

+ (NSString *)p_URLEncode:(NSString *)string
{
    static NSString * const kAFCharactersGeneralDelimitersToEncode = @":#[]@"; // does not include "?" or "/" due to RFC 3986 - Section 3.4
    static NSString * const kAFCharactersSubDelimitersToEncode = @"!$&'()*+,;=";
    
    NSMutableCharacterSet * allowedCharacterSet = [[NSCharacterSet URLQueryAllowedCharacterSet] mutableCopy];
    [allowedCharacterSet removeCharactersInString:[kAFCharactersGeneralDelimitersToEncode stringByAppendingString:kAFCharactersSubDelimitersToEncode]];
    static NSUInteger const batchSize = 50;
    
    NSUInteger index = 0;
    NSMutableString *escaped = @"".mutableCopy;
    
    while (index < string.length) {
        NSUInteger length = MIN(string.length - index, batchSize);
        NSRange range = NSMakeRange(index, length);
        // To avoid breaking up character sequences such as 👴🏻👮🏽
        range = [string rangeOfComposedCharacterSequencesForRange:range];
        NSString *substring = [string substringWithRange:range];
        NSString *encoded = [substring stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet];
        [escaped appendString:encoded];
        
        index += range.length;
    }
    return escaped;
    
//    return  [string stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

+ (NSString *)p_URLDencode:(NSString *)urlEncodeStr
{
    return [urlEncodeStr stringByRemovingPercentEncoding];
}
@end
