//
//  FGSaveJNModel.h
//  FGO
//
//  Created by 孔志林 on 2018/11/28.
//  Copyright © 2018年 KMingMing. All rights reserved.
//

#import "KZBaseModel.h"

@interface FGSaveJNModel : KZBaseModel
/**  技能等级    */
@property (nonatomic, assign) NSInteger level;
/**  高亮的label tag    */
@property (nonatomic, assign) NSInteger labelTag;
/**  等级描述"1->10"    */
@property (nonatomic, copy) NSString *levelDetail;
/**  技能cd    */
@property (nonatomic, copy) NSString *skillCD;
@end
