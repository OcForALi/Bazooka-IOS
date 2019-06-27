//
//  USBVC.m
//  BluetoothBox
//
//  Created by Mac on 2017/9/18.
//  Copyright © 2017年 Actions. All rights reserved.
//

#import "USBVC.h"
#import "BoxPlayerControl.h"
#import "BoxPlayLabelView.h"
#import "BoxPlayerBackGround.h"
#import "BoxSongIntroduceView.h"
#import "AppDelegate.h"
#import "PopView.h"

@interface USBVC ()<BoxPlayControlProctol,USBSpeakerDelegate,MusicDelegate>
{
    AppDelegate *appDelegate;
    BOOL state;
    uint32_t songNum;           //获取usb共有多少首歌曲
    NSInteger songIndex;
    NSInteger small;
    NSInteger queryIndex;
    MBProgressHUD *hud;
}
@property (nonatomic, strong) BoxPlayerControl *playControl;
@property (nonatomic, strong) BoxPlayerBackGround *playBack;
@property (nonatomic, strong) BoxPlayLabelView *labelView;
@property (nonatomic, strong) BoxSongIntroduceView *introduceView;
@property (nonatomic, strong) NSMutableArray *cardList; //U盘或者卡歌曲播放
@property (nonatomic, strong) PopView *pop;

@end

@implementation USBVC


