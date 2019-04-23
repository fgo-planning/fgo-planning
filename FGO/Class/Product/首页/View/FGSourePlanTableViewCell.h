//
//  FGSourePlanTableViewCell.h
//  FGO
//
//  Created by 孔志林 on 2018/12/12.
//  Copyright © 2018年 KMingMing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FGSourcePlanModel.h"
@interface FGSourePlanTableViewCell : UITableViewCell
/**  选中按钮    */
@property (nonatomic, strong) UIButton *selectedBtn;
+ (CGFloat)p_getCellHeight;
/**  模型    */
@property (nonatomic, strong) FGSourcePlanModel *model;

@end
