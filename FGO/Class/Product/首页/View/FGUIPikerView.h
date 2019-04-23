//
//  FGUIPikerView.h
//  FGO
//
//  Created by 孔志林 on 2018/12/13.
//  Copyright © 2018年 KMingMing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FGSourcePlanModel.h"

@protocol FGUIPikerViewDelegate<NSObject>
- (void)FGUIPikerViewSure:(FGSourcePlanModel *)model index:(NSIndexPath *)indexPath;
@end

@interface FGUIPikerView : UIView
/**  <##>    */
@property (nonatomic, weak) id<FGUIPikerViewDelegate> delegate;
@property (nonatomic, strong) FGSourcePlanModel *planModel;
/**  <##>    */
@property (nonatomic, strong) NSIndexPath *indexPath;
@end
