//
//  FGSourrceDetailTableViewCell.m
//  FGO
//
//  Created by 孔志林 on 2019/1/2.
//  Copyright © 2019年 KMingMing. All rights reserved.
//

#import "FGSourrceDetailTableViewCell.h"
@interface FGSourrceDetailTableViewCell ()
/**  战斗:1,2,3,其他掉落    */
@property (nonatomic, strong) UILabel *zdOne,*zdTwo,*zdThree,*eleseDl;
/**  掉率， Ap   */
@property (nonatomic, strong) UILabel *dl,*Ap;
@end

@implementation FGSourrceDetailTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self p_createUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
- (void)setModel:(FGSourceDetailDropsModel *)model
{
    _model = model;
    _eleseDl.text = [@"其他掉落:" stringByAppendingString:model.drops];
    _dl.text = [NSString stringWithFormat:@"掉率: %@%%",[model.amount stringValue]];
    _Ap.text = [NSString stringWithFormat:@"| %@AP",model.mapAp];
    NSArray *stage = model.stage;
    [stage enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UILabel *lb = [self.contentView viewWithTag:100 + idx];
        lb.text = [NSString stringWithFormat:@"战斗%lu/%lu:%@",(unsigned long)idx,(unsigned long)stage.count,obj];
    }];
    
}
- (void)p_createUI
{
    _zdOne = [self createUILbale];
    _zdOne.tag = 100;
    _zdTwo = [self createUILbale];
    _zdTwo.tag = 101;
    _zdThree = [self createUILbale];
    _zdThree.tag = 102;
    _eleseDl = [self createUILbale];
    _dl = [self createUILbale];
    _Ap = [self createUILbale];
    _Ap.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.zdOne];
    [self.contentView addSubview:self.zdTwo];
    [self.contentView addSubview:self.zdThree];
    [self.contentView addSubview:self.eleseDl];
    [self.contentView addSubview:self.dl];
    [self.contentView addSubview:self.Ap];

    [self.zdOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(15);
        make.right.equalTo(-15);
//        make.height.equalTo(20);
    }];
    [self.zdTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.zdOne.mas_bottom).offset(5);
        make.left.equalTo(15);
        make.right.equalTo(-15);
//        make.height.equalTo(20);
    }];
    [self.zdThree mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.zdTwo.mas_bottom).offset(5);
        make.left.equalTo(15);
        make.right.equalTo(-15);
//        make.height.equalTo(20);
    }];
    [self.eleseDl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.zdThree.mas_bottom).offset(5);
        make.left.equalTo(15);
        make.right.equalTo(-15);
        make.bottom.equalTo(-45);
    }];
    [self.dl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.eleseDl.mas_bottom).offset(15);
        make.left.equalTo(15);
        make.width.equalTo(MainWidth/2.0 - 15);
        make.height.equalTo(20);

    }];
    [self.Ap mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.eleseDl.mas_bottom).offset(15);
        make.right.equalTo(-15);
        make.width.equalTo(MainWidth/2.0 - 15);
        make.height.equalTo(20);
    }];
}
- (UILabel *)createUILbale;
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.textColor = [UIColor grayColor];
//    label.preferredMaxLayoutWidth = MainWidth - 30;
//    [label setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:14];
    label.adjustsFontSizeToFitWidth = YES;
    return label;
}
@end
