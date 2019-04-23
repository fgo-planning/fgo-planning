//
//  UIImage+KZUtils.h
//  KZBaseProject
//
//  Created by 孔志林 on 2018/6/7.
//  Copyright © 2018年 KMingMing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (KZUtils)
/**
 颜色转成图片
 
 @param color 颜色
 @return 颜色生成的图片
 */
+ (UIImage *)p_imageWithColor:(UIColor *)color;

/**
 压缩图片到指定size

 @param size 传入size
 @return 压缩后的image
 */
+ (UIImage *)p_compressImageWithSize:(CGSize)size image:(UIImage *)image;

/**
 压缩图片到指定kb

 @param kb 传入不大于kb
 @return 压缩后的image
 */
+ (UIImage *)p_compressImageWithKB:(CGFloat)kb image:(UIImage *)image;

/**
 添加文字水印

 @param title 要添加的文字
 @return 添加水印的图片
 */
+ (UIImage *)p_waterImageWith:(NSString *)title attributeDic:(NSDictionary *)attributeDic image:(UIImage *)image;
@end
