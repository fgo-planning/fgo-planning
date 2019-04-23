//
//  FGMainVIiewModel.m
//  FGO
//
//  Created by 孔志林 on 2018/11/13.
//  Copyright © 2018年 KMingMing. All rights reserved.
//  MainViewModel

#import "FGMainVIiewModel.h"
#import "FGHeroModel.h"
#import "FGSourceModel.h"
#import "FGActivityModel.h"
#import "FGFMDBHelper.h"
#import "FGHeroDetailModel.h"
#import "JQFMDB.h"
#import "FGJiNengTableViewCell.h"
#import "FGCalcuteModel.h"
#import "FGSourceDetailModel.h"
#import "FGHaveHeroModel.h"
#import "FGCountViewController.h"
@interface FGMainVIiewModel ()
/**  s    */
@property (nonatomic, strong) JQFMDB *db;

@end

@implementation FGMainVIiewModel

+ (instancetype)sharedInstance
{
    static FGMainVIiewModel *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [self new];
    });
    return instance;
}
- (void)getHeroList:(successBlock)success failure:(failureBlock)failure
{
    NSArray *localArrays = [[FGFMDBHelper sharedInstance] p_getAllData:@"hero"];
    if (![NSArray isNullOrEmptyArray:localArrays]) {
        success(localArrays,nil);
    }
    
    //?count=0&version=
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    [params setObject:@"0" forKey:@"count"];
//    [params setObject:@"version" forKey:@""];
    [self GET:kyllb paramaters:params success:^(NSURLSessionDataTask *dataTask, id response) {
        
        if (!response) {
            return ;
        }
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        if ([NSDictionary isNullOrEmptyDictionary:dic]) {
            return;
        }
        dic = [dic p_emptrProperty];//去除空数据
        
        NSArray *data = dic[@"data"];
        NSMutableArray *models = [NSMutableArray array];
        NSMutableArray *jianModel = [NSMutableArray array];
        NSMutableArray *gongModel = [NSMutableArray array];
        NSMutableArray *qiangModel = [NSMutableArray array];
        NSMutableArray *qiModel = [NSMutableArray array];
        NSMutableArray *shuModel = [NSMutableArray array];
        NSMutableArray *shaModel = [NSMutableArray array];
        NSMutableArray *kuangModel = [NSMutableArray array];
        NSMutableArray *qitaModel = [NSMutableArray array];

        [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            FGHeroModel *model = [[FGHeroModel alloc] initWithDictionary:obj error:nil];
            [models addObject:model];
            
            NSString *clazz = model.clazz;
            if ([clazz isEqualToString:@"SABER"]) {//SABER(剑) ARCHER(弓) LANCER(枪) RIDER（骑）CASTER(术) ASSASSIN（杀） BERSERKER(狂)
                [jianModel addObject:model];
            }else if ([clazz isEqualToString:@"ARCHER"])
            {
                [gongModel addObject:model];
            }else if ([clazz isEqualToString:@"LANCER"])
            {
                [qiangModel addObject:model];

            }else if ([clazz isEqualToString:@"RIDER"])
            {
                [qiModel addObject:model];
            }else if ([clazz isEqualToString:@"CASTER"])
            {
                [shuModel addObject:model];
            }else if ([clazz isEqualToString:@"ASSASSIN"])
            {
                [shaModel addObject:model];
            }else if ([clazz isEqualToString:@"BERSERKER"])
            {
                [kuangModel addObject:model];
            }else
            {
                [qitaModel addObject:model];
            }
        }];
        
        NSArray *arrays = @[models,jianModel,gongModel,qiangModel,qiModel,shuModel,shaModel,kuangModel,qitaModel];
        success(arrays,dataTask);
        
        [[FGFMDBHelper sharedInstance] p_updateTable:@"hero" data:arrays];
        
    } failure:^(id error) {
        NSLog(@"");
    }];
}

