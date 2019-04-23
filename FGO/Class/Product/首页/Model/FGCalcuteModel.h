//
//  FGCalcuteModel.h
//  FGO
//
//  Created by 孔志林 on 2018/12/10.
//  Copyright © 2018年 KMingMing. All rights reserved.
//

#import "KZBaseModel.h"

@protocol FGCalcutematerialModel;
@protocol FGCalcuteCountModel;
@class FGCalcutereqDetailModel;

@interface FGCalcuteModel : KZBaseModel
@property (nonatomic, copy) NSString *imgPath;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSNumber *qp;
@property (nonatomic, copy) NSString *qpStr;
@property (nonatomic, copy) NSString *rank;
@property (nonatomic, strong) NSArray *skill;
@property (nonatomic, strong) NSArray<FGCalcuteCountModel> *skillMaterial;//只需要计算这里面的

@property (nonatomic, strong) NSArray<FGCalcuteCountModel> * material;
@property (nonatomic, strong) NSArray<FGCalcuteCountModel> *rankMaterial;
@property (nonatomic, strong) NSArray<FGCalcuteCountModel> *clothMaterial;
@property (nonatomic, strong) FGCalcutereqDetailModel *reqDetail;

@end
@interface FGCalcuteCountModel : KZBaseModel
@property (nonatomic, copy) NSString * count;
@property (nonatomic, copy) NSString * ID;
@property (nonatomic, copy) NSString * imgPath;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * type;
@end

@interface FGCalcutereqDetailModel : KZBaseModel
//@property (nonatomic, strong) NSArray *1101;
//@property (nonatomic, strong) NSArray *1201;
//@property (nonatomic, strong) NSArray *1301;
//@property (nonatomic, strong) NSArray *2101;
//@property (nonatomic, strong) NSArray *2103;
//@property (nonatomic, strong) NSArray *2206;
//@property (nonatomic, strong) NSArray *2301;
//@property (nonatomic, strong) NSArray *2303;
//@property (nonatomic, strong) NSArray *3401;
//@property (nonatomic, strong) NSArray *4101;
//@property (nonatomic, strong) NSArray *4201;
@end
