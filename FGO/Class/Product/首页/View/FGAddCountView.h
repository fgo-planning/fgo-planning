//
//  FGAddCountView.h
//  FGO
//
//  Created by 孔志林 on 2018/12/7.
//  Copyright © 2018年 KMingMing. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FGAddCountViewDelegate<NSObject>
- (void)FGAddCountView:(UITextField *)textFild index:(NSIndexPath *)indexPath;

@end

@interface FGAddCountView : UIView
@property (nonatomic, strong) UITextField *tf;
/**  cell下标    */
@property (nonatomic, strong) NSIndexPath *indexPath;
/**  代理    */
@property (nonatomic, weak) id<FGAddCountViewDelegate> delegate;
@end

