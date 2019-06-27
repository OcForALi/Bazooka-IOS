//
//  BTInpuValueView.m
//  BTMate
//
//  Created by Mac on 2017/8/18.
//  Copyright © 2017年 QiXing. All rights reserved.
//

#import "BTInpuValueView.h"

@interface BTInpuValueView ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation BTInpuValueView

- (void)layoutSubviews
{
    [super layoutSubviews];

    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(0);
        make.top.equalTo(self.mas_top).offset(0);
        make.width.equalTo(@(40));
        make.height.equalTo(@(20));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.textField.mas_left).offset(-2);
        make.top.equalTo(self.mas_top).offset(1);
        [self.titleLabel sizeToFit];
    }];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self cn_startai_initContentView];
    }
    return self;
}

- (void)cn_startai_initContentView
{
    [self addSubview:self.titleLabel];
    [self addSubview:self.textField];
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:12];
        _titleLabel.text = @"On(ms)";
    }
    return _titleLabel;
}

- (UITextField *)textField
{
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.layer.borderWidth = 1;
        _textField.layer.borderColor = [UIColor blackColor].CGColor;
        _textField.font = [UIFont systemFontOfSize:12];
        _textField.text = @"1000";
        _textField.keyboardType = UIKeyboardTypeNumberPad;
        [_textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _textField;
}

- (void)textFieldDidChange:(UITextField *)textfield
{
    if (textfield.text.length>5) {
        return;
    }
    if (self.BTInpuValueHandler) {
        self.BTInpuValueHandler([textfield.text integerValue]);
    }
}

- (void)setValueWithTitle:(NSString *)title Value:(NSInteger)value
{
    self.titleLabel.text = title;
    self.textField.text = [NSString stringWithFormat:@"%ld",value];
    [self layoutIfNeeded];
}



@end
