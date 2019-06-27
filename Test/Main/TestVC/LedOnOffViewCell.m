//
//  LedOnOffViewCell.m
//  Test
//
//  Created by Mac on 2017/12/13.
//  Copyright © 2017年 QiXing. All rights reserved.
//

#import "LedOnOffViewCell.h"

@interface LedOnOffViewCell ()

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UIButton *sendBtn;

@end
@implementation LedOnOffViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self cn_startai_initContentView];
    }
    return self;
}

- (void)cn_startai_initContentView
{
    [self addSubview:self.nameLabel];
    [self addSubview:self.commandTextfiled];
    [self addSubview:self.repeatTextfiled];
    [self addSubview:self.intervalTimeTextfiled];
    [self addSubview:self.sendBtn];
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 10, 200, 30)];
        _nameLabel.text = @"led开关";
    }
    return _nameLabel;
}

- (UITextField *)commandTextfiled
{
    if (!_commandTextfiled) {
        _commandTextfiled = [[UITextField alloc] initWithFrame:CGRectMake(50, self.nameLabel.bottom+20, 200, 30)];
        _commandTextfiled.placeholder = @"0x54";
        _commandTextfiled.text = @"0x54";
    }
    return _commandTextfiled;
}

- (UITextField *)repeatTextfiled
{
    if (!_repeatTextfiled) {
        _repeatTextfiled = [[UITextField alloc] initWithFrame:CGRectMake(50, self.commandTextfiled.bottom+20, 200, 30)];
        _repeatTextfiled.placeholder = @"此命令发送重复次数";
        _repeatTextfiled.text = @"";
    }
    return _repeatTextfiled;
}

- (UITextField *)intervalTimeTextfiled
{
    if (!_intervalTimeTextfiled) {
        _intervalTimeTextfiled = [[UITextField alloc] initWithFrame:CGRectMake(50, self.repeatTextfiled.bottom+20, 200, 30)];
        _intervalTimeTextfiled.placeholder = @"发送命令间隔时间";
        _intervalTimeTextfiled.text = @"";
    }
    return _intervalTimeTextfiled;
}

- (UIButton *)sendBtn
{
    if (!_sendBtn) {
        _sendBtn = [[UIButton alloc] initWithFrame:CGRectMake(50, self.intervalTimeTextfiled.bottom+20, 50, 30)];
        _sendBtn.layer.cornerRadius = 10;
        _sendBtn.layer.borderColor = [UIColor blueColor].CGColor;
        _sendBtn.layer.borderWidth = 1;
        [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
        [_sendBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_sendBtn addTarget:self action:@selector(sendAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendBtn;
}

- (void)sendAction
{
    if (self.commandTextfiled.text.length &&
        self.repeatTextfiled.text.length &&
        self.repeatTextfiled.text.length) {
        if (self.tapSendHandler) {
            self.tapSendHandler();
        }
    }
}

@end
