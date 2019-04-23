//
//  FGActivityDetailViewController.m
//  FGO
//
//  Created by 孔志林 on 2018/11/15.
//  Copyright © 2018年 KMingMing. All rights reserved.
//

#import "FGActivityDetailViewController.h"

@interface FGActivityDetailViewController ()

@end

@implementation FGActivityDetailViewController
#pragma mark - Life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self p_config];
    [self p_createUI];
}

#pragma mark - Private methods
- (void)p_config
{
    self.navigationItem.title = @"活动详情";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem =  [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"KM_rightNvi"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemClick)];
}
- (void)p_createUI
{
    
}
- (void)rightBarButtonItemClick
{
    
}

@end
