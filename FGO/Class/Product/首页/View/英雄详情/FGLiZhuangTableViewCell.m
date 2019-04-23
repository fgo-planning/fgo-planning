//
//  FGLiZhuangTableViewCell.m
//  FGO
//
//  Created by 孔志林 on 2018/12/4.
//  Copyright © 2018年 KMingMing. All rights reserved.
//

#import "FGLiZhuangTableViewCell.h"
@interface FGLiZhuangTableViewCell ()
/**  顶部标题    */
@property (nonatomic, strong) UILabel *topTitle;
/**  图片    */
@property (nonatomic, strong) UIImageView *leftImageView;
/**  画师    */
@property (nonatomic, strong) UILabel *hsLabel, *hsDetail;
/**  稀有度    */
@property (nonatomic, strong) UILabel *xydLabel, *xydDetail;
/**  cost    */
@property (nonatomic, strong) UILabel *costLabel, *costDetil;
/**  ATK    */
@property (nonatomic, strong) UILabel *atkLabel, *atkDetail;
/**  HP    */
@property (nonatomic, strong) UILabel *hpLabel, *hpDetail;
/**  技能    */
@property (nonatomic, strong) UILabel *jnLabel, *jnDetail;
/**  满破    */
@property (nonatomic, strong) UILabel *mpLabel, *mpDetail;
/**  下面的宝具描述    */
@property (nonatomic, strong) UILabel *bjDetial;
/**  查看卡面    */
@property (nonatomic, strong) UIButton *lookBtn;
@end
static const CGFloat kLabelHeight = 30;
#define kLabelWith (MainWidth - 30 - 90)/4.0

