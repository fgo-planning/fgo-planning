//
//  FGBaoJuTableViewCell.m
//  FGO
//
//  Created by 孔志林 on 2018/12/3.
//  Copyright © 2018年 KMingMing. All rights reserved.
//

#import "FGBaoJuTableViewCell.h"
@interface FGBaoJuTableViewCell ()
/**  宝具图片    */
@property (nonatomic, strong) UIImageView *leftImageView;
/**  宝具标题、副标题、   */
@property (nonatomic, strong) UILabel *bjTitle, *bjDetail;
/**  宝具动画    */
@property (nonatomic, strong) UIButton *bjDHBtn;
/**  技能详情描述    */
@property (nonatomic, strong) UILabel *skillDetail;
@end

@implementation FGBaoJuTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = kGrayColor;
    }
    return self;
}
+ (CGFloat)p_getCellHeight
{
    return 0;
}
- (void)tapAction:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(baoJuCellTapDHBtn:)]) {
        [self.delegate baoJuCellTapDHBtn:self];
    }
}
#pragma mark - lazy load
- (UIImageView *)leftImageView {
    if (!_leftImageView) {
        _leftImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _leftImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _leftImageView;
}
- (UILabel *)bjTitle {
    if (!_bjTitle) {
        _bjTitle = [[UILabel alloc] initWithFrame:CGRectZero];
    }
    return _bjTitle;
}
- (UILabel *)bjDetail {
    if (!_bjDetail) {
        _bjDetail = [[UILabel alloc] initWithFrame:CGRectZero];
        _bjDetail.textColor = [UIColor grayColor];
    }
    return _bjDetail;
}
- (UIButton *)bjDHBtn {
    if (!_bjDHBtn) {
        _bjDHBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bjDHBtn setTitle:@"宝具动画" forState:UIControlStateNormal];
        [_bjDHBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_bjDHBtn addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];
        _bjDHBtn.layer.borderColor = [UIColor grayColor].CGColor;
        _bjDHBtn.layer.borderWidth = 1.0;
    }
    return _bjDHBtn;
}
- (UILabel *)skillDetail {
    if (!_skillDetail) {
        _skillDetail = [[UILabel alloc] initWithFrame:CGRectZero];
        _skillDetail.backgroundColor = kGrayColor;
        _skillDetail.textColor = [UIColor grayColor];
        _skillDetail.layer.borderColor = [UIColor grayColor].CGColor;
        _skillDetail.layer.borderWidth = 1.0;
        _skillDetail.textAlignment = NSTextAlignmentCenter;
        _skillDetail.font  = [UIFont systemFontOfSize:14];
    }
    return _skillDetail;
}
@end

@implementation FGBaoJuTopTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self p_createTopCell];
    }
    return self;
}
- (void)setModel:(FGHeroDetailTreasureModel *)model
{
    _model = model;
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"images/skill/%@",model.tType] ofType:@"png"];
    self.leftImageView.image = [UIImage imageWithContentsOfFile:imagePath];
    NSArray *array = [model.tName componentsSeparatedByString:@" "];
    self.bjTitle.text = array[0];
    if (array.count >1) {
        self.bjDetail.text = array[1];
    }
}
- (void)p_createTopCell
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.layer.borderColor = [UIColor grayColor].CGColor;
    view.layer.borderWidth = 1.0;
    view.backgroundColor = [UIColor p_rgbColorR:230 G:243 B:249];
    [self.contentView addSubview:view];
    [self.contentView addSubview:self.leftImageView];
    [self.contentView addSubview:self.bjTitle];
    [self.contentView addSubview:self.bjDetail];
    [self.contentView addSubview:self.bjDHBtn];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(0);
        make.left.equalTo(15);
        make.right.equalTo(-15);
    }];
    [self.leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.size.equalTo(CGSizeMake(50, 50));
        make.top.equalTo(5);
    }];
    [self.bjTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftImageView.mas_right).offset(10);
        make.top.equalTo(10);
        make.right.equalTo(-15);
        make.height.equalTo(20);
    }];
    [self.bjDetail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftImageView.mas_right).offset(10);
        make.top.equalTo(self.bjTitle.mas_bottom).offset(5);
        make.right.equalTo(-15);
        make.height.equalTo(15);
    }];
    [self.bjDHBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo (self.leftImageView.mas_bottom).offset(10);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.bottom.offset(0);
    }];
