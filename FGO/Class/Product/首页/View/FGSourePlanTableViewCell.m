//
//  FGSourePlanTableViewCell.m
//  FGO
//
//  Created by 孔志林 on 2018/12/12.
//  Copyright © 2018年 KMingMing. All rights reserved.
//

#import "FGSourePlanTableViewCell.h"
@interface FGSourePlanTableViewCell ()
/**  头像    */
@property (nonatomic, strong) UIImageView *iconIV;
/**  灵基    */
@property (nonatomic, strong) UILabel *linJiLb, *linJiDetail;
/**  技能1、2、3    */
@property (nonatomic, strong) UILabel *skillOne, *skillOneDetail, *skillTwo, *skillTwoDetail, *skillThree, *skillThreeDetail;
@end

#define kLabelHeight 20
#define kLabelWidth 45
#define kLabelDetailwidth 40
@implementation FGSourePlanTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self p_createUI];
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
+ (CGFloat)p_getCellHeight
{
    return 60;
}
- (void)setModel:(FGSourcePlanModel *)model
{
    _model = model;
    if (model.linJi) {
        self.linJiDetail.text = model.linJi;
    }
    if (model.jiNengOne) {
        self.skillOneDetail.text = model.jiNengOne;
    }
    if (model.jiNengTwo) {
        self.skillTwoDetail.text = model.jiNengTwo;
    }
    if (model.jiNengThree) {
        self.skillThreeDetail.text = model.jiNengThree;
    }
    if (model.imagePath) {
        NSString *imagePath = [[NSBundle mainBundle] pathForResource:model.imagePath ofType:nil];
        if (imagePath) {
            self.iconIV.image = [UIImage imageWithContentsOfFile:imagePath];
        }else
        {
            [self.iconIV sd_setImageWithURL:[NSURL URLWithString:model.imagePath]];
        }
    }
    self.selectedBtn.selected = model.isChoose;
}
- (void)p_createUI
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.linJiLb = [self createUILabel:@"灵基:" textColor:[UIColor blackColor]];
    self.skillOne = [self createUILabel:@"技能1:" textColor:[UIColor blackColor]];
    self.skillTwo = [self createUILabel:@"技能2:" textColor:[UIColor blackColor]];
    self.skillThree = [self createUILabel:@"技能3:" textColor:[UIColor blackColor]];
    
    self.linJiDetail = [self createUILabel:@"" textColor:kJHSColor];
    self.skillOneDetail = [self createUILabel:@"" textColor:kJHSColor];
    self.skillTwoDetail = [self createUILabel:@"" textColor:kJHSColor];
    self.skillThreeDetail = [self createUILabel:@"" textColor:kJHSColor];
    
    [self.contentView addSubview:self.iconIV];
    [self.contentView addSubview:self.linJiLb];
    [self.contentView addSubview:self.linJiDetail];
    [self.contentView addSubview:self.skillOne];
    [self.contentView addSubview:self.skillOneDetail];
    [self.contentView addSubview:self.skillTwo];
    [self.contentView addSubview:self.skillTwoDetail];
    [self.contentView addSubview:self.skillThree];
    [self.contentView addSubview:self.skillThreeDetail];
    [self.contentView addSubview:self.selectedBtn];
    
    [self.iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.size.equalTo(CGSizeMake(45, 45));
        make.centerY.equalTo(0);
    }];
    [self.linJiLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconIV.mas_right).offset(5);
        make.top.equalTo(self.iconIV.mas_top).offset(0);
        make.size.equalTo(CGSizeMake(40, kLabelHeight));
    }];
    [self.linJiDetail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.linJiLb.mas_right).offset(0);
        make.top.equalTo(self.iconIV.mas_top).offset(0);
        make.size.equalTo(CGSizeMake(60, kLabelHeight));
    }];
    [self.skillOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconIV.mas_right).offset(5);
        make.bottom.equalTo(self.iconIV.mas_bottom).offset(0);
        make.size.equalTo(CGSizeMake(kLabelWidth, kLabelHeight));
    }];
    [self.skillOneDetail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.skillOne.mas_right).offset(0);
        make.bottom.equalTo(self.iconIV.mas_bottom).offset(0);
        make.size.equalTo(CGSizeMake(kLabelDetailwidth, kLabelHeight));

    }];
    [self.skillTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.skillOneDetail.mas_right).offset(0);
        make.bottom.equalTo(self.iconIV.mas_bottom).offset(0);
        make.size.equalTo(CGSizeMake(kLabelWidth, kLabelHeight));

    }];
    [self.skillTwoDetail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.skillTwo.mas_right).offset(0);
        make.bottom.equalTo(self.iconIV.mas_bottom).offset(0);
        make.size.equalTo(CGSizeMake(kLabelDetailwidth, kLabelHeight));

    }];
    [self.skillThree mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.skillTwoDetail.mas_right).offset(0);
        make.bottom.equalTo(self.iconIV.mas_bottom).offset(0);
        make.size.equalTo(CGSizeMake(kLabelWidth, kLabelHeight));

    }];
    [self.skillThreeDetail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.skillThree.mas_right).offset(0);
        make.bottom.equalTo(self.iconIV.mas_bottom).offset(0);
        make.size.equalTo(CGSizeMake(kLabelDetailwidth, kLabelHeight));
    }];
    [self.selectedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(0);
        make.size.equalTo(CGSizeMake(60, 40));
        make.right.equalTo(05);
    }];

}
- (UILabel *)createUILabel:(NSString *)title textColor:(UIColor *)color
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.font = [UIFont systemFontOfSize:14];
    label.text = title;
    label.textColor = color;
    return label;
}
#pragma mark - Lazy load
- (UIImageView *)iconIV
{
    if (!_iconIV) {
        _iconIV = [[UIImageView alloc] initWithFrame:CGRectZero];
    }
    return _iconIV;
}
- (UIButton *)selectedBtn
{
    if (!_selectedBtn) {
        _selectedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectedBtn setImage:[UIImage imageNamed:@"unselected"] forState:UIControlStateNormal];
        [_selectedBtn setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateSelected];
        [_selectedBtn addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectedBtn;
}
- (void)tapAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    self.model.isChoose = sender.selected;
}
@end
