//
//  FGActivityModel.h
//  FGO
//
//  Created by 孔志林 on 2018/11/14.
//  Copyright © 2018年 KMingMing. All rights reserved.
//

#import "KZBaseModel.h"
@protocol FGActivityDetailModel;
@interface FGActivityModel : KZBaseModel

@property (nonatomic, copy) NSString *date;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSArray<FGActivityDetailModel> *material;
/**  控制展示/隐藏    */
@property (nonatomic, assign, getter=isHide) BOOL hide;
@property (nonatomic, assign) BOOL swichON;
/**  手动添加一个count 保存所有互动   */
@property (nonatomic, assign) NSInteger activityTotalCount;
@end

@interface FGActivityDetailModel : KZBaseModel

@property (nonatomic, copy) NSString *imgPath;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *count;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *type;

@end