- (void)getSource:(successBlock)success failure:(failureBlock)failure
{
    NSArray *localArrays = [[FGFMDBHelper sharedInstance] p_getAllData:@"sourceInfo"];
    if (![NSArray isNullOrEmptyArray:localArrays]) {
        success(localArrays,nil);
    }

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"0" forKey:@"count"];
    [self GET:kscxx paramaters:params success:^(NSURLSessionDataTask *dataTask, id response) {
        
        if (!response) {
            return ;
        }
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        if ([NSDictionary isNullOrEmptyDictionary:dic]) {
            return;
        }
        dic = [dic p_emptrProperty];//去除空数据
        
        NSArray *data = dic[@"data"];
        
        NSMutableArray *sucaiModel = [NSMutableArray array];
        NSMutableArray *jinengModel = [NSMutableArray array];
        NSMutableArray *qiziModel = [NSMutableArray array];

        NSMutableArray *sourceModels = [NSMutableArray array];
        [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            FGSourceModel *model = [[FGSourceModel alloc] initWithDictionary:obj error:nil];
            [sourceModels addObject:model];
    
            NSInteger type = [model.type integerValue];
            switch (type) {
                case 1: {[jinengModel addObject:model];}//技能石
                    break;
                case 2: {[sucaiModel addObject:model];}//素材
                    break;
                case 3: {[qiziModel addObject:model];}//棋子
                    break;
                default:
                    break;
            }
        }];
        
        //手动创建一个QPModel;
        FGSourceModel *QPmodel = [FGSourceModel new];
        QPmodel.imgPath = @"qb";
        QPmodel.name = @"QP";
        QPmodel.ID = @"1000";
        QPmodel.des = @"1";
        QPmodel.type = @"1";
        QPmodel.count = 0;
        QPmodel.activityCount = 0;
        
        [sucaiModel insertObject:QPmodel atIndex:0];
        [sourceModels insertObject:QPmodel atIndex:0];
        
        NSArray *arrays = @[sucaiModel, jinengModel, qiziModel, sourceModels];
        
        [[FGFMDBHelper sharedInstance] p_updateTable:@"sourceInfo" data:arrays];

        success(arrays,dataTask);
    
    } failure:^(id error) {
        NSLog(@"");
    }];
}

- (void)getActivity:(successBlock)success failure:(failureBlock)failure
{
    NSArray *localArrays = [[FGFMDBHelper sharedInstance] p_getAllData:@"activity"];
    if (![NSArray isNullOrEmptyArray:localArrays]) {
        success(localArrays,nil);
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"0" forKey:@"count"];
    [self GET:khoxq paramaters:params success:^(NSURLSessionDataTask *dataTask, id response) {
        
        if (!response) {
            return ;
        }
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        if ([NSDictionary isNullOrEmptyDictionary:dic]) {
            return;
        }
        dic = [dic p_emptrProperty];//去除空数据
        
        NSArray *data = dic[@"data"];
        
        NSMutableArray *activityModels = [NSMutableArray array];
        
        [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            FGActivityModel *model = [[FGActivityModel alloc] initWithDictionary:obj error:nil];
            model.hide = YES;
            [activityModels addObject:model];
        }];
        
        success(activityModels,dataTask);
        
        [[FGFMDBHelper sharedInstance] p_updateTable:@"activity" data:activityModels];

    } failure:^(id error) {
        NSLog(@"");
    }];
}

