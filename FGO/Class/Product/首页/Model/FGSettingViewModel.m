//
//  FGSettingViewModel.m
//  FGO
//
//  Created by 孔志林 on 2019/1/9.
//  Copyright © 2019年 KMingMing. All rights reserved.
//

#import "FGSettingViewModel.h"
#import "FGCountViewController.h"
#import "JQFMDB.h"
@interface FGSettingViewModel ()
/**  <##>    */
@property (nonatomic, strong) JQFMDB *db;
@end
@implementation FGSettingViewModel
+ (instancetype)sharedInstance
{
    static FGSettingViewModel *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [self new];
    });
    return instance;
}
- (NSString *)currentUserName
{
    NSArray *array = [self.db jq_lookupTable:@"FGCountModel" dicOrModel:[FGCountModel class] whereFormat:nil];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        FGCountModel *model = obj;
        if ([model.isSelected isEqualToString:@"YES"]) {
            _currentUserName = model.userID;
        }
    }];
    return _currentUserName;
}
- (NSString *)name
{
    NSArray *array = [self.db jq_lookupTable:@"FGCountModel" dicOrModel:[FGCountModel class] whereFormat:nil];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        FGCountModel *model = obj;
        if ([model.isSelected isEqualToString:@"YES"]) {
            _name = model.name;
        }
    }];
    return _name;
}
- (JQFMDB *)db//保存账号
{
    if (!_db) {
        _db = [JQFMDB shareDatabase];
        BOOL isExist = [_db jq_isExistTable:@"FGCountModel"];
        if (!isExist) {
            [_db jq_createTable:@"FGCountModel" dicOrModel:[FGCountModel class]];
            
            FGCountModel *model = [FGCountModel new];
            model.isSelected = @"YES";
            model.name = @"默认";
            model.userID = @"o";
            //            [_db jq_deleteTable:@"FGCountModel" whereFormat:[NSString stringWithFormat:@"where name = '%@'",@"default"]];
            [_db jq_insertTable:@"FGCountModel" dicOrModel:model];
        }
    }
    return _db;
}

@end
