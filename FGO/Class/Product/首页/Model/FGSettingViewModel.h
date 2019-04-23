//
//  FGSettingViewModel.h
//  FGO
//
//  Created by 孔志林 on 2019/1/9.
//  Copyright © 2019年 KMingMing. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface FGSettingViewModel : NSObject
+ (instancetype)sharedInstance;
/**  当前用户名    */
@property (nonatomic, copy) NSString *currentUserName;
/**  name    */
@property (nonatomic, copy) NSString *name;
@end
