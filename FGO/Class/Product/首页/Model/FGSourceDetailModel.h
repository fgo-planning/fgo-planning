//
//  FGSourceDetailModel.h
//  FGO
//
//  Created by 孔志林 on 2019/1/2.
//  Copyright © 2019年 KMingMing. All rights reserved.
//

#import "KZBaseModel.h"
@protocol FGSourceDetailDropsModel;
@interface FGSourceDetailModel : KZBaseModel
@property (nonatomic, strong) NSArray<FGSourceDetailDropsModel> * drops;
@property (nonatomic, copy) NSString * name;
@end

@interface FGSourceDetailDropsModel : KZBaseModel
@property (nonatomic, strong) NSNumber * amount;
@property (nonatomic, copy) NSString * ap;
@property (nonatomic, copy) NSString * dropMapId;
@property (nonatomic, copy) NSString * drops;
@property (nonatomic, copy) NSString * mapAp;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, strong) NSArray *stage;
@property (nonatomic, copy) NSString * type;
@end