- (NSArray *)getSearchResultFrom:(NSArray *)models heroName:(NSString *)name
{
    NSMutableArray *results = [NSMutableArray array];
    [models enumerateObjectsUsingBlock:^(FGHeroModel *  _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([model.name containsString:name]) {
            [results addObject:model];
        }
    }];
    return results;
}
#pragma mark - 英雄详情：技能、宝具、礼装
- (void)getHeroDetaiWithID:(NSString *)ID success:(successBlock)success failure:(failureBlock)failure
{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:ID forKey:@"servantId"];
    
    [self GET:kyxxq paramaters:params success:^(NSURLSessionDataTask *dataTask, id response) {
        
        if (!response) {
            return ;
        }
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        if ([NSDictionary isNullOrEmptyDictionary:dic]) {
            return;
        }
        dic = [dic p_emptrProperty];//去除空数据
        NSDictionary *data = dic[@"data"];
        
        FGHeroDetailModel *model = [[FGHeroDetailModel alloc] initWithDictionary:data error:nil];
        [model.skill enumerateObjectsUsingBlock:^(FGHeroDetailSkillModel *  _Nonnull skillModel, NSUInteger idx, BOOL * _Nonnull stop) {
            if (skillModel.lv.count > 0) {
                //读取数据个数 并创建保存lv的数组
                NSArray *count = [skillModel.lv[0] componentsSeparatedByString:@"/"];
                NSMutableArray *arrays = [NSMutableArray array];
                [count enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSMutableArray *muArr = [NSMutableArray array];
                    [arrays addObject:muArr];
                }];
                
                [skillModel.lv enumerateObjectsUsingBlock:^(NSString * _Nonnull lvStr, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSArray *lvStrs = [lvStr componentsSeparatedByString:@"/"];
                    [lvStrs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger lvcount, BOOL * _Nonnull stop) {
                        [arrays[lvcount] addObject:obj];
                    }];
                }];
                
                NSMutableArray *skillDescs = [[skillModel.skillDesc componentsSeparatedByString:@"&"] mutableCopy];
                for (int i = 0 ; i<5; i++) {//做个数据保护
                    [skillDescs addObject:@""];
                }
    
                NSMutableArray *lvs = [NSMutableArray array];
                [count enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    FGLevelsModel *levelModel = [FGLevelsModel new];
                    levelModel.lv = arrays[idx];
                    levelModel.skillDesc = skillDescs[idx];
                    [lvs addObject: levelModel];
                }];
                
                skillModel.levels = lvs;
            }else
            {
                skillModel.levels = nil;
            }
            NSLog(@"");
        }];
        
        success(model,dataTask);
        
    } failure:^(id error) {
        NSLog(@"");
    }];
}

- (void)getLikeHeroList:(successBlock)success failure:(failureBlock)failure
{
        NSArray *data = [self.db jq_lookupTable:kTableName(@"likeHero") dicOrModel:[FGHeroModel class] whereFormat:nil];
        NSMutableArray *models = [NSMutableArray array];
        NSMutableArray *jianModel = [NSMutableArray array];
        NSMutableArray *gongModel = [NSMutableArray array];
        NSMutableArray *qiangModel = [NSMutableArray array];
        NSMutableArray *qiModel = [NSMutableArray array];
        NSMutableArray *shuModel = [NSMutableArray array];
        NSMutableArray *shaModel = [NSMutableArray array];
        NSMutableArray *kuangModel = [NSMutableArray array];
        NSMutableArray *qitaModel = [NSMutableArray array];
        
        [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            FGHeroModel *model = obj;
            [models addObject:model];
            
            NSString *clazz = model.clazz;
            if ([clazz isEqualToString:@"SABER"]) {//SABER(剑) ARCHER(弓) LANCER(枪) RIDER（骑）CASTER(术) ASSASSIN（杀） BERSERKER(狂)
                [jianModel addObject:model];
            }else if ([clazz isEqualToString:@"ARCHER"])
            {
                [gongModel addObject:model];
            }else if ([clazz isEqualToString:@"LANCER"])
            {
                [qiangModel addObject:model];
                
            }else if ([clazz isEqualToString:@"RIDER"])
            {
                [qiModel addObject:model];
            }else if ([clazz isEqualToString:@"CASTER"])
            {
                [shuModel addObject:model];
            }else if ([clazz isEqualToString:@"ASSASSIN"])
            {
                [shaModel addObject:model];
            }else if ([clazz isEqualToString:@"BERSERKER"])
            {
                [kuangModel addObject:model];
            }else
            {
                [qitaModel addObject:model];
            }
        }];
        NSArray *arrays = @[models,jianModel,gongModel,qiangModel,qiModel,shuModel,shaModel,kuangModel,qitaModel];
        success(arrays,nil);
}

#pragma mark - 计算素材
- (void)getCalcute:(NSDictionary *)params success:(successBlock)success failure:(failureBlock)failure
{
    NSString *jsonStr = [NSString p_stringWithDic:params encoding:NO];
    NSString *url = [kjssc stringByAppendingString:[NSString stringWithFormat:@"?%@",jsonStr]];
    [self GET:url paramaters:nil success:^(NSURLSessionDataTask *dataTask, id response) {
        if (!response) {
            return ;
        }
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        if ([NSDictionary isNullOrEmptyDictionary:dic]) {
            return;
        }
        dic = [dic p_emptrProperty];//去除空数据
        NSDictionary *data = dic[@"data"];
        
        FGCalcuteModel *calcuteModel = [[FGCalcuteModel alloc] initWithDictionary:data error:nil];
        success(calcuteModel,nil);

    } failure:^(id error) {
        
    }];
}

