//
//  FGAddCountView.m
//  FGO
//
//  Created by 孔志林 on 2018/12/7.
//  Copyright © 2018年 KMingMing. All rights reserved.
//

#import "FGAddCountView.h"
@interface FGAddCountView ()<UITextFieldDelegate>
/**  tf    */
@end

@implementation FGAddCountView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self p_createUI];
    }
    return self;
}

#pragma mark - 创建UI
- (void)p_createUI
{
    self.layer.borderWidth = .5;
    self.layer.borderColor = [UIColor grayColor].CGColor;
    self.layer.cornerRadius = 2.0;
    self.layer.masksToBounds = YES;
    UIButton *reduce = [UIButton buttonWithType:UIButtonTypeCustom];
    reduce.tag = 100;
    [reduce addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];
    [reduce setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    
    UITextField *textfied = [[UITextField alloc] initWithFrame:CGRectZero];
    textfied.layer.borderWidth = .5;
    textfied.layer.borderColor = [UIColor grayColor].CGColor;
    textfied.text = @"0";
    textfied.delegate = self;
    [textfied adjustsFontSizeToFitWidth];
    textfied.keyboardType = UIKeyboardTypeNumberPad;
    self.tf = textfied;
    
    UIButton *add = [UIButton buttonWithType:UIButtonTypeCustom];
    add.tag = 101;
    [add addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];
    [add setImage:[UIImage imageNamed:@"reduce"] forState:UIControlStateNormal];

    [self addSubview:reduce];
    [self addSubview:textfied];
    [self addSubview:add];
    
    [reduce mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(0);
        make.width.equalTo(30);
    }];
    
    [textfied mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(0);
        make.left.equalTo(reduce.mas_right).offset(0);
        make.right.equalTo(-30);
    }];
    
    [add mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(0);
        make.width.equalTo(30);
    }];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.tf) {
        //这里的if时候为了获取删除操作,如果没有次if会造成当达到字数限制后删除键也不能使用的后果.
        if (range.length == 1 && string.length == 0) {
            return YES;
        }
        //so easy
        else if (self.tf.text.length >= 6) {
            self.tf.text = [textField.text substringToIndex:6];
            return NO;
        }
    }
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSInteger text = [textField.text integerValue];
    textField.text = @(text).stringValue;
    if ([self.delegate respondsToSelector:@selector(FGAddCountView:index:)]) {
        [self.delegate FGAddCountView:self.tf index:self.indexPath];
    }
}

- (void)tapAction:(UIButton *)sender
{
    if (sender.tag == 100) {
        NSInteger count = [self.tf.text integerValue];
        if (count >0) {
            count -= 1;
            self.tf.text = @(count).stringValue;
        }
    }else {
        NSInteger count = [self.tf.text integerValue];
        if (count <999999) {
            count = count + 1;
            self.tf.text = @(count).stringValue;
        }
    }
    if ([self.delegate respondsToSelector:@selector(FGAddCountView:index:)]) {
        [self.delegate FGAddCountView:self.tf index:self.indexPath];
    }
}
@end

