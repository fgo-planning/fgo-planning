//
//  FGHeroDetailModel.h
//  FGO
//
//  Created by 孔志林 on 2018/11/21.
//  Copyright © 2018年 KMingMing. All rights reserved.
//

#import "KZBaseModel.h"
@protocol FGHeroDetailBottomSkillModel;
@protocol FGHeroDetailSkillModel;
@protocol FGLevelsModel;
@class FGHeroDetailCardInfoModel;
@class FGHeroDetailTreasureModel;
@class FGHeroDetailTreasureOldModel;
@class FGHeroSkillModel;
@class FGLevelsModel;

@interface FGHeroDetailModel : KZBaseModel
@property (nonatomic, strong) FGHeroDetailCardInfoModel * cardInfo;
@property (nonatomic, copy) NSString * clothFlag;
@property (nonatomic, copy) NSString * imgPath;//头像
//@property (nonatomic, strong) NSArray<FGHeroDetailmatReq> * matReq;
@property (nonatomic, strong) NSNumber * maxAtk;//攻击
@property (nonatomic, strong) NSNumber * maxHp;//血量
@property (nonatomic, copy) NSString * name;
@property (nonatomic, strong) NSNumber * rarity;
@property (nonatomic, strong) NSNumber * servantId;
@property (nonatomic, copy) NSString * sex;
@property (nonatomic, strong) NSArray<FGHeroDetailSkillModel> * skill;
@property (nonatomic, strong) NSArray<FGHeroDetailBottomSkillModel> * skillAdd;
@property (nonatomic, strong) NSArray<FGHeroDetailSkillModel> * skillOld;
@property (nonatomic, strong) FGHeroDetailTreasureModel * treasure;
@property (nonatomic, strong) FGHeroDetailTreasureOldModel * treasure_old;
@property (nonatomic, copy) NSString * treasure_update;
/**  灵基0-4    */
@property (nonatomic, assign) CGFloat lingJIValue;
/**  技能等级，点击了设置保存在本地的    */
@property (nonatomic, strong) NSArray *setSkill;
@end

@interface FGHeroDetailBottomSkillModel : KZBaseModel//最底下的技能skill
@property (nonatomic, strong) NSNumber * ID;
@property (nonatomic, copy) NSString * imgPath;
@property (nonatomic, copy) NSString * rank;
@property (nonatomic, copy) NSString * skillDesc;
@property (nonatomic, copy) NSString * skillName;
@end

@interface FGHeroDetailCardInfoModel : KZBaseModel //礼装那块的信息
@property (nonatomic, copy) NSString * attr;
@property (nonatomic, copy) NSString * avastar;
@property (nonatomic, strong) NSNumber * cost;
@property (nonatomic, copy) NSString * cv;
@property (nonatomic, copy) NSString * head;
@property (nonatomic, copy) NSString * ico;
@property (nonatomic, strong) NSNumber * ID;
@property (nonatomic, copy) NSString * illust;
@property (nonatomic, copy) NSString * intro;
@property (nonatomic, copy) NSString * lv1Atk;
@property (nonatomic, copy) NSString * lv1Hp;
@property (nonatomic, copy) NSString * lvmaxAtk;
@property (nonatomic, copy) NSString * lvmaxHp;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * nameCn;
@property (nonatomic, copy) NSString * nameJp;
@property (nonatomic, copy) NSString * pic1;
@property (nonatomic, copy) NSString * pic2;
@property (nonatomic, strong) NSNumber * servantId;
@property (nonatomic, copy) NSString * skillE;
@property (nonatomic, copy) NSString * skillMaxE;
@property (nonatomic, strong) NSNumber * star;
@property (nonatomic, copy) NSString * type;
@end

@interface FGHeroDetailSkillModel : KZBaseModel //上方的技能
@property (nonatomic, strong) NSNumber * ID; //技能ID
@property (nonatomic, copy) NSString * imgPath;//图片路径
@property (nonatomic, strong) NSArray * lv;//数字数组
@property (nonatomic, copy) NSString * skillDesc;//技能描述
@property (nonatomic, copy) NSString * skillName;//名字（cd）
@property (nonatomic, copy) NSString * skillSrc;//没用的
@property (nonatomic, copy) NSString * skillTar;//旧的描述
@property (nonatomic, copy) NSArray *lvs;
@property (nonatomic, copy) NSArray *skilDescs;
/**  点击设置按钮保存的等级1->10    */
@property (nonatomic, copy) NSString *level;

/**  自己处理过的模型    */
@property (nonatomic, strong) NSArray *jnModels;

/**  levels    */
@property (nonatomic, strong) NSArray<FGLevelsModel*> *levels;
@end

@interface FGLevelsModel : KZBaseModel
/**  <##>    */
@property (nonatomic, strong) NSArray *lv;
/**  co    */
@property (nonatomic, copy) NSString *skillDesc;
@end

@interface FGHeroSkillModel : KZBaseModel //设置英雄的默认等级
/**  英雄id    */
@property (nonatomic, strong) NSNumber *servantId;
/**  灵基0-4    */
@property (nonatomic, strong) NSNumber *lingjiValue;
/**  技能保存过的等级    */
@property (nonatomic, strong) NSData *skillLevel;
/**  保存技能默认等级    */
@property (nonatomic, strong) NSArray *skillArr;

@end

@interface FGHeroDetailTreasureModel : KZBaseModel
@property (nonatomic, strong) NSNumber * a;
@property (nonatomic, copy) NSString * aHit;
@property (nonatomic, copy) NSString * animeAddr;
@property (nonatomic, strong) NSNumber * b;
@property (nonatomic, copy) NSString * bHit;
@property (nonatomic, copy) NSString * exHit;
@property (nonatomic, copy) NSString * lvEffect;
@property (nonatomic, copy) NSString * npGet;
@property (nonatomic, strong) NSString * ocEffect;
@property (nonatomic, strong) NSNumber * q;
@property (nonatomic, copy) NSString * qHit;
@property (nonatomic, strong) NSNumber * servantId;
@property (nonatomic, copy) NSString * tDesc;
@property (nonatomic, copy) NSString * tLv;
@property (nonatomic, copy) NSString * tName;
@property (nonatomic, copy) NSString * tType;
@property (nonatomic, strong) NSNumber * treaEffect;
@property (nonatomic, copy) NSString * treaHit;
@property (nonatomic, strong) NSString * treaTarget;
@end

@interface FGHeroDetailTreasureOldModel : KZBaseModel
@property (nonatomic, strong) NSNumber * ID;
@property (nonatomic, copy) NSString * imgPath;
@property (nonatomic, strong) NSArray * lv;
@property (nonatomic, copy) NSString * skillDesc;
@property (nonatomic, copy) NSString * skillName;
@property (nonatomic, copy) NSString * skillSrc;
@property (nonatomic, copy) NSString * skillTar;
@end