#pragma mark - 素材规划
- (void)postSourcePlanWithParams:(NSDictionary *)params success:(successBlock)success failure:(failureBlock)failure//素材规划
{

    [self p_SVProgressHUDBegin:@"正在计算中..."];
    [self POST:kScgh paramaters:params success:^(NSURLSessionDataTask *dataTask, id response) {
        [self p_SVProgressHUDDismiss];
        if (!response) {
            return ;
        }
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        if ([NSDictionary isNullOrEmptyDictionary:dic]) {
            return;
        }
        dic = [dic p_emptrProperty];//去除空数据
        
        NSDictionary *data = dic[@"data"];
        FGCalcuteModel *model = [[FGCalcuteModel alloc] initWithDictionary:data error:nil];
        success(model,nil);
        
    } failure:^(id error) {
        NSLog(@"");
        [self p_SVProgressHUDDismiss];
    }];
}

#pragma mark - 读取vpn数据
- (void)getVPNData:(successBlock)success failure:(failureBlock)failure
{
    [self p_showMBProgressHUD];
    __block NSDictionary *vpnDic = [NSDictionary dictionary];
    __block NSArray *heros = [NSArray array];
    __block NSArray *sources = [NSArray array];
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self requestHeros:^(id obj, NSURLSessionDataTask *dataTask) {
            NSLog(@"1");
            heros = obj;
            dispatch_semaphore_signal(semaphore);
        }];
    });
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self requestSource:^(id obj, NSURLSessionDataTask *dataTask) {
            NSLog(@"2");
            sources = obj;
            dispatch_semaphore_signal(semaphore);
        }];
    });
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        [self readVPN:^(id obj, NSURLSessionDataTask *dataTask) {
            vpnDic = obj;
        }];
        NSLog(@"3");
    });
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"1111111111");
        NSArray *userSvt = vpnDic[@"cache"][@"replaced"][@"userSvt"];
        
        NSDictionary *userGame = [vpnDic[@"cache"][@"replaced"][@"userGame"] firstObject];
        NSString *userID = userGame[@"userId"];
        NSString *userName = userGame[@"name"];
        
        if (userID.length == 0 || userName.length == 0) {
            [self p_hideMBProgressHUD];
            return ;
        }
        
        NSMutableArray *haveHeros = [NSMutableArray array];
        [userSvt enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *svtId = obj[@"svtId"];
            
            FGVPNHeroModel *vpnModel = [[FGVPNHeroModel alloc] initWithDictionary:obj error:nil];
            
            [heros enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                FGHeroModel *model = obj;
                if ([[model.heroID stringValue] isEqualToString:svtId]) {
                    if (model.vpnModel == nil || [model.vpnModel.lv integerValue] < [vpnModel.lv integerValue])
                    {
                        model.vpnModel = vpnModel;
                        [haveHeros addObject:model];
                    }
                }
            }];
        }];
        
        //去除重复元素
        haveHeros = [haveHeros valueForKeyPath:@"@distinctUnionOfObjects.self"];
        
        NSMutableArray *models = [NSMutableArray array];
        NSMutableArray *jianModel = [NSMutableArray array];
        NSMutableArray *gongModel = [NSMutableArray array];
        NSMutableArray *qiangModel = [NSMutableArray array];
        NSMutableArray *qiModel = [NSMutableArray array];
        NSMutableArray *shuModel = [NSMutableArray array];
        NSMutableArray *shaModel = [NSMutableArray array];
        NSMutableArray *kuangModel = [NSMutableArray array];
        NSMutableArray *qitaModel = [NSMutableArray array];
        
        [haveHeros enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            FGHeroModel *model = obj;
            [models addObject:model];
            
            NSString *clazz = model.clazz;
            if ([clazz isEqualToString:@"SABER"]) {//SABER(剑) ARCHER(弓) LANCER(枪) RIDER（骑）CASTER(术) ASSASSIN（杀） BERSERKER(狂)
                [jianModel addObject:model];
            }else if ([clazz isEqualToString:@"ARCHER"])
            {
                [gongModel addObject:model];
            }else if ([clazz isEqualToString:@"LANCER"])
            {
                [qiangModel addObject:model];
                
            }else if ([clazz isEqualToString:@"RIDER"])
            {
                [qiModel addObject:model];
            }else if ([clazz isEqualToString:@"CASTER"])
            {
                [shuModel addObject:model];
            }else if ([clazz isEqualToString:@"ASSASSIN"])
            {
                [shaModel addObject:model];
            }else if ([clazz isEqualToString:@"BERSERKER"])
            {
                [kuangModel addObject:model];
            }else
            {
                [qitaModel addObject:model];
            }
        }];
        NSArray *arrays = @[models,jianModel,gongModel,qiangModel,qiModel,shuModel,shaModel,kuangModel,qitaModel];
        
        
        //vpn抓包功能改造: create 2019.1.21
        //先读取保存的账号个数，判断个数是否等于一个并且名字为默认 id为空
        
        FGCountModel *toSave = [FGCountModel new];
        toSave.name = userName;
        toSave.userID = userID;
        toSave.isSelected = @"YES";

        NSArray *counts = [[JQFMDB shareDatabase] jq_lookupTable:@"FGCountModel" dicOrModel:[FGCountModel class] whereFormat:nil];
        FGCountModel *countModel = [counts firstObject];
        if (counts.count == 1 && [countModel.name isEqualToString:@"默认"] && (countModel.userID.length == 1)) {
            //满足这三个情况，说明是第一次读取数据 把默认数据给替换了
            [[JQFMDB shareDatabase] jq_deleteAllDataFromTable:@"FGCountModel"];//删除默认那条数据
            [[JQFMDB shareDatabase] jq_insertTable:@"FGCountModel" dicOrModel:toSave];
        }else
        {
           __block BOOL isHaveCount = NO;
            [counts enumerateObjectsUsingBlock:^(FGCountModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([model.userID isEqualToString:userID]) {
                    //数据库有这个账号 更新他的数据
                    isHaveCount = YES;
                    [[JQFMDB shareDatabase] jq_updateTable:@"FGCountModel" dicOrModel:toSave whereFormat:[NSString stringWithFormat:@"where userID = '%@'",userID]];
                }else
                {
                    model.isSelected = @"NO";
                    [[JQFMDB shareDatabase] jq_updateTable:@"FGCountModel" dicOrModel:model whereFormat:[NSString stringWithFormat:@"where userID = '%@'",model.userID]];
                }
            }];
            
            if (!isHaveCount) {//数据库中没有直接保存这条数据
                [[JQFMDB shareDatabase] jq_insertTable:@"FGCountModel" dicOrModel:toSave];
            }
        }
        
        //保存到数据库
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:arrays];
        FGHaveHeroModel *haveHeroModel = [FGHaveHeroModel new];
        haveHeroModel.data = data;
        [self.db jq_deleteAllDataFromTable:kTableName(@"haveHero")];
        [self.db jq_insertTable:kTableName(@"haveHero") dicOrModel:haveHeroModel];
        
        #pragma mark - 保存英雄等级
        [haveHeros enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            FGHeroModel *model = obj;
            FGVPNHeroModel *vpnmodel = model.vpnModel;
            NSArray *skills = @[vpnmodel.skillLv1, vpnmodel.skillLv2, vpnmodel.skillLv3];
            NSMutableArray *dbArray = [NSMutableArray array];
            for (int i = 0; i<3; i++) {
                FGSaveJNModel *saveJNModel = [FGSaveJNModel new];
                NSInteger level = [skills[i] integerValue];
                saveJNModel.level = level;
                saveJNModel.labelTag = 100 + level - 1;
                saveJNModel.levelDetail = [NSString stringWithFormat:@"等级:%ld",(long)level];;
                [dbArray addObject:saveJNModel];
            }
            NSData *skillDBArrayData = [NSKeyedArchiver archivedDataWithRootObject:dbArray];
            FGHeroSkillModel *saveModel = [FGHeroSkillModel new];
            saveModel.servantId = @([model.ID integerValue]);
            saveModel.lingjiValue = @([vpnmodel.limitCount integerValue]);//默认的灵基初始值是0
            saveModel.skillLevel = skillDBArrayData;
            [self.db jq_deleteTable:kHeroLevel whereFormat:[NSString stringWithFormat:@"where servantId = '%@'",model.ID]];
            [self.db jq_insertTable:kHeroLevel dicOrModel:saveModel];
        }];
        
        #pragma mark - 保存素材信息
        NSArray *userItem = vpnDic[@"cache"][@"replaced"][@"userItem"];
        NSMutableArray *sourceModels = [NSMutableArray array];
        [userItem enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *itemId = obj[@"itemId"];
            NSString *numbers = obj[@"num"];
            [sources enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                FGSourceModel *sourceModel = obj;
                if ([[sourceModel.sourceID stringValue] isEqual:itemId]) {
                    sourceModel.count = [numbers integerValue];
                    [sourceModels addObject:sourceModel];
                }
            }];
        }];
        //去重复
        sourceModels = [sourceModels valueForKeyPath:@"@distinctUnionOfObjects.self"];
        [sourceModels enumerateObjectsUsingBlock:^(FGSourceModel *  _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
            //判断数据库中是否存在
            BOOL isSaved = [self.db jq_lookupTable:kTableName(@"sourceInfo") dicOrModel:[FGSourceModel class] whereFormat:[NSString stringWithFormat:@"where ID = '%@'",model.ID]].count > 0;
            if (isSaved) {
                FGSourceModel *dbModel = [self.db jq_lookupTable:kTableName(@"sourceInfo") dicOrModel:[FGSourceModel class] whereFormat:[NSString stringWithFormat:@"where ID = '%@'",model.ID]].firstObject;
                dbModel.count = model.count;
                [self.db jq_updateTable:kTableName(@"sourceInfo")  dicOrModel:dbModel whereFormat:[NSString stringWithFormat:@"where ID = '%@'",model.ID]];
            }else
            {
                [self.db jq_insertTable:kTableName(@"sourceInfo")  dicOrModel:model];
            }
        }];
        //保存QP 除以10000取整
        NSInteger qpCount = [vpnDic[@"cache"][@"replaced"][@"userGame"][0][@"qp"] integerValue]/10000;
        //手动创建一个QPModel;
        FGSourceModel *QPmodel = [FGSourceModel new];
        QPmodel.imgPath = @"qb";
        QPmodel.name = @"QP";
        QPmodel.ID = @"1000";
        QPmodel.des = @"1";
        QPmodel.type = @"1";
        QPmodel.count = qpCount;
        QPmodel.sourceID = @(77777777);
        
        //判断数据库中是否存在
        BOOL isSaved = [self.db jq_lookupTable:kTableName(@"sourceInfo") dicOrModel:[FGSourceModel class] whereFormat:[NSString stringWithFormat:@"where ID = '%@'",@(1000)]].count > 0;
        if (isSaved) {
            FGSourceModel *model = [self.db jq_lookupTable:kTableName(@"sourceInfo") dicOrModel:[FGSourceModel class] whereFormat:[NSString stringWithFormat:@"where ID = '%@'",@(1000)]].firstObject;
            model.count = qpCount;
            [self.db jq_updateTable:kTableName(@"sourceInfo")  dicOrModel:model whereFormat:[NSString stringWithFormat:@"where ID = '%@'",@(1000)]];
        }else
        {
            [self.db jq_insertTable:kTableName(@"sourceInfo")  dicOrModel:QPmodel];
        }
        
        [self p_hideMBProgressHUD];
        [self p_toast:[NSString stringWithFormat:@"%@数据更新成功",userName]];
    });
}

