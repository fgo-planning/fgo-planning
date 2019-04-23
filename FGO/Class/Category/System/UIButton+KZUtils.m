//
//  UIButton+KZUtils.m
//  KZBaseProject
//
//  Created by 孔志林 on 2018/7/4.
//  Copyright © 2018年 KMingMing. All rights reserved.
//

#import "UIButton+KZUtils.h"

@implementation UIButton (KZUtils)
#pragma mark - 改变图片的位置
- (void)p_changeImageLocation:(KZImageLocation)imageLocation space:(CGFloat)space
{
    // 1. 得到imageView和titleLabel的宽、高
    CGFloat imageWith = self.imageView.frame.size.width;
    CGFloat imageHeight = self.imageView.frame.size.height;
    CGFloat titleWidth = 0.0;
    CGFloat titleHeight = 0.0;
    
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        // 由于iOS8中titleLabel的size为0，用下面的这种设置
        titleWidth = self.titleLabel.intrinsicContentSize.width;
        titleHeight = self.titleLabel.intrinsicContentSize.height;
    } else {
        titleWidth = self.titleLabel.frame.size.width;
        titleHeight = self.titleLabel.frame.size.height;
    }
    
    UIEdgeInsets imageEdgeInsets = UIEdgeInsetsZero;
    UIEdgeInsets labelEdgeInsets = UIEdgeInsetsZero;
    
    switch (imageLocation) {
        case KZImageAtTop:
        {
            imageEdgeInsets = UIEdgeInsetsMake(-titleHeight-space, 0, 0, -titleWidth);
            labelEdgeInsets = UIEdgeInsetsMake(0, -imageWith, -imageHeight-space, 0);
        }
            break;
        case KZImageAtBottom:
        {
            imageEdgeInsets = UIEdgeInsetsMake(0, 0, -titleHeight-space, -titleWidth);
            labelEdgeInsets = UIEdgeInsetsMake(-imageHeight-space, -imageWith, 0, 0);
        }
            break;
        case KZImageAtLeft:
        {
            imageEdgeInsets = UIEdgeInsetsMake(0, -space/2.0, 0, space/2.0);
            labelEdgeInsets = UIEdgeInsetsMake(0, space/2.0, 0, -space/2.0);
        }
            break;
        case KZImageAtRight:
        {
            imageEdgeInsets = UIEdgeInsetsMake(0, titleWidth+space/2.0, 0, -titleWidth-space/2.0);
            labelEdgeInsets = UIEdgeInsetsMake(0, -imageWith-space/2.0, 0, imageWith+space/2.0);
        }
            break;
        default:
            break;
    }
    self.titleEdgeInsets = labelEdgeInsets;
    self.imageEdgeInsets = imageEdgeInsets;
}
@end