@implementation FGLiZhuangTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self p_creatrUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
-(NSAttributedString *)getAttributedStringWithString:(NSString *)string lineSpace:(CGFloat)lineSpace {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;//文本对齐方式 左右对齐（两边对齐）
    paragraphStyle.lineSpacing = lineSpace; // 调整行间距
    NSRange range = NSMakeRange(0, [string length]);
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
    return attributedString;
}
- (void)setCardInfoModel:(FGHeroDetailCardInfoModel *)cardInfoModel
{
    if (!cardInfoModel) {
        [self.contentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
        }];
        return;
    }
    _cardInfoModel = cardInfoModel;
    NSAttributedString *string = [self getAttributedStringWithString:cardInfoModel.intro lineSpace:12];
    self.bjDetial.attributedText = string;
    self.topTitle.text = cardInfoModel.nameCn;
    self.hsDetail.text = cardInfoModel.illust;
    self.xydDetail.text = [NSString stringWithFormat:@"%@星",cardInfoModel.star];
    self.costDetil.text = [cardInfoModel.cost stringValue];
    self.atkDetail.text = [NSString stringWithFormat:@"%@/%@",cardInfoModel.lv1Atk, cardInfoModel.lvmaxAtk];
    self.hpDetail.text = [NSString stringWithFormat:@"%@/%@",cardInfoModel.lv1Hp, cardInfoModel.lvmaxHp];
    self.jnDetail.text = cardInfoModel.skillE;
    self.mpDetail.text = cardInfoModel.skillMaxE;
    [self.leftImageView sd_setImageWithURL:[NSURL URLWithString:cardInfoModel.avastar]];
}
- (void)p_creatrUI
{
    self.contentView.backgroundColor = kGrayColor;
    self.topTitle = [self p_createDLSLabel:@""];
    self.hsLabel = [self p_createDLSLabel:@"画师"];
    self.xydLabel = [self p_createDLSLabel:@"稀有度"];
    self.costLabel = [self p_createDLSLabel:@"COST"];
    self.atkLabel = [self p_createDLSLabel:@"ATK"];
    self.hpLabel = [self p_createDLSLabel:@"HP"];
    self.jnLabel = [self p_createDLSLabel:@"技能"];
    self.mpLabel = [self p_createDLSLabel:@"满破"];
    self.bjDetial = [self p_createDLSLabel:@""];
    self.hsDetail = [self p_createQLSLabel];
    self.xydDetail = [self p_createQLSLabel];
    self.costDetil = [self p_createQLSLabel];
    self.atkDetail = [self p_createQLSLabel];
    self.hpDetail = [self p_createQLSLabel];
    self.jnDetail = [self p_createQLSLabel];
    self.mpDetail = [self p_createQLSLabel];

    [self.contentView addSubview:self.topTitle];
    [self.contentView addSubview:self.leftImageView];
    [self.contentView addSubview:self.hsLabel];
    [self.contentView addSubview:self.hsDetail];
    [self.contentView addSubview:self.xydLabel];
    [self.contentView addSubview:self.xydDetail];
    [self.contentView addSubview:self.costLabel];
    [self.contentView addSubview:self.costDetil];
    [self.contentView addSubview:self.atkLabel];
    [self.contentView addSubview:self.atkDetail];
    [self.contentView addSubview:self.hpLabel];
    [self.contentView addSubview:self.hpDetail];
    [self.contentView addSubview:self.jnLabel];
    [self.contentView addSubview:self.jnDetail];
    [self.contentView addSubview:self.mpLabel];
    [self.contentView addSubview:self.mpDetail];
    [self.contentView addSubview:self.bjDetial];
    [self.contentView addSubview:self.lookBtn];
    
    [self.topTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(0);
        make.left.equalTo(15);
        make.right.equalTo(-15);
        make.height.equalTo(kLabelHeight);
    }];
    [self.leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topTitle.mas_bottom).offset(0);
        make.left.equalTo(15);
        make.size.equalTo(CGSizeMake(kLabelHeight * 3, kLabelHeight * 3));
    }];
    [self.hsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topTitle.mas_bottom).offset(0);
        make.left.equalTo(self.leftImageView.mas_right).offset(0);
        make.width.equalTo(kLabelWith);
        make.height.equalTo(kLabelHeight);
    }];
    [self.hsDetail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topTitle.mas_bottom).offset(0);
        make.left.equalTo(self.hsLabel.mas_right).offset(0);
        make.width.equalTo(MainWidth - 30 - kLabelHeight*3 - kLabelWith);
        make.height.equalTo(kLabelHeight);
    }];
    [self.xydLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.hsLabel.mas_bottom).offset(0);
        make.left.equalTo(self.leftImageView.mas_right).offset(0);
        make.width.equalTo(kLabelWith);
        make.height.equalTo(kLabelHeight);
    }];
    [self.xydDetail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.hsDetail.mas_bottom).offset(0);
        make.left.equalTo(self.xydLabel.mas_right).offset(0);
        make.width.equalTo(kLabelWith);
        make.height.equalTo(kLabelHeight);
    }];
    [self.costLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.hsLabel.mas_bottom).offset(0);
        make.left.equalTo(self.xydDetail.mas_right).offset(0);
        make.width.equalTo(kLabelWith);
        make.height.equalTo(kLabelHeight);
    }];
    [self.costDetil mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.hsDetail.mas_bottom).offset(0);
        make.left.equalTo(self.costLabel.mas_right).offset(0);
        make.width.equalTo(kLabelWith);
        make.height.equalTo(kLabelHeight);
    }];
    [self.atkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.xydDetail.mas_bottom).offset(0);
        make.left.equalTo(self.leftImageView.mas_right).offset(0);
        make.width.equalTo(kLabelWith);
        make.height.equalTo(kLabelHeight);

    }];
    [self.atkDetail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.xydDetail.mas_bottom).offset(0);
        make.left.equalTo(self.atkLabel.mas_right).offset(0);
        make.width.equalTo(kLabelWith);
        make.height.equalTo(kLabelHeight);
    }];
    [self.hpLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.xydDetail.mas_bottom).offset(0);
        make.left.equalTo(self.atkDetail.mas_right).offset(0);
        make.width.equalTo(kLabelWith);
        make.height.equalTo(kLabelHeight);
    }];
    [self.hpDetail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.xydDetail.mas_bottom).offset(0);
        make.left.equalTo(self.hpLabel.mas_right).offset(0);
        make.width.equalTo(kLabelWith);
        make.height.equalTo(kLabelHeight);
    }];
    [self.jnLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.leftImageView.mas_bottom).offset(0);
        make.left.equalTo(15);
        make.width.equalTo(kLabelHeight *2.5);
        make.height.equalTo(kLabelHeight * 3);
    }];
    [self.jnDetail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.leftImageView.mas_bottom).offset(0);
        make.left.equalTo(self.jnLabel.mas_right).offset(0);
        make.width.equalTo(MainWidth - 30 - kLabelHeight *2.5);
        make.height.equalTo(kLabelHeight * 3);
    }];
    [self.mpLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.jnDetail.mas_bottom).offset(0);
        make.left.equalTo(15);
        make.width.equalTo(kLabelHeight *2.5);
        make.height.equalTo(kLabelHeight);
    }];
    [self.mpDetail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.jnDetail.mas_bottom).offset(0);
        make.left.equalTo(self.mpLabel.mas_right).offset(0);
        make.width.equalTo(MainWidth - 30 - kLabelHeight *2.5);
        make.height.equalTo(kLabelHeight);
    }];
    [self.bjDetial mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mpDetail.mas_bottom).offset(0);
        make.left.equalTo(15);
        make.right.equalTo(-15);
        make.bottom.offset(-kLabelHeight-5);
    }];
    [self.lookBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bjDetial.mas_bottom).offset(0);
        make.left.equalTo(15);
        make.right.equalTo(-15);
        make.height.equalTo(kLabelHeight);
    }];
}
+ (CGFloat)p_getCellHeight
{
    return 700;
}
- (void)tapAction:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(tapFGLiZhuangTableViewCellLookBtn:)]) {
        [self.delegate tapFGLiZhuangTableViewCellLookBtn:self];
    }
}
- (UILabel *)p_createDLSLabel:(NSString *)title
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.layer.borderWidth = .5;
    label.layer.borderColor = [UIColor grayColor].CGColor;
    label.backgroundColor = kDLSColor;
    label.font = [UIFont systemFontOfSize:15];
    label.text = title;
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}
- (UILabel *)p_createQLSLabel
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.layer.borderWidth = .5;
    label.layer.borderColor = [UIColor grayColor].CGColor;
    label.backgroundColor = kqlsColor;
    label.font = [UIFont systemFontOfSize:13];
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}
- (UIImageView *)leftImageView {
    if (!_leftImageView) {
        _leftImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _leftImageView.layer.borderWidth = .5;
        _leftImageView.layer.borderColor = [UIColor grayColor].CGColor;
        UITapGestureRecognizer *rg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        _leftImageView.userInteractionEnabled = YES;
        [_leftImageView addGestureRecognizer:rg];
    }
    return _leftImageView;
}
- (UIButton *)lookBtn {
    if (!_lookBtn) {
        _lookBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_lookBtn setTitle:@"查看卡面" forState:UIControlStateNormal];
        [_lookBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _lookBtn.layer.borderWidth = .5;
        _lookBtn.layer.borderColor = [UIColor grayColor].CGColor;
        _lookBtn.backgroundColor = kDLSColor;
        [_lookBtn addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _lookBtn;
}
@end
