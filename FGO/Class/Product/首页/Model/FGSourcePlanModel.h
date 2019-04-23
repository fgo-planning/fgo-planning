//
//  FGSourcePlanModel.h
//  FGO
//
//  Created by 孔志林 on 2018/12/13.
//  Copyright © 2018年 KMingMing. All rights reserved.
//

#import "KZBaseModel.h"

@interface FGSourcePlanModel : KZBaseModel
/**  灵基    */
@property (nonatomic, copy) NSString *linJi;
/**  技能    */
@property (nonatomic, copy) NSString *jiNengOne, *jiNengTwo, *jiNengThree;
/** 图片    */
@property (nonatomic, copy) NSString *imagePath;
/**  是否是选中状态    */
@property (nonatomic, assign) BOOL isChoose;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *clothFlag;

@end