- (void)readVPN:(successBlock)success
{
    NSArray *sessions = [[STSniffingSDK sharedInstance] sessions];
    if (![NSArray isNullOrEmptyArray:sessions]) {
        STSession *session = [sessions firstObject];
        NSArray<STConnection *>  *connection = [[STSniffingSDK sharedInstance] connectionsForSession:session];
        __block BOOL isHave = NO;
        [connection enumerateObjectsUsingBlock:^(STConnection * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.uri containsString:@"_key=toplogin"]) {//_key=toplogin
                NSData *data = [[STSniffingSDK sharedInstance] responseBodyForConnection:obj inSession:session];
                NSString *urlencodeStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSString *urlDencodeStr = [NSString p_URLDencode:urlencodeStr];
                NSString *base64Dencode = [NSString p_base64Dencode:urlDencodeStr];
                NSData *jsonData = [base64Dencode dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
                NSString *str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                success(dic,nil);
                isHave = YES;
                *stop = YES;
            }
        }];
        if (!isHave) {
            success(nil,nil);
        }
    }else{
//        NSString *json = [[NSBundle mainBundle] pathForResource:@"hero.json" ofType:nil];
//        NSData *data = [NSData dataWithContentsOfFile:json];
//        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//        success(dic,nil);
        
        success(nil,nil);
    }
}
- (void)requestHeros:(successBlock)success
{
    [self GET:kyllb paramaters:nil success:^(NSURLSessionDataTask *dataTask, id response) {
        
        if (!response) {
            return ;
        }
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        if ([NSDictionary isNullOrEmptyDictionary:dic]) {
            return;
        }
        dic = [dic p_emptrProperty];//去除空数据
        
        NSArray *data = dic[@"data"];
        NSMutableArray *models = [NSMutableArray array];
        [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            FGHeroModel *model = [[FGHeroModel alloc] initWithDictionary:obj error:nil];
            [models addObject:model];
        }];
        success(models,dataTask);
    } failure:^(id error) {
        success(nil,nil);
    }];
}
- (void)requestSource:(successBlock)success
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"0" forKey:@"count"];
    [self GET:kscxx paramaters:params success:^(NSURLSessionDataTask *dataTask, id response) {
        
        if (!response) {
            return ;
        }
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        if ([NSDictionary isNullOrEmptyDictionary:dic]) {
            return;
        }
        dic = [dic p_emptrProperty];//去除空数据
        
        NSArray *data = dic[@"data"];
        NSMutableArray *sourceModels = [NSMutableArray array];
        [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            FGSourceModel *model = [[FGSourceModel alloc] initWithDictionary:obj error:nil];
            [sourceModels addObject:model];
        }];
        
        //手动创建一个QPModel;
//        FGSourceModel *QPmodel = [FGSourceModel new];
//        QPmodel.imgPath = @"qb";
//        QPmodel.name = @"QP";
//        QPmodel.ID = @"1000";
//        QPmodel.des = @"1";
//        QPmodel.type = @"1";
//        QPmodel.count = 0;
//        QPmodel.activityCount = 0;
//        QPmodel.sourceID = @(1000);
//        [sourceModels insertObject:QPmodel atIndex:0];
    
        success(sourceModels,dataTask);
        
    } failure:^(id error) {
        success(nil,nil);
    }];
    
}


