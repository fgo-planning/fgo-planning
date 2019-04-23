//
//  FGLiZhuangTableViewCell.h
//  FGO
//
//  Created by 孔志林 on 2018/12/4.
//  Copyright © 2018年 KMingMing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FGHeroDetailModel.h"
@class FGLiZhuangTableViewCell;
@protocol FGLiZhuangTableViewCellDelegate<NSObject>
/**  点击查看卡面  */
- (void)tapFGLiZhuangTableViewCellLookBtn:(FGLiZhuangTableViewCell *)cell;
@end

@interface FGLiZhuangTableViewCell : UITableViewCell
@property (nonatomic, weak) id<FGLiZhuangTableViewCellDelegate> delegate;
/**  礼装model    */
@property (nonatomic, strong) FGHeroDetailCardInfoModel *cardInfoModel;
+ (CGFloat)p_getCellHeight;
@end
