//
//  FGJiNengTableViewCell.m
//  FGO
//
//  Created by 孔志林 on 2018/11/21.
//  Copyright © 2018年 KMingMing. All rights reserved.
//

#import "FGJiNengTableViewCell.h"
@interface FGJiNengTableViewCell ()
/**  头像    */
@property (nonatomic, strong) UIImageView *heroIcon;
/**  技能名字、等级、技能等级     */
@property (nonatomic, strong) UILabel *jnName , *djLabel, *jndjLabel;
/**  滑块    */
@property (nonatomic, strong) UISlider *slider;

@end

@implementation FGJiNengTableViewCell
+ (CGFloat)p_getCellHeight
{
    return 0.0;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = kGrayColor;
        }
    return self;
}
- (void)p_createTopCell
{
    [self.contentView addSubview:self.heroIcon];
    [self.contentView addSubview:self.jnName];
    [self.contentView addSubview:self.jndjLabel];
    
    self.jndjLabel.font = [UIFont systemFontOfSize:14];
    self.jndjLabel.textColor = kJHSColor;
    [self.heroIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(50, 50));
        make.left.top.equalTo(10);
    }];
    [self.jnName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.heroIcon.mas_right).offset(10);
        make.right.equalTo(0);
        make.top.equalTo(self.heroIcon.mas_top).offset(0);
        make.height.equalTo(20);
    }];
    [self.jndjLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.heroIcon.mas_right).offset(10);
        make.right.equalTo(0);
        make.bottom.equalTo(self.heroIcon.mas_bottom).offset(0);
        make.height.equalTo(20);
    }];
}

- (void)p_createCenterCell
{
    [self.contentView addSubview:self.jnName];
    self.jnName.textColor = [UIColor grayColor];
    self.jnName.font = [UIFont systemFontOfSize:14];
    self.jnName.adjustsFontSizeToFitWidth = YES;
    [self.jnName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.offset(0);
        make.left.offset(10);
        make.height.equalTo(20);
    }];
    for (int i = 0; i<10; i++) {
        UILabel *label = [self p_createUILabel];
        label.textAlignment = NSTextAlignmentCenter;
        label.tag = 100 + i;
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = kqlsColor;
        label.layer.borderColor = [UIColor grayColor].CGColor;
        label.layer.borderWidth = .5;
        label.layer.masksToBounds = YES;
        label.font = [UIFont systemFontOfSize:10];
        label.adjustsFontSizeToFitWidth = YES;
        label.highlightedTextColor = kJHSColor;
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(10 + i * (MainWidth - 20)/10.0);
            make.top.equalTo(self.jnName.mas_bottom).offset(0);
            make.bottom.equalTo(0);
            make.width.equalTo((MainWidth - 20)/10.0);
        }];
    }
}

- (void)p_createSliderCell
{
    [self.contentView addSubview:self.jndjLabel];
    self.jndjLabel.text = @"技能等级";
    [self.contentView addSubview:self.slider];
    [self.contentView addSubview:self.djLabel];
    self.djLabel.textColor = [UIColor grayColor];
    self.djLabel.font = [UIFont systemFontOfSize:16];
    [self.jndjLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.centerY.equalTo(0);
        make.width.equalTo(100);
        make.height.equalTo(20);
    }];
    [self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(0);
        make.left.equalTo(self.jndjLabel.mas_right).equalTo(10);
        make.right.equalTo(-40);
        make.height.equalTo(20);
    }];
    [self.djLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(0);
        make.left.equalTo(self.slider.mas_right).equalTo(10);
        make.right.equalTo(-10);
        make.size.equalTo(CGSizeMake(20, 20));
    }];
}

- (UILabel *)p_createUILabel
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    return label;
}


