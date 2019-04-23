//
//  FGUIPikerView.m
//  FGO
//
//  Created by 孔志林 on 2018/12/13.
//  Copyright © 2018年 KMingMing. All rights reserved.
//

#import "FGUIPikerView.h"
#import "FGSourePlanTableViewCell.h"
@interface FGUIPikerView ()<UIPickerViewDelegate,UIPickerViewDataSource>
/**  UIPiker    */
@property (nonatomic, strong) UIPickerView *pikerView;
/**  技能    */
@property (nonatomic, strong) NSArray *skills;
/**  等级    */
@property (nonatomic, strong) NSArray *levels;
/**  灵基等级    */
@property (nonatomic, strong) NSArray *linjis;
/**  英雄    */
@property (nonatomic, strong) FGSourePlanTableViewCell *cellView;
/**  保存    */
@property (nonatomic, copy) NSString *one,*two,*three;
/**  model    */
@property (nonatomic, strong) FGSourcePlanModel *model;
/**  <##>    */
@property (nonatomic, copy) NSString *jn1,*jn2,*jn3,*lj;
@end

@implementation FGUIPikerView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self p_createUI];
    }
    return self;
}
- (void)setPlanModel:(FGSourcePlanModel *)planModel
{
    _planModel = planModel;
    self.cellView.model = planModel;
}
- (void)p_createUI
{
    self.skills = @[@"灵基", @"技能1", @"技能2", @"技能3"];
    self.levels = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10"];
    self.linjis = @[@"0",@"1",@"2",@"3",@"4"];
    self.lj = @"0-4";
    self.jn1 = @"1-10";
    self.jn2 = @"1-10";
    self.jn3 = @"1-10";
    UIView *white = [[UIView alloc] initWithFrame:CGRectMake(0, MainHeight - HeightOfFromBottom - 320, MainWidth, 60)];
    white.backgroundColor = [UIColor whiteColor];
    [self addSubview:white];
    
    UIButton *cancle = [UIButton buttonWithType:UIButtonTypeCustom];
    cancle.tag = 100;
    [cancle setTitle:@"取消" forState:UIControlStateNormal];
    [cancle setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    cancle.frame = CGRectMake(15, 10, 60, 40);
    [cancle addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [white addSubview:cancle];
    
    UIButton *sure = [UIButton buttonWithType:UIButtonTypeCustom];
    sure.tag = 101;
    [sure setTitle:@"确定" forState:UIControlStateNormal];
    [sure setTitleColor:[UIColor p_rgbColorR:65 G:196 B:51] forState:UIControlStateNormal];
    sure.frame = CGRectMake(MainWidth - 15 - 60, 10, 60, 40);
    [sure addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [white addSubview:sure];

    
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.3];
    [self addSubview:self.pikerView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self addGestureRecognizer:tap];
    self.userInteractionEnabled = YES;
    
    [self pickerView:self.pikerView didSelectRow:0 inComponent:0];
}
- (void)tapAction
{
    [self removeFromSuperview];
}
#pragma mark - Delegate
//列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}
//某一列行数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0)  // 省会
    {
        return self.skills.count;
    }else  // 其他城市
    {
        return self.levels.count;
    }
}
//展示的内容
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {
        return self.skills[row];
    }
    else
    {
        return self.levels[row];
    }
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSString *linji;
    NSString *skillOne;
    NSString *skillTwo;
    NSString *skillThree;
    if (component == 0) {
        if (row == 0) {
            self.levels = @[@"0",@"1",@"2",@"3",@"4"];
        }else
        {
            self.levels = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10"];
        }
        [self.pikerView reloadAllComponents];
        [pickerView selectRow:0 inComponent:1 animated:YES];
        [pickerView selectRow:self.levels.count - 1 inComponent:2 animated:YES];
    }
    
    if (component == 0) {
        self.one = [self pickerView:self.pikerView titleForRow:row forComponent:component];
        self.two = [self pickerView:self.pikerView titleForRow:0 forComponent:1];
        self.three = [self pickerView:self.pikerView titleForRow:self.levels.count - 1 forComponent:2];
    }
    if (component == 1) {
        self.two = [self pickerView:self.pikerView titleForRow:row forComponent:component];

    }
    if (component == 2) {
        self.three = [self pickerView:self.pikerView titleForRow:row forComponent:component];
    }

    NSInteger start = [self.two integerValue];
    NSInteger end = [self.three integerValue];
    if ([self.one isEqualToString:@"灵基"])
    {
        if (start <= end) {
            self.lj = [NSString stringWithFormat:@"%ld-%ld",start,end];
            linji = [NSString stringWithFormat:@"%ld-%ld",start,end];

        }

    }else if([self.one isEqualToString:@"技能1"])
    {
        if (start <= end) {
            self.jn1 = [NSString stringWithFormat:@"%ld-%ld",start,end];
            skillOne = [NSString stringWithFormat:@"%ld-%ld",start,end];

        }
    }else if([self.one isEqualToString:@"技能2"])
    {
        if (start <= end) {
            self.jn2 = [NSString stringWithFormat:@"%ld-%ld",start,end];
            skillTwo = [NSString stringWithFormat:@"%ld-%ld",start,end];

        }
    }
    else{
        if (start <= end) {
            self.jn3 = [NSString stringWithFormat:@"%ld-%ld",start,end];
            skillThree = [NSString stringWithFormat:@"%ld-%ld",start,end];

        }
    }
    FGSourcePlanModel *model = [FGSourcePlanModel new];
    model.linJi = linji;
    model.jiNengOne = skillOne;
    model.jiNengTwo = skillTwo;
    model.jiNengThree = skillThree;
    self.cellView.model = model;
    
    self.model = model;
}
#pragma mark - lazy load
- (UIPickerView *)pikerView {
    if (!_pikerView) {
        _pikerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, MainHeight - HeightOfFromBottom - 260, MainWidth, 260)];
        _pikerView.delegate = self;
        _pikerView.dataSource = self;
        _pikerView.backgroundColor = [UIColor whiteColor];
        
        FGSourePlanTableViewCell *cell = [[FGSourePlanTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FGSourePlanTableViewCell"];
        cell.backgroundColor = [UIColor whiteColor];
        cell.frame = CGRectMake(0, 0, MainWidth, 60);
        cell.selectedBtn.hidden = YES;
        self.cellView = cell;
        [_pikerView addSubview:cell];
    }
    return _pikerView;
}
- (void)btnAction:(UIButton *)sender
{
    if (sender.tag == 101) { //确定
        if ([self.delegate respondsToSelector:@selector(FGUIPikerViewSure:index:)]) {
            self.planModel.jiNengOne = self.jn1;
            self.planModel.jiNengTwo = self.jn2;
            self.planModel.jiNengThree = self.jn3;
            self.planModel.linJi = self.lj;
            self.planModel.isChoose = YES;
            [self.delegate FGUIPikerViewSure:self.planModel index:self.indexPath];
        }
    }
    [self removeFromSuperview];
}
@end
