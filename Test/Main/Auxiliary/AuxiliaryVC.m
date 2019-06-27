//
//  AuxiliaryVC.m
//  BluetoothBox
//
//  Created by Mac on 2017/9/18.
//  Copyright © 2017年 Actions. All rights reserved.
//

#import "AuxiliaryVC.h"
#import "BoxPlayerControl.h"
#import "BoxMuteView.h"
#import "BoxPlayerBackGround.h"
#import "PopView.h"
@interface AuxiliaryVC ()<BoxPlayControlProctol, AuxDelegate>
{
    AppDelegate *appDelegate;
}
@property (nonatomic, strong) BoxPlayerControl *playControl;
@property (nonatomic, strong) BoxPlayerBackGround *playBack;
@property (nonatomic, strong) BoxMuteView *labelView;
@property (nonatomic, strong) PopView *pop;
@end

@implementation AuxiliaryVC

- (void)cn_startai_registerAppDelegate:(AppDelegate *)delegate mode:(UInt32)mode
{
    appDelegate = delegate;
    [appDelegate.globalManager setMode:mode];
    appDelegate.auxManager = [appDelegate.mMediaManager getAuxManager:self];
}


- (instancetype)init
{
    if (self = [super init]) {
        self.logo = [UIImage imageNamed:@"music"];
        [self cn_startai_initContentView];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.backGroundView.image = [UIImage imageNamed:@"AuxiliaryBackGround"];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (appDelegate.isConnected ) {
        if ((round)(self.playControl.volumeValue * appDelegate.maxVoice) != appDelegate.currentVoice) {
            self.playControl.setVoice = appDelegate.currentVoice / (float)appDelegate.maxVoice;
        }
    }
}

- (void)cn_startai_initContentView
{
    [self.view addSubview:self.playBack];
    CGFloat hei = IS_IPHONE_5_OR_LESS ? 280 :280;
    self.playBack.scrollView.contentSize = CGSizeMake(SCREEN_WITDH-50, hei);
    [self.playBack.scrollView addSubview:self.playControl];
    [self.playBack.scrollView addSubview:self.labelView];
    [self.view addSubview:self.pop];
    self.playBack.hidePage = true;
    self.playControl.hideLastNext = true;
}


- (BoxPlayerBackGround *)playBack
{
    CGFloat hei = IS_IPHONE_5_OR_LESS ? 280 :280;
    if (!_playBack) {
        _playBack = [[BoxPlayerBackGround alloc] initWithFrame:CGRectMake(25, SCREEN_HEIGHT-hei-30-IPHONEBottom, SCREEN_WITDH-50, hei)];
        _playBack.scrollView.scrollEnabled = NO;
    }
    return _playBack;
}

- (BoxMuteView *)labelView
{
    if (!_labelView) {
        _labelView = [[BoxMuteView alloc] initWithFrame:CGRectMake(20, 50/420.0*self.playBack.height, self.playBack.width - 40, 100)];
        _labelView.isPlay = true;
    }
    return _labelView;
}

- (BoxPlayerControl *)playControl
{
    if (!(_playControl)) {
        _playControl = [[BoxPlayerControl alloc] initWithFrame:CGRectMake(0, self.labelView.bottom, self.playBack.width, self.playBack.height - self.labelView.bottom)];
        _playControl.delegate = self;
        _playControl.playImg = [UIImage imageNamed:@"play"];
    }
    return _playControl;
}

- (PopView *)pop
{
    CGFloat hei = IS_IPHONE_5_OR_LESS ? 250 : 335;
    @weakify(self);
    if (!_pop) {
        _pop = [[PopView alloc] initWithFrame:CGRectMake(20, (SCREEN_HEIGHT-hei)/2.0, SCREEN_WITDH-40, hei)];
        _pop.backgroundColor = [UIColor whiteColor];
        _pop.alpha = 0.7;
        _pop.text = NSLocalizedString(@"PartybarNotPair", nil);
        _pop.leftText = @"Cancel";
        _pop.rightText = @"Setting";
        _pop.hidden = true;
        _pop.leftHandler = ^{
            weak_self.pop.hidden = true;
        };
        _pop.rightHandler = ^{
            weak_self.pop.hidden = true;
            if (weak_self.GotoConnectPeripheral) {
                weak_self.GotoConnectPeripheral();
            }
            [weak_self.navigationController popViewControllerAnimated:false];
        };
    }
    return _pop;
}

#pragma mark BoxPlayControlProctol

- (void)cn_startai_playSong
{
    if (!appDelegate.isConnected) {
        self.pop.hidden = false;
        return;
    }
    [appDelegate.auxManager mute];
}

- (void)cn_startai_playLastSong
{
    
}

- (void)cn_startai_playNextSong
{
    
}

- (void)cn_startai_voiceChanged:(CGFloat)value
{
//    [appDelegate.globalManager setVolume:(UInt32)(value *appDelegate.maxVoice)];
    NSLog(@"------------------%f",value);
}

- (void)cn_startai_voiceChangedEnd:(CGFloat)value
{
//    appDelegate.player.player.volume = value;
    [self.volumeSlider setValue:value];
    if (appDelegate.isConnected) {
        UInt32 voice = (round)(value *appDelegate.maxVoice);
        self.playControl.setVoice= voice / (float)appDelegate.maxVoice;
        [appDelegate.globalManager setVolume:voice];
    }
}

- (void)setvolumeChanged:(CGFloat)voice
{
    if (!appDelegate.isConnected) {
        self.playControl.setVoice = voice;
        return;
    }
    if ((round)(self.playControl.volumeValue * appDelegate.maxVoice) != voice) {
        self.playControl.setVoice = voice / (float)appDelegate.maxVoice;
    }
}

- (void)leftAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightAction
{

}

#pragma mark -AuxDelegate
#pragma mark - 设备当前的模式
- (void)managerReady:(UInt32)mode
{
    appDelegate.model = mode;
}

#pragma mark Linein当前状态
- (void)stateChanged:(UInt32)state
{
    if (state == 2) {
        self.playControl.playImg = [UIImage imageNamed:@"play"];
        self.labelView.isPlay = true;
    }else{
        self.labelView.isPlay = false;
        self.playControl.playImg = [UIImage imageNamed:@"noVoice"];
//        [appDelegate.globalManager setVolume:(UInt32)(self.playControl.volumeValue *appDelegate.maxVoice)];

    }
}

- (void)setIsConnected:(BOOL)isConnected
{
    _isConnected = isConnected;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