//    for (UIView *v in self.contentView.subviews) {
//        v.backgroundColor = [UIColor p_randomColor];
//    }
}
+ (CGFloat)p_getCellHeight
{
    return 90;
}
@end

@implementation FGBaoJuCenterTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self p_createCenterCell];
    }
    return self;
}
- (void)setModel:(FGBaoJuModel *)model
{
    _model = model;
    self.skillDetail.text = model.bjDetail;
    [model.skillNumbers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UILabel *label = [self.contentView viewWithTag:100 + idx];
        label.text = obj;
    }];
    if (model.skillNumbers.count == 1) {
        UILabel *label = [self.contentView viewWithTag:100];
        [label mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(15);
            make.width.equalTo((MainWidth - 30));
        }];
        for (int i = 1; i < 5; i++) {
            UILabel *elseLabel = [self.contentView viewWithTag:100 + i];
            [elseLabel removeFromSuperview];
        }
    }
}

- (void)p_createCenterCell
{
    [self.contentView addSubview:self.skillDetail];
    [self.skillDetail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.right.equalTo(-15);
        make.top.equalTo(0);
        make.height.equalTo(30);
    }];
    for (int i = 0; i < 5; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.tag = 100 + i;
        label.textAlignment = NSTextAlignmentCenter;
        label.layer.borderColor = [UIColor grayColor].CGColor;
        label.layer.borderWidth = .5;
        label.backgroundColor =  [UIColor p_rgbColorR:222 G:255 B:222];
        
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(0);
            make.left.equalTo(15 + i * (MainWidth - 30)/5.0);
            make.width.equalTo((MainWidth - 30)/5.0);
            make.height.equalTo(30);
        }];
    }
//    for (UIView *v in self.contentView.subviews) {
//        v.backgroundColor = [UIColor p_randomColor];
//    }

}
+ (CGFloat)p_getCellHeight
{
    return 60;
}
@end

@implementation FGBaoJuBottomTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self p_createBottomCell];
    }
    return self;
}
- (void)setModel:(FGHeroDetailTreasureModel *)model
{
    _model = model;
    if (!model) {
        return;
    }
    NSArray *array = @[model.qHit,model.aHit,model.aHit,model.bHit,model.bHit,model.exHit,model.npGet];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UILabel *label = [self.contentView viewWithTag:(100 + idx)];
        if (idx < array.count - 1) {
            label.text = [NSString stringWithFormat:@"%@Hits",obj];
        }else
        {
            label.text = obj;
        }
    }];
}

- (void)p_createBottomCell
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.layer.borderColor = [UIColor grayColor].CGColor;
    view.layer.borderWidth = 1.0;
    view.backgroundColor = kDLSColor;
    [self.contentView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(0);
        make.left.equalTo(15);
        make.right.equalTo(-15);
    }];
    NSArray *imageNames = @[@"Quick",@"Arts",@"Arts",@"Buster",@"Buster",@"Extra",@"NP_Get"];
    for (int i = 0; i<7; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        NSString *imagePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"images/skill/%@",imageNames[i]] ofType:@"png"];
        imageView.image = [UIImage imageWithContentsOfFile:imagePath];
        [self.contentView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(10);
            make.left.equalTo(15 + i * (MainWidth - 30)/7.0);
            make.width.equalTo((MainWidth - 30)/7.0);
            make.height.equalTo((MainWidth - 30)/7.0);
        }];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.tag = 100 + i;
        label.font = [UIFont systemFontOfSize:14 weight:UIFontWeightBold];
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(-10);
            make.left.equalTo(15 + i * (MainWidth - 30)/7.0);
            make.width.equalTo((MainWidth - 30)/7.0);
            make.height.equalTo(20);
        }];
    }
    
//    for (UIView *v in self.contentView.subviews) {
//        v.backgroundColor = [UIColor p_randomColor];
//    }

}
+ (CGFloat)p_getCellHeight
{
    return (MainWidth - 30)/7.0 + 20;
}
@end

@implementation FGBaoJuModel
@end
