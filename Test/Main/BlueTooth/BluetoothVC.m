//
//  BluetoothVC.m
//  BluetoothBox
//
//  Created by Mac on 2017/9/15.
//  Copyright © 2017年 Actions. All rights reserved.
//

#import "BluetoothVC.h"
#import "BoxPlayerControl.h"
#import "BoxPlayLabelView.h"
#import "BoxPlayerBackGround.h"
#import "BoxSongIntroduceView.h"
#import "MusicEntry.h"
#import "LoaclMusic.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "MusicModel.h"
@interface BluetoothVC ()<UIScrollViewDelegate,MusicDelegate,BoxPlayControlProctol,AVAudioPlayerDelegate,CAAnimationDelegate>

{
    AppDelegate *appDelegate;
//    BOOL playState;         //播放状态
    NSInteger songIndex;     //歌曲的下标
    BOOL havePause;
}

@property (nonatomic, strong) BoxPlayerControl *playControl;
@property (nonatomic, strong) BoxPlayerBackGround *playBack;
@property (nonatomic, strong) BoxPlayLabelView *labelView;
@property (nonatomic, strong) BoxSongIntroduceView *introduceView;
//@property (nonatomic, strong) LoaclMusic *music;
@end


@implementation BluetoothVC

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


-(void)cn_startai_registerAppDelegate:(AppDelegate*)delegate mode:(UInt32)mode
{
    appDelegate = delegate;
    [appDelegate.globalManager setMode:mode];
    
//    if (!appDelegate.player) {
//        appDelegate.player = [[LoaclMusic alloc] init];
//    }
    
//    @weakify(self);
//    appDelegate.player.musicHandlerEntity = ^(LocalMusicEntry *music) {
//        weak_self.labelView.musicEntity = music;
//    };
//
//    appDelegate.player.musicStateChangeHandler = ^{
//        [weak_self cn_startai_playStateChanged];
//    };
//
//    if (appDelegate.player.songArr == 0) {
//        [appDelegate.player getData];
//    }
//    if (!self.introduceView.musicList.count) {
//        self.introduceView.musicList = appDelegate.player.songArr;
//    }

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.backGroundView.image = [UIImage imageNamed:@"BluetoothBackGround"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ReadyPlay:) name:@"ReadyPlay" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(next:) name:@"musicNext" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(start:) name:@"musicStart" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(suspended:) name:@"musicSuspended" object:nil];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerControl:) name:PlayControl object:nil];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [appDelegate.musicModel getData];
    
    if (appDelegate.musicModel.songArr.count != 0) {
        MusicMessage *musicMessage = appDelegate.musicModel.songArr[appDelegate.musicModel.songIndex];
        self.labelView.musicMessage = musicMessage;
    }
    
    if (appDelegate.isConnected ) {
        NSLog(@"%f",appDelegate.currentVoice);
        if ((int)(self.playControl.volumeValue * appDelegate.maxVoice) != appDelegate.currentVoice) {
            self.playControl.setVoice = appDelegate.currentVoice/appDelegate.maxVoice;
        }
    }
    
    self.introduceView.musicList = appDelegate.musicModel.songArr;
    
    self.introduceView.songInteger = appDelegate.musicModel.songIndex;
    
    if (appDelegate.musicModel.isPlay == YES){
        self.playControl.playImg = [UIImage imageNamed:@"pause"];
    }else{
       self.playControl.playImg = [UIImage imageNamed:@"play"];
    }
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    if (havePause && appDelegate.player.player.rate != 1) {
//        havePause = false;
//        [appDelegate.player cn_startai_playSong];
//    }
    
//    if (appDelegate.player.player.rate == 1) {
//        self.playControl.playImg = [UIImage imageNamed:@"pause"];
//    }else{
//        self.playControl.playImg = [UIImage imageNamed:@"play"];
//    }
    
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
//    [appDelegate.globalManager setVolume:(UInt32)(appDelegate.player.player.volume*appDelegate.maxVoice)];
}

- (instancetype)init
{
    if (self = [super init]) {
        songIndex = 0;
        [self cn_startai_initContentView];
        self.logo = [UIImage imageNamed:@"bluetoothIcon"];
    }
    return self;
}


- (void)cn_startai_playStateChanged
{
//    if (appDelegate.player.player.rate == 1) {
//        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
//        self.playControl.playImg = [UIImage imageNamed:@"pause"];
//        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
//
//    }else{
//        [[AVAudioSession sharedInstance] setActive:true error:nil];
//        self.playControl.playImg = [UIImage imageNamed:@"play"];
//        [[AVAudioSession sharedInstance] setActive:true error:nil];
//    }
}

- (void)cn_startai_pauseSong
{
//    [appDelegate.player cn_startai_pauseSong];
    havePause = true;
}

