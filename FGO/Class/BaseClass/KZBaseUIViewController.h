//
//  KZBaseUIViewController.h
//  KZBaseProject
//
//  Created by 孔志林 on 2018/6/7.
//  Copyright © 2018年 KMingMing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KZBaseUIViewController : UIViewController
- (void)p_setNavigationBarColor:(UIColor *)color translucent:(BOOL)isTranslucent;
- (void)p_setStatusBarBlackTextColorBlack:(BOOL)isBlack;
- (void)p_popViewController;
@end
