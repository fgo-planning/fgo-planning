//
//  UIButton+KZUtils.h
//  KZBaseProject
//
//  Created by 孔志林 on 2018/7/4.
//  Copyright © 2018年 KMingMing. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, KZImageLocation) {
    KZImageAtTop,
    KZImageAtBottom,
    KZImageAtRight,
    KZImageAtLeft
};

@interface UIButton (KZUtils)
- (void)p_changeImageLocation:(KZImageLocation)imageLocation space:(CGFloat)space;
@end
