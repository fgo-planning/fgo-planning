//
//  KZBaseModel.m
//  KZBaseProject
//
//  Created by 孔志林 on 2018/6/7.
//  Copyright © 2018年 KMingMing. All rights reserved.
//

#import "KZBaseModel.h"

@implementation KZBaseModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}
+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *dic = @{@"id" : @"ID", @"description" : @"des"};
    return [[JSONKeyMapper alloc] initWithDictionary:dic];
}
@end
