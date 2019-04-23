//
//  FGMainVIiewModel.h
//  FGO
//
//  Created by 孔志林 on 2018/11/13.
//  Copyright © 2018年 KMingMing. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^successBlock)(id obj,NSURLSessionDataTask *dataTask);
typedef void(^failureBlock)(id err);

@interface FGMainVIiewModel : NSObject
+ (instancetype)sharedInstance;
- (void)getHeroList:(successBlock)success failure:(failureBlock)failure;//获取英雄列表
- (void)getLikeHeroList:(successBlock)success failure:(failureBlock)failure;//获取喜欢英雄列表
- (void)getSource:(successBlock)success failure:(failureBlock)failure;//获取素材列表
- (void)getActivity:(successBlock)success failure:(failureBlock)failure;//获取活动列表
- (void)getHeroDetaiWithID:(NSString *)ID  success:(successBlock)success failure:(failureBlock)failure;//获取英雄详情:技能、宝具、礼装。
- (void)getCalcute:(NSDictionary *)params success:(successBlock)success failure:(failureBlock)failure;//计算素材

- (NSArray *)getSearchResultFrom:(NSArray *)models heroName:(NSString *)name;//获取搜索结果

- (void)postSourcePlanWithParams:(NSDictionary *)params success:(successBlock)success failure:(failureBlock)failure;//素材规划
#pragma mark - 点击计算后的素材
- (void)getSourceDetail:(NSDictionary *)params success:(successBlock)success failure:(failureBlock)failure;
#pragma mark - 读取抓包数据
- (void)getVPNData:(successBlock)success failure:(failureBlock)failure;
@end
