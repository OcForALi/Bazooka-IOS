//
//  SendPopView.m
//  Test
//
//  Created by Mac on 2017/10/13.
//  Copyright © 2017年 QiXing. All rights reserved.
//

#import "SendPopView.h"

@interface SendPopView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *okBtn;
@property (nonatomic, strong) UILabel *progressLabel;
@property (nonatomic, strong) UIProgressView *progressView;

@end

@implementation SendPopView

-(void)layoutSubviews
{
    [super layoutSubviews];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(50));
        make.left.equalTo(self.mas_left).offset(30);
        make.right.equalTo(self.mas_right).offset(-30);
        [self.titleLabel sizeToFit];
    }];
    
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(20);
        make.right.equalTo(self.mas_right).offset(-20);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(20);
        make.height.equalTo(@(10));
    }];
    
    [self.progressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.progressView.mas_left).offset(0);
        make.top.equalTo(self.progressView.mas_bottom).offset(15);
        [self.progressLabel sizeToFit];
    }];
    
    [self.okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-25);
        make.centerX.equalTo(self);
        make.width.equalTo(@(94));
        make.height.equalTo(@(36));
    }];
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self cn_startai_initContentView];
    }
    return self;
}

- (void)cn_startai_initContentView
{
    [self addSubview:self.titleLabel];
    [self addSubview:self.progressView];
    [self addSubview:self.progressLabel];
    [self addSubview:self.okBtn];
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont fontWithName:@"Source Sans Pro" size:24];
        _titleLabel.textColor = [UIColor colorWithHexColorString:@"333333"];
        _titleLabel.text = NSLocalizedString(@"sendSeqTip", nil);
        _titleLabel.numberOfLines = 0;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UILabel *)progressLabel
{
    if (!_progressLabel) {
        _progressLabel = [[UILabel alloc] init];
        _progressLabel.font = [UIFont fontWithName:@"Source Sans Pro" size:24];
        _progressLabel.textColor = [UIColor colorWithHexColorString:@"333333"];
    }
    return _progressLabel;
}

- (UIProgressView *)progressView
{
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        _progressView.progressTintColor = [UIColor colorWithHexColorString:@"00ffff"];
        _progressView.trackTintColor = [UIColor colorWithHexColorString:@"f2f2f2"];
    }
    return _progressView;
}

- (UIButton *)okBtn
{
    if (!_okBtn) {
        _okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_okBtn setBackgroundImage:[UIImage imageNamed:@"blackBtnBack"] forState:UIControlStateNormal];
        [_okBtn setTitle:@"Cancel" forState:UIControlStateNormal];
        [_okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_okBtn addTarget:self action:@selector(okAction) forControlEvents:UIControlEventTouchUpInside ];
    }
    return _okBtn;
}

#pragma mark event

- (void)okAction
{
    if (self.sendSucessdHandler) {
        self.sendSucessdHandler();
    }
}

- (void)sendSucessNum:(NSInteger)sendNum Total:(NSInteger)total
{
    self.progressView.progress = sendNum/(total*1.0);
    self.progressLabel.text = [NSString stringWithFormat:@"%ld%@",(NSInteger)(self.progressView.progress *100),@"%"];

    if (sendNum == total) {
        if (self.sendSucessdHandler) {
            self.sendSucessdHandler();
        }
    }
}

@end
