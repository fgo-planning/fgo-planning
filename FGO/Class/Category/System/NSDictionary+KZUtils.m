//
//  NSDictionary+KZUtils.m
//  KZBaseProject
//
//  Created by 孔志林 on 2018/6/7.
//  Copyright © 2018年 KMingMing. All rights reserved.
//

#import "NSDictionary+KZUtils.h"

@implementation NSDictionary (KZUtils)
+ (NSDictionary *)p_dicWithString:(NSString *)str
{
    //解码;
    str = [str stringByRemovingPercentEncoding];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSArray *paramArray = [str componentsSeparatedByString:@"&"];
    for (NSString *param in paramArray) {
        NSArray *array = [param componentsSeparatedByString:@"="];
        if (array.count == 2) {
            [dic setObject:array[1] forKey:array[0]];
        }
    }
    return dic;
}

/**字典是否为空,或元素个数是否为0
 *YES:不是字典类型或nil或空
 *NO: 是字典类型,且有元素;
 */
+(BOOL)isNullOrEmptyDictionary:(NSDictionary *)diction
{
    if (diction == nil ||![diction isKindOfClass:[NSDictionary class]] || diction.count <=0) {
        return YES;
    }
    return NO;
}
- (NSDictionary *)p_emptrProperty
{
    NSMutableDictionary *dic = [self mutableCopy];
    [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSString class]]) {
            obj = [NSString p_emptyStr:obj];
            [dic setObject:obj forKey:key];
        }
    }];
    return [dic copy];
}
+ (NSDictionary *)p_dicWithJsonString:(NSString *)jsonString
{
    if (!jsonString)
    {
        return nil;
    }else {
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    return dic;
    }
}
@end
