//
//  PopView.m
//  Test
//
//  Created by Mac on 2017/10/13.
//  Copyright © 2017年 QiXing. All rights reserved.
//

#import "PopView.h"

@interface PopView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;

@end

@implementation PopView

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat vScale = IS_IPHONE_5_OR_LESS ? 2 : 1.5;
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(36));
        make.right.equalTo(@(-36));
        make.top.equalTo(@(self.height/4.0));
        [self.titleLabel sizeToFit];
    }];
    
    [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(36));
        make.bottom.equalTo(self.mas_bottom).offset(-41);
        make.width.equalTo(@(155/vScale));
        make.height.equalTo(@(85/vScale));
    }];
    
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-36));
        make.bottom.equalTo(self.mas_bottom).offset(-41);
        make.width.equalTo(@(155/vScale));
        make.height.equalTo(@(85/vScale));
    }];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.layer.masksToBounds = true;
        self.layer.cornerRadius = 5;
        [self cn_startai_initContentView];
    }
    return self;
}

- (void)cn_startai_initContentView
{
    [self addSubview:self.titleLabel];
    [self addSubview:self.leftBtn];
    [self addSubview:self.rightBtn];
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel  = [[UILabel alloc] init];
        _titleLabel.font = [UIFont fontWithName:@"Arial" size:22];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.numberOfLines = 0;
        _titleLabel.textColor = [UIColor colorWithHexColorString:@"231E15"];
    }
    return _titleLabel;
}

- (UIButton *)leftBtn
{

    if (!_leftBtn) {
        _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftBtn setBackgroundImage:[UIImage imageNamed:@"WhiteSelection"] forState:UIControlStateNormal];
        [_leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [_leftBtn setTitle:@"Cancle" forState:UIControlStateNormal];
        [_leftBtn addTarget:self action:@selector(leftClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftBtn;
}

- (UIButton *)rightBtn
{
    if (!_rightBtn) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightBtn setBackgroundImage:[UIImage imageNamed:@"BlueSelection"] forState:UIControlStateNormal];
        [_rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [_rightBtn setTitle:@"OK" forState:UIControlStateNormal];
        [_rightBtn addTarget:self action:@selector(rightClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}

#pragma mark - event

- (void)leftClick
{
    if (self.leftHandler) {
        self.leftHandler();
    }
}

- (void)rightClick
{
    if (self.rightHandler) {
        self.rightHandler();
    }
}

#pragma mark property

- (void)setText:(NSString *)text
{
    self.titleLabel.text = text;
}

- (void)setLeftImg:(NSString *)leftImg
{
    [self.leftBtn setBackgroundImage:[UIImage imageNamed:leftImg] forState:UIControlStateNormal];
}

- (void)setRightImg:(NSString *)rightImg
{
    [self.rightBtn setBackgroundImage:[UIImage imageNamed:rightImg] forState:UIControlStateNormal];
}

- (void)setLeftText:(NSString *)leftText
{
    [self.leftBtn setTitle:leftText forState:UIControlStateNormal];
}

- (void)setRightText:(NSString *)rightText
{
    [self.rightBtn setTitle:rightText forState:UIControlStateNormal];
}

@end
