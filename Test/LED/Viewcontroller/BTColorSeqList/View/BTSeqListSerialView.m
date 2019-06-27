//
//  BTSeqListSerialView.m
//  BTMate
//
//  Created by Mac on 2017/8/18.
//  Copyright © 2017年 QiXing. All rights reserved.
//

#import "BTSeqListSerialView.h"

static const CGFloat kLeftHorzontal = 30;
static const CGFloat kRightHorzontal = 47;

@interface BTSeqListSerialView ()

@property (nonatomic, strong) UILabel *serialLabel;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong)UIButton *copyBtn;
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, assign) NSInteger serial;
@end

@implementation BTSeqListSerialView

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.serialLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(55);
        make.top.equalTo(self.mas_top).offset(16);
        [self.serialLabel sizeToFit];
    }];
    
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-kRightHorzontal);
        make.centerY.equalTo(self.serialLabel);
        make.width.height.equalTo(@(34*1.5));
        
    }];
    
    [self.copyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.deleteBtn.mas_left).offset(-23);
        make.centerY.equalTo(self.serialLabel);
        make.width.equalTo(@(22.5*1.5));
        make.height.equalTo(@(12.5*1.5));
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(36);
        make.top.equalTo(self.copyBtn.mas_bottom).offset(8);
        make.width.equalTo(@(SCREEN_WITDH - 2*36));
        make.height.equalTo(@(1));
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
    [self addSubview:self.line];
    [self addSubview:self.copyBtn];
    [self addSubview:self.deleteBtn];
}

- (UILabel *)serialLabel
{
    if (!_serialLabel) {
        _serialLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _serialLabel.textColor = [UIColor blackColor];
        _serialLabel.font = [UIFont fontWithName:@"Arial" size:24];
        _serialLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _serialLabel;
}

- (UIView *)line
{
    if (!_line) {
        _line = [[UIView alloc] initWithFrame:CGRectZero];
        _line.backgroundColor = [UIColor blackColor];
    }
    return _line;
}

- (UIButton *)copyBtn
{
    if (!_copyBtn) {
        _copyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_copyBtn setBackgroundImage:[UIImage imageNamed:@"copy"] forState:UIControlStateNormal];
        [_copyBtn addTarget:self action:@selector(copyColor) forControlEvents:UIControlEventTouchUpInside];
    }
    return _copyBtn;
}

- (UIButton *)deleteBtn
{
    if (!_deleteBtn) {
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteBtn setBackgroundImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
        [_deleteBtn addTarget:self action:@selector(cn_startai_deleteColor) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteBtn;
}

- (void)copyColor
{
    if (self.copyHandler) {
        self.copyHandler(self.serial);
    }
}

- (void)cn_startai_deleteColor
{
    if (self.deleteHandler) {
        self.deleteHandler(self.serial);
    }
}

- (void)setValueWithSerial:(NSInteger)serial
{
    _serial = serial;
    self.serialLabel.text = [NSString stringWithFormat:@"00%ld",serial];
   
    [self layoutIfNeeded];
}

- (void)setHideDelte:(BOOL)hideDelte
{
    _hideDelte = hideDelte;
    if (hideDelte) {
        self.deleteBtn.hidden = true;
    }else
        self.deleteBtn.hidden = false;
}

@end
