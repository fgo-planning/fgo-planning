//
//  UIColor+KZUtils.h
//  KZBaseProject
//
//  Created by 孔志林 on 2018/6/7.
//  Copyright © 2018年 KMingMing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (KZUtils)
/**
 设置颜色不透明
 
 @param hexstr 入参
 @return 返回颜色
 */
+ (UIColor*)p_colorWithHexString:(NSString *)hexstr;

/**
 设置颜色透明度
 
 @param hexstr @"666666"
 @param alphaValue 0.7
 @return color
 */
+ (UIColor *)p_colorWithHexString:(NSString *)hexstr alpha:(CGFloat)alphaValue;

/**
 返回一个随机颜色
 
 @return 随机色
 */
+ (UIColor *)p_randomColor;

/**
 rgb Color

 @param r r
 @param g g
 @param b b
 @return 颜色
 */
+ (UIColor *)p_rgbColorR:(CGFloat)r G:(CGFloat)g B:(CGFloat)b;
@end
