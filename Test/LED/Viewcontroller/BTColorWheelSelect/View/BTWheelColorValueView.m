//
//  BTWheelColorValueView.m
//  BTMate
//
//  Created by Mac on 2017/8/18.
//  Copyright © 2017年 QiXing. All rights reserved.
//

#import "BTWheelColorValueView.h"

@interface BTWheelColorValueView ()

@property (nonatomic, strong) UIImageView *bgView;
@property (nonatomic, strong) UIImageView *redLabel;
@property (nonatomic, strong) UILabel *redValue;
@property (nonatomic, strong) UIImageView *greenLabel;
@property (nonatomic, strong) UILabel *greenValue;
@property (nonatomic, strong) UIImageView *blueLabel;
@property (nonatomic, strong) UILabel *blueValue;

@property (nonatomic, strong) UIButton *tapBtn;

@end

@implementation BTWheelColorValueView

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self).offset(0);
    }];
    
    [self.blueValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-1);
        make.centerY.equalTo(self);
        [self.blueValue sizeToFit];
    }];
    
    [self.blueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.blueValue.mas_left).offset(-2);
        make.centerY.equalTo(self);
        make.width.equalTo(@(9));
        make.height.equalTo(@(10));
    }];
    
    [self.greenValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.blueLabel.mas_left).offset(-1);
        make.centerY.equalTo(self);
        [self.greenValue sizeToFit];
    }];
    
    [self.greenLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.greenValue.mas_left).offset(-2);
        make.centerY.equalTo(self);
        make.width.equalTo(@(9));
        make.height.equalTo(@(10));
    }];
    
    [self.redValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.greenLabel.mas_left).offset(-1);
        make.centerY.equalTo(self);
        [self.redValue sizeToFit];
    }];
    
    [self.redLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.redValue.mas_left).offset(-1);
        make.centerY.equalTo(self);
        make.width.equalTo(@(9));
        make.height.equalTo(@(10));
    }];
    
    [self.tapBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self).offset(0);
    }];
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        [self cn_startai_initContentView];
    }
    return self;
}

- (void)cn_startai_initContentView
{
    [self addSubview:self.bgView];
    [self addSubview:self.redLabel];
    [self addSubview:self.redValue];
    [self addSubview:self.greenLabel];
    [self addSubview:self.greenValue];
    [self addSubview:self.blueLabel];
    [self addSubview:self.blueValue];
    [self addSubview:self.tapBtn];
}

- (UIImageView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIImageView alloc] init];
        _bgView.image = [UIImage imageNamed:@"colorValueBg"];
        _bgView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _bgView;
}

- (UIImageView *)redLabel
{
    if (!_redLabel) {
        _redLabel = ({
            UIImageView *tmpL = [[UIImageView alloc] initWithFrame:CGRectZero];
            tmpL.image = [UIImage imageNamed:@"r"];
            
            tmpL;
        });
    }
    return _redLabel;
    
}

- (UILabel *)redValue
{
    if (!_redValue) {
        _redValue = ({
            UILabel *tmpL = [[UILabel alloc] initWithFrame:CGRectZero];
            tmpL.textColor = [UIColor colorWithHexColorString:@"1C1C19"];
            tmpL.font = [UIFont fontWithName:@"Arial" size:10];
            tmpL.text = @"127";
            
            tmpL;
        });
    }
    return _redValue;
    
}

-(UIImageView *)greenLabel
{
    if (!_greenLabel) {
        _greenLabel = ({
            UIImageView *tmpL = [[UIImageView alloc] initWithFrame:CGRectZero];
            tmpL.image = [UIImage imageNamed:@"g"];
            
            tmpL;
        });
    }
    return _greenLabel;
    
}

- (UILabel *)greenValue
{
    if (!_greenValue) {
        _greenValue = ({
            UILabel *tmpL = [[UILabel alloc] initWithFrame:CGRectZero];
            tmpL.textColor = [UIColor colorWithHexColorString:@"1C1C19"];
            tmpL.font = [UIFont fontWithName:@"Arial" size:10];
            tmpL.text = @"127";
            
            tmpL;
        });
    }
    return _greenValue;
    
}

- (UIImageView *)blueLabel
{
    if (!_blueLabel) {
        _blueLabel = ({
            UIImageView *tmpL = [[UIImageView alloc] initWithFrame:CGRectZero];
            tmpL.image = [UIImage imageNamed:@"b"];

            
            tmpL;
        });
    }
    return _blueLabel;
    
}

- (UILabel *)blueValue
{
    if (!_blueValue) {
        _blueValue = ({
            UILabel *tmpL = [[UILabel alloc] initWithFrame:CGRectZero];
            tmpL.textColor = [UIColor colorWithHexColorString:@"1C1C19"];
            tmpL.font = [UIFont fontWithName:@"Arial" size:10];
            tmpL.text = @"127";
            
            tmpL;
        });
    }
    return _blueValue;
    
}

- (UIButton *)tapBtn
{
    if (!_tapBtn) {
        _tapBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_tapBtn setBackgroundColor:[UIColor clearColor]];
        [_tapBtn addTarget:self action:@selector(tapSelf) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tapBtn;
}


#pragma mark -event

- (void)tapSelf
{
    if (self.colorhandler) {
        self.colorhandler();
    }
}

- (void)updateColorValueWithRed:(NSInteger)red Green:(NSInteger)green Blue:(NSInteger)blue
{
    self.redValue.text = [NSString stringWithFormat:@"%ld", red];
    self.greenValue.text = [NSString stringWithFormat:@"%ld", green];
    self.blueValue.text = [NSString stringWithFormat:@"%ld", blue];
    
    [self layoutIfNeeded];
}

@end
