//
//  NSArray+KZUtils.m
//  KZBaseProject
//
//  Created by 孔志林 on 2018/6/7.
//  Copyright © 2018年 KMingMing. All rights reserved.
//

#import "NSArray+KZUtils.h"

@implementation NSArray (KZUtils)
/**数组是否为nil或count== 0*/
+(BOOL)isNullOrEmptyArray:(NSArray *)array
{
    if ( array == nil ||  [array isKindOfClass:[NSNull class]] || ![array isKindOfClass:[NSArray class]] || array.count == 0) {
        return YES;
    }
    return NO;
}
@end
