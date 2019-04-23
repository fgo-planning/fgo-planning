//
//  FGSourceModel.h
//  FGO
//
//  Created by 孔志林 on 2018/11/14.
//  Copyright © 2018年 KMingMing. All rights reserved.
//

#import "KZBaseModel.h"

@interface FGSourceModel : KZBaseModel

@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *des;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *imgPath;
/**  主动设置数量    */
@property (nonatomic, assign) NSInteger count;

/**  活动中素材的数量    */
@property (nonatomic, assign) NSInteger activityCount;

/**  <##>    */
@property (nonatomic, strong) NSNumber *sourceID;
@end
