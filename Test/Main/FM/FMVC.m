//
//  FMVC.m
//  BluetoothBox
//
//  Created by Mac on 2017/9/18.
//  Copyright © 2017年 Actions. All rights reserved.
//

#import "FMVC.h"
#import "BoxPlayerControl.h"
#import "BoxPlayerBackGround.h"
#import "BoxSongIntroduceView.h"
#import "FMSliderView.h"
#import "PopView.h"

@interface FMVC ()<BoxPlayControlProctol,RadioDelegate>
{
    AppDelegate *appDelegate;
    MBProgressHUD *hud;
}
@property (nonatomic, strong) FMSliderView *slideView;
@property (nonatomic, strong) BoxPlayerControl *playControl;
@property (nonatomic, strong) BoxPlayerBackGround *playBack;
@property (nonatomic, strong) BoxSongIntroduceView *introduceView;
@property (nonatomic, strong) PopView *pop;
@property (nonatomic, strong) NSMutableArray *channalList;
@property (nonatomic, strong) NSMutableArray *loveChannalList;
@property (nonatomic, assign) BOOL scan;
@end

@implementation FMVC

- (void)cn_startai_registerAppDelegate:(AppDelegate *)delegate mode:(UInt32)mode
{
    appDelegate = delegate;
    [appDelegate.globalManager setMode:mode];
    appDelegate.radioManager = [appDelegate.mMediaManager getRadioManager:self];
}

