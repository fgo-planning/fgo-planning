//
//  FGActivityHeaderView.h
//  FGO
//
//  Created by 孔志林 on 2018/11/14.
//  Copyright © 2018年 KMingMing. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FGActivityHeaderView;
@protocol FGActivityHeaderViewDelegate <NSObject>
@required
- (void)headerView:(FGActivityHeaderView *)view tapSwich:(NSInteger)index;
- (void)headerView:(FGActivityHeaderView *)view tapDetailBtn:(NSInteger)index;

@end


@interface FGActivityHeaderView : UITableViewHeaderFooterView
@property (nonatomic, strong) UILabel *leftLb;
@property (nonatomic, strong) UIButton *detailBtn;
@property (nonatomic, strong) UISwitch *swich;

@property (nonatomic, assign) NSInteger index;//section下标
@property (nonatomic, weak) id<FGActivityHeaderViewDelegate> delegate;
@end
