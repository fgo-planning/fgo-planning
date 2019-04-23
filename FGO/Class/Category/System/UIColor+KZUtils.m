//
//  UIColor+KZUtils.m
//  KZBaseProject
//
//  Created by 孔志林 on 2018/6/7.
//  Copyright © 2018年 KMingMing. All rights reserved.
//

#import "UIColor+KZUtils.h"

@implementation UIColor (KZUtils)
+ (UIColor *)p_randomColor
{
    CGFloat red = random()%255/255.0;
    CGFloat green = random()%255/255.0;
    CGFloat blue = random()%255/255.0;
    return [UIColor colorWithRed:red green:green blue:blue alpha:1];
}
+ (UIColor *)p_colorWithHexString:(NSString *)hexstr alpha:(CGFloat)alphaValue
{
    NSScanner *scanner;
    unsigned int rgbval;
    scanner = [NSScanner scannerWithString: hexstr];
    [scanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@"#"]];
    [scanner scanHexInt: &rgbval];
    return [UIColor colorWithHex: rgbval alpha:alphaValue];
}
+ (UIColor*)p_colorWithHexString:(NSString *)hexstr
{
    return [UIColor p_colorWithHexString:hexstr alpha:1.0f];
}
+(UIColor *)colorWithHex:(NSUInteger)color alpha:(CGFloat)alpha {
    return [UIColor colorWithRed:((color & 0xff0000) >> 16) / 255.0f
                           green:((color & 0xff00) >> 8) / 255.0f
                            blue:(color & 0xff) / 255.0f
                           alpha:alpha];
}
+ (UIColor *)p_rgbColorR:(CGFloat)r G:(CGFloat)g B:(CGFloat)b
{
    CGFloat red = r / 255.0;
    CGFloat green = g / 255.0;;
    CGFloat blue = b / 255.0;;
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
}

@end
