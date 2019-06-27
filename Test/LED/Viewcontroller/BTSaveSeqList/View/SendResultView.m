//
//  SendResultView.m
//  Test
//
//  Created by Mac on 2018/1/4.
//  Copyright © 2018年 QiXing. All rights reserved.
//

#import "SendResultView.h"

@interface SendResultView ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIButton *ok;

@end

@implementation SendResultView

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(30);
        make.right.equalTo(self.mas_right).offset(-30);
        make.top.equalTo(@(self.height/4.0));
        make.height.equalTo(@(60));
    }];
    
    [self.ok mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(104 *1.5));
        make.height.equalTo(@(21*1.5));
        make.bottom.equalTo(self).offset(-35);
        make.centerX.equalTo(self);
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
    [self addSubview:self.ok];
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorWithHexColorString:@"333333"];
        _titleLabel.font = [UIFont boldSystemFontOfSize:19];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

- (UIButton *)ok
{
    if (!_ok) {
        _ok = [UIButton buttonWithType:UIButtonTypeCustom];
        [_ok setBackgroundImage:[UIImage imageNamed:@"ok"] forState:UIControlStateNormal];
        [_ok addTarget:self action:@selector(okAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _ok;
}

- (void)setTitle:(NSString *)title
{
    self.titleLabel.text = title;
}

- (void)okAction
{
    if (self.sendSucessdHandler) {
        self.sendSucessdHandler();
    }
}

@end
