//
//  FGJiNengTableViewCell.h
//  FGO
//
//  Created by 孔志林 on 2018/11/21.
//  Copyright © 2018年 KMingMing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FGHeroDetailModel.h"
#import "FGSaveJNModel.h"
@class FGJiNengTableViewCell;
@class FGJiNengLabelTableViewCellModel;
@class FGJiNengModel;
@protocol FGJiNengTableViewCellDelegate<NSObject>
- (void)sliderTableViewCell:(FGJiNengTableViewCell *)cell didSelected:(FGJiNengLabelTableViewCellModel *)model;
@end
@interface FGJiNengTableViewCell : UITableViewCell
+ (CGFloat)p_getCellHeight;
@property (nonatomic, weak) id<FGJiNengTableViewCellDelegate> delegate;
@property (nonatomic, assign) NSInteger section;

@end

@interface FGJiNengTopTableViewCell : FGJiNengTableViewCell
/**  更新改版状态    */
@property (nonatomic, strong) FGSaveJNModel *updateModel;
@property (nonatomic, strong) FGHeroDetailSkillModel *skillModel;
@end

@interface FGJiNengLabelTableViewCell : FGJiNengTableViewCell
/**  更新改版状态    */
@property (nonatomic, strong) FGSaveJNModel *updateModel;
@property (nonatomic, strong) FGHeroDetailSkillModel *skillModel;
/**  <##>    */
@property (nonatomic, strong) FGLevelsModel *levelsModel;
/**  <##>    */
@property (nonatomic, strong) FGJiNengModel *jiNengModel;
@end

@interface FGJiNengSliderTableViewCell : FGJiNengTableViewCell
/**  更新改版状态    */
@property (nonatomic, strong) FGSaveJNModel *updateModel;
@end


@interface FGJiNengLabelTableViewCellModel : NSObject
@property (nonatomic, assign) NSInteger section;
@property (nonatomic, assign) NSInteger sliderValue;
@property (nonatomic, copy  ) NSString *jndjLabel;
@property (nonatomic, assign) NSInteger labelTag;
/**  点击设置按钮保存的等级1->10    */
@property (nonatomic, copy) NSString *level;
/**  等级1_等级2    */
@property (nonatomic, copy) NSString *canshuDJ;
@end

@interface FGJiNengModel : KZBaseModel
/**  宝具描述    */
@property (nonatomic, copy) NSString *jNDetail;
/**  数值数组    */
@property (nonatomic, strong) NSArray *skillNumbers;
@end



