//
//  FGFMDBHelper.h
//  FGO
//
//  Created by 孔志林 on 2018/11/15.
//  Copyright © 2018年 KMingMing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB.h>
@interface FGFMDBHelper : NSObject
+ (instancetype)sharedInstance;
- (BOOL)p_createTable:(NSString *)tableName;
- (void)p_saveDataAtTable:(NSString *)tableName data:(NSData *)data;
- (NSArray *)p_getAllData:(NSString *)tableName;
- (BOOL)p_deleteAllData:(NSString *)tableName;
- (BOOL)p_updateTable:(NSString *)tableName data:(NSArray *)array;
@end
