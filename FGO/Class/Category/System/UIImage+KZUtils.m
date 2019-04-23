//
//  UIImage+KZUtils.m
//  KZBaseProject
//
//  Created by 孔志林 on 2018/6/7.
//  Copyright © 2018年 KMingMing. All rights reserved.
//

#import "UIImage+KZUtils.h"

@implementation UIImage (KZUtils)
+ (UIImage *)p_imageWithColor:(UIColor *)color
{
    //创建1像素区域并开始图片绘图
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    
    //创建画板并填充颜色和区域
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    //从画板上获取图片并关闭图片绘图
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
+ (UIImage *)p_compressImageWithSize:(CGSize)size image:(UIImage *)image
{
    //开启上下文:生成的图片比"UIGraphicsBeginImageContext"方法更清晰。0.0代表不缩放
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
+ (UIImage *)p_compressImageWithKB:(CGFloat)kb image:(UIImage *)image
{
    if (!image) {
        return nil;
    }
    CGFloat maxBit = 1024 * kb;
    CGFloat compressionQuality = .9f;
    NSData *data = UIImageJPEGRepresentation(image, compressionQuality);
    
    while (data.length > maxBit && compressionQuality > 0) {
        compressionQuality -= 0.1;
        data = UIImageJPEGRepresentation(image, compressionQuality);
    }
    return [UIImage imageWithData:data];
}
+ (UIImage *)p_waterImageWith:(NSString *)title attributeDic:(NSDictionary *)attributeDic image:(UIImage *)image
{
    CGFloat rightSpace = 15; //距离屏幕右边
    CGFloat bottomSpace = 15; //距离屏幕下边
    //开启上下文
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:title attributes:attributeDic];
    
    CGRect titleRect = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributeDic context:nil];
    
    CGFloat x = image.size.width - titleRect.size.width - rightSpace;
    CGFloat y = image.size.height - titleRect.size.height - bottomSpace;
    
    [attributeStr drawInRect:CGRectMake(x, y, titleRect.size.width, titleRect.size.height)];
    
    image = UIGraphicsGetImageFromCurrentImageContext();
    //关闭上下文
    UIGraphicsEndImageContext();
    
    return image;
    
}
@end
