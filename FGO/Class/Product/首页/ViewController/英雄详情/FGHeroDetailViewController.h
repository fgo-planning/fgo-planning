//
//  FGHeroDetailViewController.h
//  FGO
//
//  Created by 孔志林 on 2018/11/15.
//  Copyright © 2018年 KMingMing. All rights reserved.
//

#import "KZBaseUIViewController.h"
#import <WMPageController.h>
#import "FGHeroModel.h"
@interface FGHeroDetailViewController : WMPageController
/**  <##>    */
@property (nonatomic, copy) NSString *ID;
/**  <##>    */
@property (nonatomic, strong) FGHeroModel *heroModel;
/**  title    */
@property (nonatomic, copy) NSString *heroName;
@end
