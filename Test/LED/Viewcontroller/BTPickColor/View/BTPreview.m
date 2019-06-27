//
//  BTPreview.m
//  BTMate
//
//  Created by Mac on 2017/8/21.
//  Copyright © 2017年 QiXing. All rights reserved.
//

#import "BTPreview.h"

@interface BTPreview ()

@property (nonatomic, strong) UIImageView *borderView;
@property (nonatomic, strong) UIView *colorView;
@property (nonatomic, strong) UILabel *Rlabel;
@property (nonatomic, strong) UILabel *Glabel;
@property (nonatomic, strong) UILabel *Blabel;

@end

@implementation BTPreview

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.borderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(0);
        make.top.equalTo(self.mas_top).offset(0);
        make.width.equalTo(@((SCREEN_WITDH-58*2)/4.0+74));
        make.height.equalTo(@((SCREEN_WITDH-58*2)/4.0+20));
    }];
    
    [self.colorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.borderView);
        make.top.equalTo(self.borderView.mas_top).offset(8);
        make.width.height.equalTo(@((SCREEN_WITDH-58*2)/4.0));
    }];
    
    [self.Rlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.borderView.mas_right).offset(31);
        make.top.equalTo(self.mas_top).offset(0);
        [self.Rlabel sizeToFit];
    }];
    
    [self.Glabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.borderView.mas_right).offset(31);
        make.top.equalTo(self.Rlabel.mas_bottom).offset(5);
        [self.Glabel sizeToFit];
    }];
    
    [self.Blabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.borderView.mas_right).offset(31);
        make.top.equalTo(self.Glabel.mas_bottom).offset(5);
        [self.Blabel sizeToFit];
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
    [self addSubview:self.borderView];
    [self addSubview:self.colorView];
    [self addSubview:self.Rlabel];
    [self addSubview:self.Glabel];
    [self addSubview:self.Blabel];
}

- (UIImageView *)borderView
{
    if (!_borderView) {
        _borderView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _borderView.layer.borderColor = [UIColor blackColor].CGColor;
        _borderView.layer.borderWidth = 1;
        _borderView.layer.cornerRadius = 5;
        _borderView.image = [UIImage imageNamed:@"SelectedBox"];
    }
    return _borderView;
}

- (UIView *)colorView
{
    if (!_colorView) {
        _colorView = [[UIView alloc] initWithFrame:CGRectZero];
        
    }
    return _colorView;
}

- (UILabel *)Rlabel
{
    if (!_Rlabel) {
        _Rlabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _Rlabel.font = [UIFont fontWithName:@"Arial" size:18];
        _Rlabel.text = @"R-";
    }
    return _Rlabel;
}

- (UILabel *)Glabel
{
    if (!_Glabel) {
        _Glabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _Glabel.font = [UIFont fontWithName:@"Arial" size:18];
        _Glabel.text = @"G-";
    }
    return _Glabel;
}

- (UILabel *)Blabel
{
    if (!_Blabel) {
        _Blabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _Blabel.font = [UIFont fontWithName:@"Arial" size:18];
        _Blabel.text = @"B-";
    }
    return _Blabel;
}

- (void)setColorWithRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue
{
    NSString *redStr = [NSString stringWithFormat:@"R-%ld",red];
    NSString *greenStr = [NSString stringWithFormat:@"G-%ld",green];
    NSString *blueStr = [NSString stringWithFormat:@"B-%ld",blue];
    
    self.colorView.backgroundColor = [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1];
    self.Rlabel.attributedText = [self getAttributteStr:redStr];
    self.Glabel.attributedText = [self getAttributteStr:greenStr];
    self.Blabel.attributedText = [self getAttributteStr:blueStr];
    
}

- (NSMutableAttributedString *)getAttributteStr:(NSString *)str
{
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:str];
   [att addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(2, str.length-2)];
    return att;
}

@end
