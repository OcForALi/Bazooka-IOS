//
//  BTSaveSeqListBar.m
//  BTMate
//
//  Created by Mac on 2017/8/22.
//  Copyright © 2017年 QiXing. All rights reserved.
//

#import "BTSaveSeqListBar.h"
#import "UIFont+Adjust.h"

@interface BTSaveSeqListBar ()

@property (nonatomic, strong) UILabel *serialLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *upwardLabel;
@property (nonatomic, strong) UILabel *downLabel;
@property (nonatomic, strong) UILabel *dateLabel;

@end

@implementation BTSaveSeqListBar

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.serialLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(20);
        make.top.equalTo(self.mas_top).offset(0);
        make.width.equalTo(@((SCREEN_WITDH-60)/5.0-20 ));
        make.height.equalTo(@(20));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.serialLabel.mas_right).offset(0);
        make.top.equalTo(self.mas_top).offset(0);
        make.width.equalTo(@((SCREEN_WITDH-60)/5.0));
        make.height.equalTo(@(20));
    }];
    
    [self.upwardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right).offset(0);
        make.top.equalTo(self.mas_top).offset(0);
        make.width.equalTo(@((SCREEN_WITDH-60)/5.0));
        make.height.equalTo(@(20));
    }];
    
    [self.downLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.upwardLabel.mas_right).offset(0);
        make.top.equalTo(self.mas_top).offset(0);
        make.width.equalTo(@((SCREEN_WITDH-60)/5.0+20));
        make.height.equalTo(@(20));
    }];

    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.downLabel.mas_right).offset(0);
        make.top.equalTo(self.mas_top).offset(0);
        make.width.equalTo(@((SCREEN_WITDH-60)/5.0-20));
        make.height.equalTo(@(20));
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
    [self addSubview:self.serialLabel];
    [self addSubview:self.titleLabel];
    [self addSubview:self.upwardLabel];
    [self addSubview:self.downLabel];
    [self addSubview:self.dateLabel];
}

- (UILabel *)serialLabel
{
    if (!_serialLabel) {
        _serialLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _serialLabel.text = @"#";
        _serialLabel.textColor = [UIColor colorWithHexColorString:@"666666"];
        _serialLabel.textAlignment = NSTextAlignmentLeft;
        _serialLabel.font = [UIFont fontWithName:@"Arial" fontSize:12];
    }
    return _serialLabel;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.text = @"TITLE";
        _titleLabel.textColor = [UIColor colorWithHexColorString:@"666666"];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont fontWithName:@"Arial" fontSize:12];
    }
    return _titleLabel;
}

- (UILabel *)upwardLabel
{
    if (!_upwardLabel) {
        _upwardLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _upwardLabel.text = @"UPWARD";
        _upwardLabel.textColor = [UIColor colorWithHexColorString:@"666666"];
        _upwardLabel.textAlignment = NSTextAlignmentLeft;
        _upwardLabel.font = [UIFont fontWithName:@"Arial" fontSize:12];
    }
    return _upwardLabel;
}

- (UILabel *)downLabel
{
    if (!_downLabel) {
        _downLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _downLabel.text = @"DOWNWARD";
        _downLabel.textColor = [UIColor colorWithHexColorString:@"666666"];
        _downLabel.textAlignment = NSTextAlignmentLeft;
        _downLabel.font = [UIFont fontWithName:@"Arial" fontSize:12];
    }
    return _downLabel;
}

- (UILabel *)dateLabel
{
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _dateLabel.text = @"DATE";
        _dateLabel.textColor = [UIColor colorWithHexColorString:@"666666"];
        _dateLabel.textAlignment = NSTextAlignmentCenter;
        _dateLabel.font = [UIFont fontWithName:@"Arial" fontSize:12];
    }
    return _dateLabel;
}


@end
