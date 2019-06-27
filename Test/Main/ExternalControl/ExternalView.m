//
//  ExternalView.m
//  Test
//
//  Created by Mac on 2017/11/3.
//  Copyright © 2017年 QiXing. All rights reserved.
//

#import "ExternalView.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>



@interface ExternalView ()

//@property (nonatomic, strong) UIButton *nameBtn;
@property (nonatomic, strong) UIButton *switchBtn;
@property (nonatomic, strong) UIImageView *onOffView;
@property (nonatomic, strong) UIImageView *switchView;
@property (nonatomic, strong) AVAudioPlayer *player;
@end

@implementation ExternalView

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat off = (SCREEN_WITDH - 80 -80 -90)/4.0;

    [self.nameBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(off));
        make.centerY.equalTo(self);
        make.width.equalTo(@(90));
        make.height.equalTo(@(30));
        
    }];
    
    [self.switchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameBtn.mas_right).offset(off-5);
        make.centerY.equalTo(self).offset(-6);
        make.width.equalTo(@(80));
        make.height.equalTo(@(80));
    }];
    
    [self.onOffView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.switchBtn.mas_right).offset(off+10);
        make.centerY.equalTo(self);
        make.width.equalTo(@(41));
        make.height.equalTo(@(50));
    }];
    
    [self.switchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameBtn.mas_right).offset(off);
        make.centerY.equalTo(self);
        make.width.equalTo(@(80));
        make.height.equalTo(@(80));
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
    [self addSubview:self.nameBtn];
    [self addSubview:self.onOffView];
    [self addSubview:self.switchView];
    [self addSubview:self.switchBtn];
}

- (UIButton *)nameBtn
{
    if (!_nameBtn) {
        _nameBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nameBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_nameBtn addTarget:self action:@selector(changeName) forControlEvents:UIControlEventTouchUpInside];
        [_nameBtn setTitle:@"Name" forState:UIControlStateNormal];
    }
    return _nameBtn;
}


- (UIButton *)switchBtn
{
    if (!_switchBtn) {
        _switchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_switchBtn setBackgroundColor:[UIColor clearColor]];
        [_switchBtn addTarget:self action:@selector(swichImg:) forControlEvents:UIControlEventTouchUpInside];
        _switchBtn.selected = false;
    }
    return _switchBtn;
}

- (UIImageView *)onOffView
{
    if (!_onOffView) {
        _onOffView = [[UIImageView alloc] init];
        _onOffView.image = [UIImage imageNamed:@"OFFICON"];

    }
    return _onOffView;
}


- (UIImageView *)switchView
{
    if (!_switchView) {
        _switchView = [[UIImageView alloc] init];
        _switchView.image = [UIImage imageNamed:@"SWITCHSHADOWOFF"];
    }
    return _switchView;
}

-(AVAudioPlayer *)player
{
    if (!_player) {
       
    }
    return _player;
}

- (void)setSerial:(NSInteger)serial
{
    _serial = serial;
    NSString *img = [NSString stringWithFormat:@"SW%ld",serial];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:img]) {
        [self.nameBtn setTitle:[[NSUserDefaults standardUserDefaults] objectForKey:img]
                    forState:UIControlStateNormal];
    }
    [self.switchBtn setTitle:[NSString stringWithFormat:@"%ld",serial] forState:UIControlStateNormal];
    [self.switchBtn setTitleColor:[UIColor colorWithRed:139/255.0 green:139/255.0 blue:140/255.0 alpha:1]
                     forState:UIControlStateNormal ];
    self.switchBtn.titleLabel.font = [UIFont boldSystemFontOfSize:19];
}

- (void)setOnOffState:(BOOL)onOffState
{
    _onOffState = onOffState;
    if (onOffState) {
        self.onOffView.image = [UIImage imageNamed:@"ONICON"];
        self.switchView.image = [UIImage imageNamed:@"SWITCHSHADOWON"];
    }else{
        self.onOffView.image = [UIImage imageNamed:@"OFFICON"];
        self.switchView.image = [UIImage imageNamed:@"SWITCHSHADOWOFF"];
    }
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    [self.nameBtn setTitle:title forState:UIControlStateNormal];
}



- (void)changeName
{
    if (self.changeNameHandler) {
        self.changeNameHandler(_serial);
    }
}

- (void)swichImg:(UIButton *)btn
{

//    _player = [[AVAudioPlayer  alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:@"switchclick" ofType:@"mp3"]] error:nil];
//    [_player prepareToPlay];
//    [self.player play];

    self.switchBtn.selected = !self.switchBtn.selected;
    if (self.switchBtn.selected) {
        self.onOffView.image = [UIImage imageNamed:@"ONICON"];
        self.switchView.image = [UIImage imageNamed:@"SWITCHSHADOWON"];

    }else{
        self.onOffView.image = [UIImage imageNamed:@"OFFICON"];
        self.switchView.image = [UIImage imageNamed:@"SWITCHSHADOWOFF"];
    }
    
    if (self.cliekDeviceHandler) {
        self.cliekDeviceHandler(self.switchBtn.selected);
    }
    
}


@end
