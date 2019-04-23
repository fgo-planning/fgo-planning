//
//  FGSettingViewController.h
//  FGO
//
//  Created by 孔志林 on 2018/10/24.
//  Copyright © 2018年 KMingMing. All rights reserved.
//

#import "KZBaseUIViewController.h"
#import "KZBaseModel.h"
@interface FGSettingViewController : KZBaseUIViewController

@end

@interface FGSettingModel : KZBaseModel
/**  title    */
@property (nonatomic, copy) NSString *sectionTitle;
/**  detail    */
@property (nonatomic, copy) NSString *detailTitle;
@end
