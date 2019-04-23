//
//  FGActivityHeaderView.m
//  FGO
//
//  Created by 孔志林 on 2018/11/14.
//  Copyright © 2018年 KMingMing. All rights reserved.
//

#import "FGActivityHeaderView.h"

@implementation FGActivityHeaderView
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self p_createUI];
    }
    return self;
}
- (void)p_createUI
{
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.leftLb];
    [self.contentView addSubview:self.detailBtn];
    [self.contentView addSubview:self.swich];
    
    [self.leftLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(0);
        make.left.equalTo(15);
        make.width.equalTo(MainWidth - 140);
    }];
    [self.detailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(0);
        make.left.equalTo(self.leftLb.mas_right).offset(0);
        make.size.equalTo(CGSizeMake(30, 30));
    }];
    [self.swich mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-15);
        make.centerY.equalTo(0);
    }];
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectZero];
    lb.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.1];
    [self addSubview:lb];
    [lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(0);
        make.height.equalTo(1);
    }];

//    for (UIView *v in self.contentView.subviews) {
//        v.backgroundColor = [UIColor p_randomColor];
//    }

}

- (void)tapAction:(id)sender
{
    if ([sender isKindOfClass:[UIButton class]]) {
        if ([self.delegate respondsToSelector:@selector(headerView:tapDetailBtn:)]) {
            [self.delegate headerView:self tapDetailBtn:self.index];
        }
    }else{
        if ([self.delegate respondsToSelector:@selector(headerView:tapSwich:)]) {
            [self.delegate headerView:self tapSwich:self.index];
        }
    }
}


- (UILabel *)leftLb
{
    if (!_leftLb) {
        _leftLb = [[UILabel alloc] initWithFrame:CGRectZero];
        _leftLb.font = [UIFont systemFontOfSize:16];
    }
    return _leftLb;
}
- (UIButton *)detailBtn
{
    if (!_detailBtn) {
        _detailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_detailBtn addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];
        [_detailBtn setImage:[UIImage imageWithContentsOfFile:KImagePath(@"images/detail.png")] forState:UIControlStateNormal];
        _detailBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _detailBtn;
}
- (UISwitch *)swich
{
    if (!_swich) {
        _swich = [[UISwitch alloc] initWithFrame:CGRectZero];
        [_swich addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _swich;
}

@end