- (void)cn_startai_registerAppDelegate:(AppDelegate *)delegate mode:(UInt32)mode
{
    appDelegate = delegate;
    [appDelegate.globalManager setMode:mode];
    appDelegate.musicManager = [appDelegate.mMediaManager getMusicManager:self];
    if (appDelegate.isConnected && appDelegate.canUseUSB) {
        [self performSelector:@selector(cn_startai_pauseSong) withObject:nil afterDelay:2];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.backGroundView.image = [UIImage imageNamed:@"BootBackGround"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (hud) {
        [hud hideAnimated:true];
        [hud removeFromSuperViewOnHide];
    }
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

- (instancetype)init
{
    if (self = [super init]) {
        self.logo =  [UIImage imageNamed:@"USB"];
        state = false;
        [self cn_startai_initContentView];
    }
    return self;
}

- (void)cn_startai_initContentView
{
    CGFloat hei = IS_IPHONE_5_OR_LESS ? 280 :280;
    [self.view addSubview:self.playBack];
    self.playBack.scrollView.contentSize = CGSizeMake((SCREEN_WITDH-50)*2, hei);
    [self.playBack.scrollView addSubview:self.playControl];
    [self.playBack.scrollView addSubview:self.labelView];
    [self.playBack.scrollView addSubview:self.introduceView];
    [self.view addSubview:self.pop];
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

- (BoxPlayLabelView *)labelView
{
    if (!_labelView) {
        _labelView = [[BoxPlayLabelView alloc] initWithFrame:CGRectMake(20, 50/420.0*self.playBack.height, self.playBack.width - 40, 100)];
        _labelView.layer.cornerRadius = 5;
        _labelView.layer.borderColor = [UIColor clearColor].CGColor;
        _labelView.layer.borderWidth = 1;
    }
    return _labelView;
}

- (BoxPlayerControl *)playControl
{
    if (!(_playControl)) {
        _playControl = [[BoxPlayerControl alloc] initWithFrame:CGRectMake(0, self.labelView.bottom, self.playBack.width, self.playBack.height - self.labelView.bottom)];
        _playControl.delegate = self;
    }
    return _playControl;
}

- (BoxSongIntroduceView *)introduceView
{
    @weakify(appDelegate);
    if (!_introduceView) {
        _introduceView = [[BoxSongIntroduceView alloc] initWithFrame:CGRectMake(self.playBack.width, 0, self.playBack.width, self.playBack.height)];
        _introduceView.tapSelectedHandler = ^(NSInteger row) {
            [appDelegate.musicManager select:(UInt32)row+1];
        };
    }
    return _introduceView;
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

- (void)cn_startai_pauseSong
{
    if (!appDelegate.isConnected) {
        self.pop.hidden = false;
        return;
    }else if(!appDelegate.canUseUSB){
        [self notFoundUSB];
        return;
    }
    state = true;
    if (state) {
//        [appDelegate.musicManager pause];
        self.playControl.playImg = [UIImage imageNamed:@"pause"];
    }else{
//        [appDelegate.musicManager play];
        self.playControl.playImg = [UIImage imageNamed:@"play"];
    }
}

- (void)cn_startai_playSong
{
    if (!appDelegate.isConnected) {
        self.pop.hidden = false;
        return;
    }else if(!appDelegate.canUseUSB){
        [self notFoundUSB];
        return;
    }
    state = !state;
    if (state) {
        [appDelegate.musicManager pause];
        self.playControl.playImg = [UIImage imageNamed:@"pause"];
    }else{
        [appDelegate.musicManager play];
        self.playControl.playImg = [UIImage imageNamed:@"play"];
    }
}

- (void)cn_startai_playLastSong
{
    if (!appDelegate.isConnected) {
        self.pop.hidden = false;
        return;
    }else if(!appDelegate.canUseUSB){
        [self notFoundUSB];
        return;
    }
    state = true;
    self.playControl.playImg = [UIImage imageNamed:@"pause"];
    [appDelegate.musicManager previous];
}

- (void)cn_startai_playNextSong
{
    if (!appDelegate.isConnected) {
        self.pop.hidden = false;
        return;
    }else if(!appDelegate.canUseUSB){
        [self notFoundUSB];
        return;
    }
    
    state = true;
    self.playControl.playImg = [UIImage imageNamed:@"pause"];
    [appDelegate.musicManager next];
    
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - USBSpeakerDelegate

#pragma mark 音箱当前的模式
-(void)managerReady:(UInt32)mode
{
    appDelegate.model = mode;
    songNum = [appDelegate.musicManager getPListSize];
    if ( songNum && self.cardList.count != songNum ) {
        self.cardList = [NSMutableArray array];
        if (songNum < 6) {
            queryIndex = 1;
            [appDelegate.musicManager getPListFrom:1 withCount:songNum];
            [appDelegate.musicManager getCurrentEntry];
        }else{
            queryIndex = 1;
            small = songNum %5;
            [appDelegate.musicManager getPListFrom:1 withCount:5];
            [appDelegate.musicManager getCurrentEntry];
        }
        [self loadingMusic];
    }
}

#pragma mark 音箱返回指定歌曲的歌词信息
-(void)lyricReady:(UInt32)index lyric:(NSData*)lyric
{
    songIndex = index;
    NSString *lyricText = [[NSString alloc] initWithData:lyric encoding:NSUTF8StringEncoding];
    
}

#pragma mark 音箱播放音乐条目切换

-(void)musicEntryChanged:(MusicEntry*) entry
{
    self.labelView.duration = [appDelegate.musicManager getDuration];
    self.labelView.cardMusic = entry;
    self.introduceView.songInteger = entry.index - 1;
    NSLog(@"-----------------%@", entry.name);
}

#pragma mark 音箱当前循环模式变化
-(void)loopModeChanged:(UInt32) mode
{
    
}

#pragma mark  音箱播放状态变化
-(void)stateChanged:(UInt32) state
{
    if(state==2){
        self.playControl.playImg = [UIImage imageNamed:@"pause"];
    }
    else{
        self.playControl.playImg = [UIImage imageNamed:@"play"];
    }
}

#pragma mark 音箱播放列表变化，应用需重新同步播放列表。
-(void)contentChanged
{

}
#pragma mark 音箱发送播放列表。
-(void)pListEntryReady:(NSMutableArray*)entryList
{
    if (self.cardList.count<songNum+1) {
        [self.cardList addObjectsFromArray:entryList];
    }
    
    hud.label.text = [NSString stringWithFormat:@"%@ %ld/%ld",NSLocalizedString(@"reloadplaylist", nil),self.cardList.count,(NSInteger)songNum];
    if (self.cardList.count == songNum) {
        self.introduceView.cardList = self.cardList;
        [hud hideAnimated:true];
        [hud removeFromSuperViewOnHide];
    }
    if ((queryIndex+1)*5<=songNum) {
        [appDelegate.musicManager getPListFrom:(UInt32)(queryIndex*5)+1 withCount:5];
        [appDelegate.musicManager getCurrentEntry];
        queryIndex++;
    }else if ((queryIndex+1)*5 >= songNum && queryIndex*5 < songNum){
        if (small) {
            [appDelegate.musicManager getPListFrom:(UInt32)(queryIndex*5)+1 withCount:(UInt32)small];
            [appDelegate.musicManager getCurrentEntry];
        }
        queryIndex ++;
    }
}

- (void)setIsConnected:(BOOL)isConnected
{
    _isConnected = isConnected;
}

- (void)setCanUseUSB:(BOOL)canUseUSB
{
    _canUseUSB = canUseUSB;
}

- (void)notFoundUSB
{
    @weakify(self);
    UIAlertController *con = [UIAlertController alertControllerWithTitle:@"" message:NSLocalizedString(@"USBNotIN", nil) preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weak_self dismissViewControllerAnimated:true completion:nil];
    }];
    [con addAction:ok];
    [self presentViewController:con animated:true completion:nil];
}

- (void)loadingMusic
{
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    hud.centerY = self.signView.bottom;
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.userInteractionEnabled = false;
    hud.label.text = NSLocalizedString(@"reloadplaylist", nil);
    hud.label.textColor = [UIColor whiteColor];
    hud.label.numberOfLines = 0;
    hud.userInteractionEnabled = false;
    [self.view addSubview:hud];
    [hud showAnimated:true];
}

@end
