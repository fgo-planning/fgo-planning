//
//  FGFMDBHelper.m
//  FGO
//
//  Created by 孔志林 on 2018/11/15.
//  Copyright © 2018年 KMingMing. All rights reserved.
//

#import "FGFMDBHelper.h"

@interface FGFMDBHelper ()
/**  DB    */
@property (nonatomic, strong) FMDatabase *db;
@end

@implementation FGFMDBHelper
+ (instancetype)sharedInstance
{
    static FGFMDBHelper *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [self new];
    });
    return instance;
}
- (FMDatabase *)db
{
    if (!_db) {
        NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"FMDB.db"];
        _db = [FMDatabase databaseWithPath:path];
        NSLog(@"%@",path);
    }
    return _db;
}
- (BOOL)p_createTable:(NSString *)tableName
{
    NSString *createTable = [NSString stringWithFormat:@"create table if not exists %@ (id integer primary key autoincrement, data BLOB)",tableName];
    return [self.db executeUpdate:createTable];
}
- (void)p_saveDataAtTable:(NSString *)tableName data:(NSData *)data
{
    if (![self.db open]) {
        self.db = nil;
        return;
    }
    NSLog(@"数据库打开啦");
    BOOL isCreateTable = [self p_createTable:tableName];
    if (!isCreateTable) {
        NSLog(@"创建表失败");
        return;
    }
    [self.db beginTransaction];
    BOOL isRollBack = NO;
    @try {
    
            NSString *insert = [NSString stringWithFormat:@"insert into %@ (data) values (?)",tableName];
            BOOL isInsert = [self.db executeUpdate:insert withArgumentsInArray:@[data]];
            if (!isInsert) {
                NSLog(@"插入失败");
            }
        }
    @catch (NSException *exception) {
        isRollBack = YES;
        [self.db rollback];
    }
    @finally {
        if (!isRollBack) {
            [self.db commit];
            NSLog(@"数据成功插入");
        }
    }
    [self.db close];
}
- (NSArray *)p_getAllData:(NSString *)tableName
{
    if (![self.db open]) {
        self.db = nil;
        return nil;
    }
    NSLog(@"数据库打开啦");
    FMResultSet *rs = [self.db executeQuery:[NSString stringWithFormat:@"select * from %@",tableName]];
    NSMutableArray *array = [NSMutableArray new];
    while ([rs next]) {
        NSData *data = [rs dataForColumn:@"data"];
        [array addObject:data];
    }
    [self.db close];
    
    NSData *localData = array.lastObject;
    NSArray *modelArray = [NSKeyedUnarchiver unarchiveObjectWithData:localData];

    return modelArray;
}
- (BOOL)p_deleteAllData:(NSString *)tableName;
{
    if (![self.db open]) {
        self.db = nil;
        return NO;
    }
    NSLog(@"数据库打开啦");
    NSString *dropTable = [NSString stringWithFormat:@"drop table if exists %@",tableName];
    BOOL isDrop = [self.db executeUpdate:dropTable];
    if (isDrop) {
        NSLog(@"表已经删除");
    }else {
        NSLog(@"表没有删除");
    }
    [self.db close];
    return isDrop;
}
- (BOOL)p_updateTable:(NSString *)tableName data:(NSArray *)array
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:array];
    if (![self.db open]) {
        self.db = nil;
        return NO;
    }
    NSLog(@"数据库打开啦");
    BOOL isCreateTable = [self p_createTable:tableName];
    if (!isCreateTable) {
        NSLog(@"创建表失败");
        return NO;
    }
    [self.db beginTransaction];
    BOOL isRollBack = NO;
    @try {
        NSArray *array = [self p_getAllData:tableName];
        if (array.count > 0)
        {
            [self.db open];
            [self.db beginTransaction];
            NSString *update = [NSString stringWithFormat:@"update %@ set (data) = (?)",tableName];
            BOOL isupdate = [self.db executeUpdate:update withArgumentsInArray:@[data]];
            if (!isupdate) {
                NSLog(@"更新失败");
            }else
            {
                NSLog(@"更新成功");
            }
        }else
        {
            [self.db open];
            [self.db beginTransaction];
            NSString *insert = [NSString stringWithFormat:@"insert into %@ (data) values (?)",tableName];
            BOOL isInsert = [self.db executeUpdate:insert withArgumentsInArray:@[data]];
            if (!isInsert) {
                NSLog(@"插入失败");
            }
        }
    }
    @catch (NSException *exception) {
        isRollBack = YES;
        [self.db rollback];
    }
    @finally {
        if (!isRollBack) {
            [self.db commit];
            NSLog(@"数据成功插入");
            return YES;
        }
        return NO;
    }
    [self.db close];
}


@end
