//
//  FGBaoJuTableViewCell.h
//  FGO
//
//  Created by 孔志林 on 2018/12/3.
//  Copyright © 2018年 KMingMing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FGHeroDetailModel.h"
@class FGBaoJuTableViewCell;
@class FGBaoJuModel;
@protocol FGBaoJuTableViewCellDelegate<NSObject>
- (void)baoJuCellTapDHBtn:(FGBaoJuTableViewCell *)cell;
@end
@interface FGBaoJuTableViewCell : UITableViewCell
+ (CGFloat)p_getCellHeight;
@property (nonatomic, weak) id<FGBaoJuTableViewCellDelegate> delegate;
@end

@interface FGBaoJuTopTableViewCell : FGBaoJuTableViewCell
/**  model    */
@property (nonatomic, strong) FGHeroDetailTreasureModel *model;
@end

@interface FGBaoJuCenterTableViewCell : FGBaoJuTableViewCell
/**  model    */
@property (nonatomic, strong) FGBaoJuModel *model;
@end

@interface FGBaoJuBottomTableViewCell : FGBaoJuTableViewCell
/**  model    */
@property (nonatomic, strong) FGHeroDetailTreasureModel *model;
@end

@interface FGBaoJuModel : KZBaseModel
/**  宝具描述    */
@property (nonatomic, copy) NSString *bjDetail;
/**  数值数组    */
@property (nonatomic, strong) NSArray *skillNumbers;
@end
