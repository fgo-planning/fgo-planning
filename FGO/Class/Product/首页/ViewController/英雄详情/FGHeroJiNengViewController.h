//
//  FGHeroJiNengViewController.h
//  FGO
//
//  Created by 孔志林 on 2018/11/21.
//  Copyright © 2018年 KMingMing. All rights reserved.
//

#import "KZBaseUIViewController.h"
#import "FGHeroDetailModel.h"
@interface FGHeroJiNengViewController : KZBaseUIViewController
/**  <##>    */
@property (nonatomic, strong) FGHeroDetailModel *detailModel;
@property (nonatomic, assign) CGFloat lingJIValue;
@property (nonatomic, assign) BOOL isSetLevel;
- (void)p_updateSkillLevel:(BOOL)isMax;

@end