- (void)cn_startai_initContentView
{
    CGFloat hei = IS_IPHONE_5_OR_LESS ? 280 :280;
    [self.view addSubview:self.playBack];
    self.playBack.scrollView.contentSize = CGSizeMake((SCREEN_WITDH-50)*2, hei);
    [self.playBack.scrollView addSubview:self.playControl];
    [self.playBack.scrollView addSubview:self.labelView];
    [self.playBack.scrollView addSubview:self.introduceView];
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
    __weak typeof(self) weakSelf = self;
    if (!_introduceView) {
        _introduceView = [[BoxSongIntroduceView alloc] initWithFrame:CGRectMake(self.playBack.width, 0, self.playBack.width, self.playBack.height)];
        _introduceView.isBluetooth = true;
        _introduceView.tapSelectedHandler = ^(NSInteger row) {
            NSLog(@"当前%ld",(long)row);
            
            __strong typeof(weakSelf) strongSelf = weakSelf;
            
            strongSelf->appDelegate.musicModel.songIndex = row - 1;
            
            [strongSelf->appDelegate.musicModel musicNext];
            
//            [strongSelf->appDelegate.player cn_startai_playAppointSong:row];
//            [appDelegate.player cn_startai_playAppointSong:row];
        };
    }
    return _introduceView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark BoxPlayControlProctol

- (void)cn_startai_playSong
{
    
    MPMediaQuery *music = [[MPMediaQuery alloc] init];
    MPMediaPropertyPredicate *predicate = [MPMediaPropertyPredicate predicateWithValue:[NSNumber numberWithInteger:MPMediaTypeMusic] forProperty:MPMediaItemPropertyMediaType];
    [music addFilterPredicate:predicate];
    NSArray *items = [music items];
    
    if (items.count > 0) {
        
        if (appDelegate.musicModel.isPlay == NO) {
            
            [appDelegate.musicModel play];
            self.playControl.playImg = [UIImage imageNamed:@"pause"];
            
        }else{
            
            [appDelegate.musicModel pause];
            self.playControl.playImg = [UIImage imageNamed:@"play"];
            
        }
        
    }else{
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"Song Library No Songs" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        // 弹出对话框
        [self presentViewController:alert animated:true completion:nil];
        
    }
    
}

- (void)cn_startai_playLastSong
{
//    playState = true;
//    self.playControl.playImg = [UIImage imageNamed:@"pause"];
//    [appDelegate.player cn_startai_playLastSong];
    
    [appDelegate.musicModel musicLast];
    
    self.labelView.musicMessage = appDelegate.musicModel.songArr[appDelegate.musicModel.songIndex];
    
    self.introduceView.songInteger = appDelegate.musicModel.songIndex;
    
}

- (void)cn_startai_playNextSong
{
    
    [appDelegate.musicModel musicNext];
    
    self.labelView.musicMessage = appDelegate.musicModel.songArr[appDelegate.musicModel.songIndex];
    
    self.introduceView.songInteger = appDelegate.musicModel.songIndex;
    
//    playState = true;
//    self.playControl.playImg = [UIImage imageNamed:@"pause"];
//    [appDelegate.player cn_startai_playNextSong];
}

- (void)cn_startai_voiceChanged:(CGFloat)value
{
//    [appDelegate.globalManager setVolume:(UInt32)(value *appDelegate.maxVoice)];
    NSLog(@"------------------%f",value);
}

- (void)cn_startai_voiceChangedEnd:(CGFloat)value
{
//    appDelegate.player.player.volume = value;
    if (appDelegate.isConnected) {
        UInt32 voice = (round)(value *appDelegate.maxVoice);
        [self.volumeSlider setValue:voice/(float)appDelegate.maxVoice];
        self.playControl.setVoice= voice / (float)appDelegate.maxVoice;
//        [appDelegate.globalManager setVolume:voice];
    }else{
        [self.volumeSlider setValue:value];
    }
    NSLog(@"=======滑动");
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


- (void)managerReady:(UInt32)mode
{
    appDelegate.model = mode;
}


-(void)leftAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightAction
{

}

//- (void)playerControl:(NSNotification *)noti
//{
//    NSDictionary *info = noti.userInfo;
//    NSString *type = info[@"status"];
//    if ([type isEqualToString:@"play"]) {
//        [appDelegate.player cn_startai_playSong];
//    }else if ([type isEqualToString:@"pause"]){
//        [appDelegate.player cn_startai_pauseSong];
//    }else if ([type isEqualToString:@"previous"]){
//        [appDelegate.player cn_startai_playLastSong];
//    }else if ([type isEqualToString:@"next"]){
//        [appDelegate.player cn_startai_playNextSong];
//    }
//}

-(void)ReadyPlay:(NSNotification *)sender{
    
    self.playControl.playImg = [UIImage imageNamed:@"pause"];
    
}

-(void)next:(NSNotification *)sender{
    
    self.labelView.musicMessage = appDelegate.musicModel.songArr[appDelegate.musicModel.songIndex];
    
    self.introduceView.songInteger = appDelegate.musicModel.songIndex;
    
}

- (void)start:(NSNotification *)sender{
    self.playControl.playImg = [UIImage imageNamed:@"pause"];
}

- (void)suspended:(NSNotification *)sender{
    self.playControl.playImg = [UIImage imageNamed:@"play"];
}

@end