#pragma mark - Lazy load
- (UIImageView *)heroIcon
{
    if (!_heroIcon) {
        _heroIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
        _heroIcon.contentMode = UIViewContentModeScaleAspectFit;
//        _heroIcon.image = [UIImage imageNamed:@"Quick"];
        _heroIcon.backgroundColor = [UIColor purpleColor];
    }
    return _heroIcon;
}
- (UILabel *)jnName {
    if (!_jnName) {
        _jnName = [self p_createUILabel];
    }
    return _jnName;
}
- (UILabel *)djLabel {
    if (!_djLabel) {
        _djLabel = [self p_createUILabel];
    }
    return _djLabel;
}
- (UILabel *)jndjLabel {
    if (!_jndjLabel) {
        _jndjLabel = [self p_createUILabel];
    }
    return _jndjLabel;
}
- (UISlider *)slider
{
    if (!_slider) {
        _slider = [[UISlider alloc] initWithFrame:CGRectZero];
        _slider.minimumValue = 1;// 设置最小值
        _slider.maximumValue = 10;// 设置最大值
        _slider.value = 1;// 设置初始值
        _slider.continuous = YES;// 设置可连续变化
        _slider.minimumTrackTintColor = kSelectedColor; //滑轮左边颜色，如果设置了左边的图片就不会显示
//        _slider.maximumTrackTintColor = [UIColor redColor]; //滑轮右边颜色，如果设置了右边的图片就不会显示
//        _slider.thumbTintColor = [UIColor redColor];//设置白点颜色
        [_slider setThumbImage:[UIImage imageNamed:@"slider"] forState:UIControlStateNormal];
        [_slider addTarget:self action:@selector(sliderChange:) forControlEvents:UIControlEventValueChanged];
    }
    return _slider;
}
- (void)sliderChange:(UISlider *)sender
{
    NSInteger index = [@(sender.value) integerValue];
    self.djLabel.text = [NSString stringWithFormat:@"%ld",(long)index];
    if ([self.delegate respondsToSelector:@selector(sliderTableViewCell:didSelected:)]) {
        FGJiNengLabelTableViewCellModel *model = [FGJiNengLabelTableViewCellModel new];
        model.section = self.section;
        model.sliderValue = sender.value;
        [self.delegate sliderTableViewCell:self didSelected:model];
    }
    
}
@end

@implementation FGJiNengTopTableViewCell
+ (CGFloat)p_getCellHeight
{
    return 70;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self p_createTopCell];
    }
    return self;
}
- (void)setSkillModel:(FGHeroDetailSkillModel *)skillModel
{
    _skillModel = skillModel;
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:skillModel.imgPath ofType:nil];
    if (imagePath) {
        self.heroIcon.image = [UIImage imageWithContentsOfFile:imagePath];
    }else
    {
        [self.heroIcon sd_setImageWithURL:[NSURL URLWithString:skillModel.imgPath]];
    }
    self.jnName.text = skillModel.skillName; //技能（cd）
}
- (void)setUpdateModel:(FGSaveJNModel *)updateModel
{
    _updateModel = updateModel;
    self.jndjLabel.text = updateModel.levelDetail;
}
@end

@implementation FGJiNengLabelTableViewCell
- (void)setJiNengModel:(FGJiNengModel *)jiNengModel
{
    _jiNengModel = jiNengModel;
    
    self.jnName.text = jiNengModel.jNDetail;
    [jiNengModel.skillNumbers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSInteger tag = idx + 100;
        UILabel *lb = [self.contentView viewWithTag:tag];
        NSString *text = [obj stringByReplacingOccurrencesOfString:@"/" withString:@"\n"];
        lb.text = text;
    }];
}

- (void)setLevelsModel:(FGLevelsModel *)levelsModel
{
    _levelsModel = levelsModel;
    self.jnName.text = levelsModel.skillDesc;
    [levelsModel.lv enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSInteger tag = idx + 100;
        UILabel *lb = [self.contentView viewWithTag:tag];
        lb.text = obj;
    }];
}
- (void)setUpdateModel:(FGSaveJNModel *)updateModel
{
    _updateModel = updateModel;
    for (UIView *lb in self.contentView.subviews) {
        if ([lb isKindOfClass:[UILabel class]]) {
            UILabel *lable = (UILabel *)lb;
            if (lable.tag == updateModel.labelTag) {
                lable.highlighted = YES;
            }else{
                lable.highlighted = NO;
            }
        }
    }
}
+ (CGFloat)p_getCellHeight
{
    return 40;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self p_createCenterCell];
    }
    return self;
}

@end

@implementation FGJiNengSliderTableViewCell
+ (CGFloat)p_getCellHeight
{
    return 60;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self p_createSliderCell];
        
        //阴影效果
        self.layer.shadowColor = [UIColor greenColor].CGColor;
        //阴影的透明度
        self.layer.shadowOpacity = 0.5f;
        //阴影的圆角---阴影的范围
        self.layer.shadowRadius = 3.0f;
        //阴影偏移量
        self.layer.shadowOffset = CGSizeMake(0,1);
    }
    return self;
}
- (void)setUpdateModel:(FGSaveJNModel *)updateModel
{
    _updateModel = updateModel;
    self.slider.value = updateModel.level; //更新slider的值
    self.djLabel.text = [NSString stringWithFormat:@"%ld",updateModel.level];//更新右边lable的值
}
@end

@implementation FGJiNengLabelTableViewCellModel

@end


@implementation FGJiNengModel

@end