- (void)viewWillDisappear:(BOOL)animated
{
    if (hud) {
        hud.hidden = true;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (appDelegate.isConnected ) {
        if (appDelegate.isConnected ) {
            if ((round)(self.playControl.volumeValue * appDelegate.maxVoice) != appDelegate.currentVoice) {
                self.playControl.setVoice = appDelegate.currentVoice / (float)appDelegate.maxVoice;
            }
        }
    }
    self.playBack.scrollView.contentOffset = CGPointMake(0, 0);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.loveChannalList = [NSMutableArray array];
    if ([[NSUserDefaults standardUserDefaults]objectForKey:LOVECHANNALLIST]) {
        id object = [[NSUserDefaults standardUserDefaults] objectForKey:LOVECHANNALLIST];
        if ([object isKindOfClass:[NSArray class]]) {
            self.loveChannalList = [NSMutableArray arrayWithArray:(NSArray *)object];
        }
    }
    self.channalList = [NSMutableArray array];
    for (NSInteger i=0; i<self.loveChannalList.count; i++) {
        RadioEntry *entry = [[RadioEntry alloc] init];
        entry.channel = (UInt32)[[self.loveChannalList objectAtIndex:i] integerValue];
        entry.name = @"";
        [self.channalList addObject:entry];
    }
    [self arrangementChannalList];
    self.introduceView.channalList = self.channalList;
    self.backGroundView.image = [UIImage imageNamed:@"MainBackGround"];
}

- (instancetype)init
{
    if (self = [super init]) {
        [self cn_startai_initContentView];
        self.logo = [UIImage imageNamed:@"fm"];
    }
    return self;
}

- (void)cn_startai_initContentView
{
    CGFloat hei = IS_IPHONE_5_OR_LESS ? 280 :280;
    [self.view addSubview:self.playBack];
    self.playBack.scrollView.contentSize = CGSizeMake((SCREEN_WITDH-50)*2, hei);
    [self.playBack.scrollView addSubview:self.slideView];
    [self.playBack.scrollView addSubview:self.playControl];
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

- (FMSliderView *)slideView
{
    if (!_slideView) {
        _slideView = [[FMSliderView alloc] initWithFrame:CGRectMake(20, 50/420.0*self.playBack.height, self.playBack.width - 40, 100)];
        _slideView.fmValueHandler = ^(CGFloat value) {
            [appDelegate.radioManager select:(UInt32)value*1000];
        };
        
    }
    return _slideView;
}

- (BoxPlayerControl *)playControl
{
    @weakify(self);
    if (!(_playControl)) {
        _playControl = [[BoxPlayerControl alloc] initWithFrame:CGRectMake(0, self.slideView.bottom, self.playBack.width, self.playBack.height - self.slideView.bottom)];
        _playControl.delegate = self;
        _playControl.isFM = YES;
        _playControl.playImg = [UIImage imageNamed:@"scan"];
    }
    _playControl.addLoveList = ^{
        RadioEntry *entry = [[RadioEntry alloc] init];
//        entry.channel = (UInt32)weak_self.slideView.getValue*1000;
        entry.channel = weak_self.slideView.getValue * 1000;
        entry.name = @"";
        BOOL exist = false;
        for (RadioEntry *entry1 in weak_self.channalList) {
            if (entry1.channel == entry.channel) {
                exist = true;
            }
        }
        if (!exist) {
            [weak_self.channalList addObject:entry];
            [weak_self arrangementChannalList];
            weak_self.introduceView.channalList = weak_self.channalList;
        }
        BOOL res = false;
        for (NSInteger i=0; i<weak_self.loveChannalList.count; i++) {
            UInt32 channel = (UInt32)[[weak_self.loveChannalList objectAtIndex:i] integerValue];
            if (channel == entry.channel) {
                res = true;
                break;
            }
        }
        if (!res) {
            [weak_self.loveChannalList addObject:@(entry.channel)];
            [[NSUserDefaults standardUserDefaults] setObject:weak_self.loveChannalList forKey:LOVECHANNALLIST];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    };
    return _playControl;
}

- (BoxSongIntroduceView *)introduceView
{
    @weakify(self);
    if (!_introduceView) {
        _introduceView = [[BoxSongIntroduceView alloc] initWithFrame:CGRectMake(self.playBack.width, 0, self.playBack.width, self.playBack.height)];
        _introduceView.isFM = true;
        _introduceView.tapSelectedHandler = ^(NSInteger row) {
            RadioEntry *entity = weak_self.channalList[row];
            weak_self.slideView.fmValue = entity.channel/1000.0;
            [appDelegate.radioManager select:entity.channel];
        };
    }
    _introduceView.deleteFMChannelHandler = ^(NSInteger row) {
        if (row<weak_self.channalList.count) {
            RadioEntry *entry = [weak_self.channalList objectAtIndex:row];
            for (NSInteger i=0; i<weak_self.loveChannalList.count; i++) {
                UInt32 channel = (UInt32)[[weak_self.loveChannalList objectAtIndex:i] integerValue];
                if (channel == entry.channel) {
                    [weak_self.loveChannalList removeObjectAtIndex:i];
                    [[NSUserDefaults standardUserDefaults] setObject:weak_self.loveChannalList forKey:LOVECHANNALLIST];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    break;
                }
            }
            [weak_self.channalList removeObjectAtIndex:row];
            weak_self.introduceView.channalList = weak_self.channalList;
        }
    };
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

- (void)setChannalList:(NSMutableArray *)channalList
{
    _channalList = channalList;
}

- (void)leftAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightAction
{
    
}

#pragma mark BoxPlayControlProctol

- (void)cn_startai_playSong
{
    if (!appDelegate.isConnected) {
        self.pop.hidden = false;
        return;
    }
    self.scan = !self.scan;
    if (self.scan) {
        [appDelegate.radioManager scanStart];
        if (!hud) {
            hud = [[MBProgressHUD alloc] initWithView:self.view];
            hud.label.text = NSLocalizedString(@"SearchRadio", nil);
            hud.label.textColor = [UIColor blackColor];
            [hud showAnimated:true];
            hud.userInteractionEnabled = false;
            [self.view addSubview:hud];
        }
        hud.hidden = false;
    }else{
        hud.hidden = true;
        [appDelegate.radioManager scanStop];
    }
}

- (void)finetuneReduce
{
    if (!appDelegate.isConnected) {
        self.pop.hidden = false;
        return;
    }
    NSLog(@"----------getValue---------------_%.1f",self.slideView.getValue);
    self.slideView.fmValue = self.slideView.getValue-0.1;
    [appDelegate.radioManager select:self.slideView.getValue*1000];
}

- (void)finetuneAdd
{
    if (!appDelegate.isConnected) {
        self.pop.hidden = false;
        return;
    }
    NSLog(@"----------getValue---------------_%.1f",self.slideView.getValue);
    self.slideView.fmValue = self.slideView.getValue+0.1;
    [appDelegate.radioManager select:self.slideView.getValue*1000];
}

- (void)cn_startai_playLastSong
{
    if (!appDelegate.isConnected) {
        self.pop.hidden = false;
        return;
    }
    for (NSInteger i=self.channalList.count-1; i >=0; i--) {
        RadioEntry *entity = self.channalList[i];
        CGFloat fm = self.slideView.getValue*1000;
        if ((fm - entity.channel>0) && (fm - entity.channel<100)) {
            fm = entity.channel;
        }
        if (entity.channel < fm && entity.channel > 87000) {
            self.slideView.fmValue = entity.channel/1000.0;
            [appDelegate.radioManager select:entity.channel];
            break;
        }
    }
}

- (void)cn_startai_playNextSong
{
    if (!appDelegate.isConnected) {
        self.pop.hidden = false;
        return;
    }
    for (NSInteger i=0; i < self.channalList.count; i++) {
        RadioEntry *entity = self.channalList[i];
        CGFloat fm = self.slideView.getValue*1000;
        if (entity.channel - fm<100) {
            fm = entity.channel;
        }
        if (entity.channel > fm &&  entity.channel < 108000) {
            self.slideView.fmValue = entity.channel/1000.0;
            [appDelegate.radioManager select:entity.channel];
            break;
        }
    }
}

- (void)cn_startai_voiceChanged:(CGFloat)value
{
    NSLog(@"------------------%f",value);
}

- (void)cn_startai_voiceChangedEnd:(CGFloat)value
{
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


#pragma mark - RadioDelegate
#pragma mark -音箱当前的模式
-(void)managerReady:(UInt32)mode
{
    appDelegate.model = mode;
}

#pragma mark -音箱返回搜到得电台列表
-(void)radioListChanged:(NSMutableArray *)channelList
{
    [self.channalList removeAllObjects];
    
    for (RadioEntry *entry1 in channelList) {
//        BOOL exist = false;
//        for (RadioEntry *entry2 in self.channalList) {
//            if (entry1.channel == entry2.channel) {
//                exist = true;
//            }
//        }
//        if (!exist) {
            [self.channalList addObject:entry1];
//        }
    }
    [self arrangementChannalList];
    self.introduceView.channalList = self.channalList;
    hud.hidden = true;
    if (channelList.count == 0) {
        [self cn_startai_showToastWithTitle:NSLocalizedString(@"NoRadio",nil)];
    }else{
        [self cn_startai_showToastWithTitle:NSLocalizedString(@"SearchRadioSucess",nil)];
    }
    
    if (self.channalList.count > 0) {
        self.introduceView.songInteger = 0;
    }
    
    [appDelegate.globalManager setVolume:(UInt32)(self.playControl.volumeValue *appDelegate.maxVoice)];
}

#pragma mark -收音机当前模式变化
- (void)radioStateChanged:(UInt32)state
{
    
}

#pragma mark - 当前电台频率变化
-(void)channelChanged:(UInt32)channel
{
    
    CGFloat fmFloat = (float)channel / 1000;
    
    self.slideView.fmValue = fmFloat;

    BOOL clean = NO;
    
    for (int i = 0; i < self.channalList.count; i++) {
        
        RadioEntry *entity = self.channalList[i];
        
        if (entity.channel == channel) {
            self.introduceView.songInteger = i;
            clean = YES;
        }
        
    }
    
    if (clean == NO) {
        [self.introduceView setReset];
    }
    
}

#pragma mark - 收音机当前频段变化
-(void)bandChanged:(UInt32)band
{
    
}

- (void)setIsConnected:(BOOL)isConnected
{
    _isConnected = isConnected;
}

- (void)arrangementChannalList{
    if (self.channalList.count>1) {
        for (NSInteger i=0; i<self.channalList.count-1; i++) {
            for (NSInteger j=0; j<self.channalList.count-1-i; j++) {
                RadioEntry *entry1 = self.channalList[j];
                RadioEntry *entry2 = self.channalList[j+1];
                if (entry1.channel > entry2.channel) {
                    [self.channalList exchangeObjectAtIndex:j withObjectAtIndex:j+1];
                }
            }
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
