//
//  FGCountViewController.h
//  FGO
//
//  Created by 孔志林 on 2019/1/8.
//  Copyright © 2019年 KMingMing. All rights reserved.
//

#import "KZBaseUIViewController.h"

@interface FGCountViewController : KZBaseUIViewController

@end

@interface FGCountModel : NSObject
/**  是否是选中   */
@property (nonatomic, copy) NSString *isSelected;
/**  账号名称    */
@property (nonatomic, copy) NSString *name;
/**  游戏ID名称    */
@property (nonatomic, copy) NSString *userID;
@end
