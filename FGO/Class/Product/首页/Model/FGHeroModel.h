//
//  FGHeroModel.h
//  FGO
//
//  Created by 孔志林 on 2018/11/13.
//  Copyright © 2018年 KMingMing. All rights reserved.
//

#import "KZBaseModel.h"
@class FGVPNHeroModel;
@interface FGHeroModel : KZBaseModel
@property (nonatomic, copy) NSString *clothFlag;
@property (nonatomic, copy) NSString *imgPath;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *clazz;//SABER(剑) ARCHER(弓) LANCER(枪) RIDER（骑）CASTER(术) ASSASSIN（杀） BERSERKER(狂)
@property (nonatomic, copy) NSString *version;
@property (nonatomic, copy) NSString *rarity;
@property (nonatomic, copy) NSArray *addition;
/**  copy    */
@property (nonatomic, strong) NSNumber *heroID;

/**  <##>    */
@property (nonatomic, strong) FGVPNHeroModel *vpnModel;
@end

@interface FGVPNHeroModel : KZBaseModel
/**  skill    */
@property (nonatomic, copy) NSString *skillLv1, *skillLv2, *skillLv3;
/**  linji    */
@property (nonatomic, copy) NSString *limitCount;
/**  lv    */
@property (nonatomic, copy) NSString *lv;
/**  svtId    */
@property (nonatomic, copy) NSString *svtId;
@end
