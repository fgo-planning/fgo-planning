//
//  FGHeroListViewController.h
//  FGO
//
//  Created by 孔志林 on 2018/11/6.
//  Copyright © 2018年 KMingMing. All rights reserved.
//

#import "KZBaseUIViewController.h"

@interface FGHeroListViewController : KZBaseUIViewController
/**  title    */
@property (nonatomic, copy) NSString *headerTitle;
/**  <##>    */
@property (nonatomic, copy) NSArray *models;
@end