#pragma mark - 点击计算后的素材
- (void)getSourceDetail:(NSDictionary *)params success:(successBlock)success failure:(failureBlock)failure
{
    
    [self GET:kdjsc paramaters:params success:^(NSURLSessionDataTask *dataTask, id response) {
        [self p_SVProgressHUDDismiss];
        if (!response) {
            return ;
        }
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        if ([NSDictionary isNullOrEmptyDictionary:dic]) {
            return;
        }
        dic = [dic p_emptrProperty];//去除空数据
        
        NSDictionary *data = dic[@"data"];
        FGSourceDetailModel *model = [[FGSourceDetailModel alloc] initWithDictionary:data error:nil];
        success(model,nil);
        
    } failure:^(id error) {
        NSLog(@"");
        [self p_SVProgressHUDDismiss];
    }];
}

- (JQFMDB *)db
{
    _db = [JQFMDB shareDatabase];
    BOOL isExist = [_db jq_isExistTable:kTableName(@"sourceInfo")];
    if (!isExist) {
        [_db jq_createTable:kTableName(@"sourceInfo") dicOrModel:[FGSourceModel class]];
    }
    BOOL isExistHaveHeros = [_db jq_isExistTable:kTableName(@"haveHero")];
    if (!isExistHaveHeros) {
        [_db jq_createTable:kTableName(@"haveHero") dicOrModel:[FGHaveHeroModel class]];
    }
    BOOL isAlready = [_db jq_isExistTable:kHeroLevel];
    if (!isAlready) {
        BOOL success = [_db jq_createTable:kHeroLevel dicOrModel:[FGHeroSkillModel class]];
        NSLog(@"");
    }
    return _db;
}

@end
