//
//  MainViewController.m
//  BluetoothBox
//
//  Created by Mac on 2017/9/14.
//  Copyright © 2017年 Actions. All rights reserved.
//

#import "MainViewController.h"
#import "BTWheelColorViewController.h"
#import "BluetoothVC.h"
#import "FMVC.h"
#import "USBVC.h"
#import "AuxiliaryVC.h"
//#import <MultipeerConnectivity/MultipeerConnectivity.h>
#import "PopView.h"
#import "AppDelegate.h"
#import "BluzManager.h"
#import "BluzModel.h"
#import <MediaPlayer/MediaPlayer.h>
#import "BluetoothSerarchView.h"
#import "ExternalControlViewController.h"
#import "BTSaveSeqListViewController.h"
#import "TestViewController.h"
#import "SearchBluetoothView.h"
#import <math.h>
#import "AddDeviceResultView.h"
#import "FirmwareUpdateVCViewController.h"

@interface MainViewController ()<BluzProtocolDelegate>
{
    MBProgressHUD *hud;
    CGFloat vertical;
    AppDelegate *appDelegate;
}
@property (nonatomic, strong) UIButton *bluetoothBtn;           //蓝牙入口
@property (nonatomic, strong) UIButton *fmBtn;                  //fm入口
@property (nonatomic, strong) UIButton *usbBtn;                 //usb入口
@property (nonatomic, strong) UIButton *auxiliaryBtn;           //aux入口
@property (nonatomic, strong) UIButton *ledBtn;                 //灯控入口
@property (nonatomic, strong) UIButton *externalControlbtn;     //外设

@property (nonatomic, strong) BluetoothVC *bluetoothVC;         //蓝牙推歌控制器持有
@property (nonatomic, strong) FMVC *fmVC;                     //fm控制器持有
@property (nonatomic, strong) USBVC *usbVC;                   //usb控制器持有
@property (nonatomic, strong) AuxiliaryVC *auxVC;
@property (nonatomic, strong) BTWheelColorViewController *ledVC;   //灯控控制器持有
@property (nonatomic, strong) ExternalControlViewController *externVC; //外设控制器吃有
@property (nonatomic, strong) SearchBluetoothView *searchVC;   //蓝牙连接界面
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) BluetoothSerarchView *searchView;  //蓝牙搜索结果
@property (nonatomic, strong) PopView *disconnectBySelfPop;                 //蓝牙断开连接弹窗
@property (nonatomic, strong) PopView *breakPop;            //蓝牙掉线弹窗
@property (nonatomic, strong) AddDeviceResultView *resulView;  //添加音箱结果
@property (nonatomic, strong) BluzModel *model;   //蓝牙连接
@property (nonatomic, strong) UIButton *updateBtn;
@property (nonatomic, assign) BOOL intoUSB;     //是否处于usb模式
@property (nonatomic, assign) BOOL intoFM;      //是否处于fm模式
@property (nonatomic, assign) CGFloat offsetY; //记录页面开始滑动时的位置偏移量
@property (nonatomic, assign) NSInteger currentIndex; //记录当前显示btn位置
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic ,strong) NSTimer *connectionFailedTime; ///蓝牙连接 计时器

@property (nonatomic, assign) BOOL connected;
///拖拽开启关闭
@property (nonatomic ,assign) BOOL slideBool;

@end

@implementation MainViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.searchVC goToAnimation];
    
    
    [[ NSNotificationCenter defaultCenter ] addObserver : self selector : @selector (statusBarFrameWillChange:) name : UIApplicationWillChangeStatusBarFrameNotification object : nil ];
    
    [[ NSNotificationCenter defaultCenter ] addObserver : self selector : @selector (layoutControllerSubViews:) name : UIApplicationDidChangeStatusBarFrameNotification object : nil ];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if ([[BKUserDefaults objectForKey:DeviceUUIDD] isKindOfClass:[NSString class]]) {
            
            if (self.slideBool == NO) {
                [self paired];
            }
            
        }
        
    });
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    vertical = 30;//(SCREEN_HEIGHT - NavBarHeight - IPHONEBottom)/5.0-(92/395.0)*(SCREEN_WITDH-60);
    self.leftImg = [UIImage imageNamed:@""];
    self.navBg.hidden = true;
    self.connected = false;
    
    NSDate *date = [NSDate date];
    
    NSString *limitTimeString = Limit_time;
    
    NSDateFormatter *limitTimeFormatter = [[NSDateFormatter alloc] init];
    limitTimeFormatter.dateFormat = @"YYYY-MM-dd";
    
    NSDate *limitTimeDate = [limitTimeFormatter dateFromString:limitTimeString];
    
    NSComparisonResult result = [limitTimeDate compare:date];
    //当前时间大于限制时间
    if (result==NSOrderedAscending){
        self.slideBool = NO;
    }
    //当前时间小于限制时间
    else if (result==NSOrderedDescending){
        self.slideBool = YES;
    }
    
    [self cn_startai_initContentView];
    self.backGroundView.image = [UIImage imageNamed:@"MainBackGround"];
    
    MPMediaQuery *music = [[MPMediaQuery alloc] init];
    MPMediaPropertyPredicate *predicate = [MPMediaPropertyPredicate predicateWithValue:[NSNumber numberWithInteger:MPMediaTypeMusic] forProperty:MPMediaItemPropertyMediaType];
    [music addFilterPredicate:predicate];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                      selector:@selector(volumeChanged:)
                                         name:@"AVSystemController_SystemVolumeDidChangeNotification"
                                        object:nil];
    
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goAnimation:) name:@"MainAnimation" object:nil];
//    其它界面蓝牙掉了以后回到蓝牙重连界面
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoConnectPeripheral:) name:@"GotoConnectPeripheral" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(modelVolumeChanged:) name:@"speakerVolumeChange" object:nil];
    
    [[ NSNotificationCenter defaultCenter] addObserver:self selector:@selector(layoutControllerSubViews) name: UIApplicationDidChangeStatusBarFrameNotification object : nil ];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(systemGotConnectPeripheral:) name:@"SystemGotConnectPeripheral" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cbManagerStatePoweredOn:) name:@"CBManagerStatePoweredOn" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registrationMode:) name:@"RegistrationMode" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(modeChanged:) name:@"ModeChanged" object:nil];
}

- (BluzModel *)model
{
    if (!_model) {
        _model = [BluzModel shareInstance];
        _model.delegate = self;
    }
    return _model;
}

- (void)cn_startai_initContentView
{
    [self.view addSubview:self.bluetoothBtn];
    [self.view addSubview:self.fmBtn];
    [self.view addSubview:self.usbBtn];
    [self.view addSubview:self.auxiliaryBtn];
    [self.view addSubview:self.ledBtn];
    [self.view addSubview:self.externalControlbtn];
    [self.view addSubview:self.searchVC];
    [self.view addSubview:self.searchView];
    [self.view addSubview:self.resulView];
    [self.view addSubview:self.disconnectBySelfPop];
//    [self.view addSubview:self.updateBtn];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    pan.minimumNumberOfTouches = 1;
    [self.view addGestureRecognizer:pan];
    
}

- (UIButton *)updateBtn
{
    if (!_updateBtn) {
        _updateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _updateBtn.frame = CGRectMake(100, IPHONEFringe+20, 60, 30);
        [_updateBtn setTitle:@"update" forState:UIControlStateNormal];
        [_updateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_updateBtn addTarget:self action:@selector(update) forControlEvents:UIControlEventTouchUpInside];
    }
    return _updateBtn;
}

- (void)update
{
    FirmwareUpdateVCViewController *firVC = [[FirmwareUpdateVCViewController alloc] init];
    [firVC cn_startai_registerAppDelegate:[self.model getAppDelegate]];
    [self.navigationController pushViewController:firVC animated:true];
}

-(UIButton *)bluetoothBtn
{
    if (!_bluetoothBtn) {
        _bluetoothBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _bluetoothBtn.frame = CGRectMake(30, NavBarHeight+20, SCREEN_WITDH-60, (92/395.0)*(SCREEN_WITDH-60));
        [_bluetoothBtn setBackgroundImage:[UIImage imageNamed:@"BLUETOOTH"] forState:UIControlStateNormal];
        [_bluetoothBtn addTarget:self action:@selector(bluetooth) forControlEvents:UIControlEventTouchUpInside];
        _bluetoothBtn.hidden = true;
        _bluetoothBtn.userInteractionEnabled = false;
    }
    return _bluetoothBtn;
}

- (UIButton *)fmBtn
{
    if (!_fmBtn) {
        _fmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _fmBtn.frame = CGRectMake( 30, _bluetoothBtn.bottom+vertical, SCREEN_WITDH-60, (92/395.0)*(SCREEN_WITDH-60));
        [_fmBtn setBackgroundImage:[UIImage imageNamed:@"FMRADIO"] forState:UIControlStateNormal];
        [_fmBtn addTarget:self action:@selector(fm) forControlEvents:UIControlEventTouchUpInside];
        _fmBtn.hidden = true;
        _fmBtn.userInteractionEnabled = YES;
    }
    return _fmBtn;
}

- (UIButton *)usbBtn
{
    if (!_usbBtn) {
        _usbBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _usbBtn.frame = CGRectMake( 30, _fmBtn.bottom+vertical, SCREEN_WITDH-60, (92/395.0)*(SCREEN_WITDH-60));
        _usbBtn.frame = CGRectMake( 30, _bluetoothBtn.bottom+vertical, SCREEN_WITDH-60, (92/395.0)*(SCREEN_WITDH-60));
        [_usbBtn setBackgroundImage:[UIImage imageNamed:@"USBMODE"] forState:UIControlStateNormal];
        [_usbBtn addTarget:self action:@selector(usb) forControlEvents:UIControlEventTouchUpInside];
        _usbBtn.hidden = true;
        _usbBtn.userInteractionEnabled = false;
    }
    return _usbBtn;
}

- (UIButton *)auxiliaryBtn
{
    if (!_auxiliaryBtn) {
        _auxiliaryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _auxiliaryBtn.frame = CGRectMake( 30, _usbBtn.bottom+vertical, SCREEN_WITDH-60, (92/395.0)*(SCREEN_WITDH-60));
        [_auxiliaryBtn setBackgroundImage:[UIImage imageNamed:@"AUXILIARY"] forState:UIControlStateNormal];
        [_auxiliaryBtn addTarget:self action:@selector(auxiliary) forControlEvents:UIControlEventTouchUpInside];
        _auxiliaryBtn.hidden = true;
        _auxiliaryBtn.userInteractionEnabled = false;
    }
    return _auxiliaryBtn;
}

- (UIButton *)ledBtn
{
    if (!_ledBtn) {
        _ledBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _ledBtn.frame = CGRectMake( 30, _auxiliaryBtn.bottom+vertical, SCREEN_WITDH-60, (92/395.0)*(SCREEN_WITDH-60));
        [_ledBtn setBackgroundImage:[UIImage imageNamed:@"LED"] forState:UIControlStateNormal];
        [_ledBtn addTarget:self action:@selector(led) forControlEvents:UIControlEventTouchUpInside];
        _ledBtn.hidden = true;
        _ledBtn.userInteractionEnabled = false;
    }
    return _ledBtn;
}

- (UIButton *)externalControlbtn
{
    if (!_externalControlbtn) {
        _externalControlbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _externalControlbtn.frame =  CGRectMake( 30, _ledBtn.bottom+vertical, SCREEN_WITDH-60, (92/395.0)*(SCREEN_WITDH-60));
        [_externalControlbtn setBackgroundImage:[UIImage imageNamed:@"SWITCHMAIN"] forState:UIControlStateNormal];
        [_externalControlbtn addTarget:self action:@selector(externalControl) forControlEvents:UIControlEventTouchUpInside];
        _externalControlbtn.hidden = true;
        _externalControlbtn.userInteractionEnabled = false;
    }
    return _externalControlbtn;
}

- (SearchBluetoothView *)searchVC
{
    @weakify(self);
    if (!_searchVC) {
        _searchVC = [[SearchBluetoothView alloc] init];
        _searchVC.frame = CGRectMake(0, SCREEN_HEIGHT-(SCREEN_WITDH/720.0)*57-IPHONEBottom, SCREEN_WITDH, SCREEN_HEIGHT+(SCREEN_WITDH/720.0)*57+IPHONEBottom);
        _searchVC.connectedPeripheral = ^{
            [weak_self paired];
        };
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        tap.numberOfTapsRequired = 1;
        [_searchVC addGestureRecognizer:tap];
        _searchVC.isPull = true;
        
    }
    return _searchVC;
}


- (PopView *)disconnectBySelfPop
{
    @weakify(hud);
    @weakify(self);
    CGFloat hei = IS_IPHONE_5_OR_LESS ? 250 : 335;
    if (!_disconnectBySelfPop) {
        _disconnectBySelfPop = [[PopView alloc] initWithFrame:CGRectMake(20, (SCREEN_HEIGHT-hei)/2.0, SCREEN_WITDH-40, hei)];
        _disconnectBySelfPop.backgroundColor = [UIColor whiteColor];
        _disconnectBySelfPop.alpha = 0.7;
        _disconnectBySelfPop.rightText = @"Cancel";
        _disconnectBySelfPop.leftText = @"OK";
        _disconnectBySelfPop.text = NSLocalizedString(@"PartybarDisconnect", nil);
        _disconnectBySelfPop.hidden = true;
        _disconnectBySelfPop.leftHandler = ^{
            weak_self.model.disconnectedBySelf = true;
            weak_self.model.peripheralArr = [NSMutableArray array];
            [weak_self.model disConnected];
            weak_self.searchView.dataArr = [NSMutableArray array];
            weak_self.searchView.alpha = 0.3;
            weak_self.searchView.hidden = true;
            if (weak_hud) {
                [weak_hud hideAnimated:true];
            }
            weak_self.disconnectBySelfPop.hidden = true;
            weak_self.slideBool = NO;
        };
        _disconnectBySelfPop.rightHandler = ^{
            weak_self.disconnectBySelfPop.hidden = true;
            weak_self.slideBool = YES;
        };
    }
    return _disconnectBySelfPop;
}

#pragma mark 蓝牙断线弹窗
- (PopView *)breakPop
{
    @weakify(self);
    CGFloat hei = IS_IPHONE_5_OR_LESS ? 250 : 335;
    if (!_breakPop) {
        _breakPop = [[PopView alloc] initWithFrame:CGRectMake(20, (SCREEN_HEIGHT-hei)/2.0, SCREEN_WITDH-40, hei)];
        _breakPop.backgroundColor = [UIColor whiteColor];
        _breakPop.alpha = 0.7;
        _breakPop.text = NSLocalizedString(@"PartyConnectFailure", nil);
//        _breakPop.leftText = @"OK";
        _breakPop.rightText = @"OK";
        _breakPop.leftBtn.hidden = YES;
        _breakPop.leftHandler = ^{
            [weak_self.navigationController popToRootViewControllerAnimated:true];
            weak_self.searchVC.top = -(SCREEN_WITDH/720.0)*57;
            weak_self.searchVC.isPull = false;
            [weak_self.breakPop removeFromSuperview];
            [weak_self.maskView removeFromSuperview];
            weak_self.slideBool = NO;
            [weak_self.model disConnected];
        };
        _breakPop.rightHandler = ^{
            [weak_self.navigationController popToRootViewControllerAnimated:true];
            weak_self.searchVC.top = -(SCREEN_WITDH/720.0)*57;
            weak_self.searchVC.isPull = false;
            [weak_self.breakPop removeFromSuperview];
            [weak_self.maskView removeFromSuperview];
            weak_self.slideBool = NO;
        };
    }
    return _breakPop;
}

- (AddDeviceResultView *)resulView
{
    if (!_resulView) {
        _resulView = [[AddDeviceResultView alloc] initWithFrame:CGRectMake((SCREEN_WITDH-160)/2.0, 250, 160, 160)];
        _resulView.hidden = true;
    }
    return _resulView;
}

- (UIView *)maskView
{
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:self.view.bounds];
        _maskView.backgroundColor = [UIColor colorWithHexColorString:@"000000" withAlpha:0.7];
//        _maskView.hidden = true;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        tap.numberOfTapsRequired = 1;
        [_maskView addGestureRecognizer:tap];
    }
    return _maskView;
}

- (BluetoothSerarchView *)searchView
{
    @weakify(self);
    if (!_searchView) {
        _searchView = [[BluetoothSerarchView alloc] initWithFrame:CGRectMake(30, 150, SCREEN_WITDH-60, 300)];
        _searchView.backgroundColor = [UIColor blackColor];
        _searchView.BluetoothSelectedPeripheral = ^(NSInteger index) {
            weak_self.model.connectPeripheralIndex = index;
            weak_self.searchView.hidden = true;
            if (hud) {
                hud.hidden = true;
            }
        };
        _searchView.hidden = true;
        _searchView.layer.cornerRadius = 5;
        _searchView.layer.masksToBounds = true;
    }
    return _searchView;
}


#pragma mark  控制器初始化
- (BluetoothVC *)bluetoothVC
{
    if (!_bluetoothVC) {
        _bluetoothVC = [[BluetoothVC alloc] init];
    }
    return _bluetoothVC;
}

-(FMVC *)fmVC
{
    @weakify(self);
    if (!_fmVC) {
        _fmVC = [[FMVC alloc] init];
        _fmVC.GotoConnectPeripheral = ^{
            weak_self.searchVC.top = -(SCREEN_WITDH/720.0)*57;
            weak_self.searchVC.isPull = false;
        };
    }
    return _fmVC;
}

- (USBVC *)usbVC
{
    @weakify(self);
    if (!_usbVC) {
        _usbVC = [[USBVC alloc] init];
        _usbVC.GotoConnectPeripheral = ^{
            weak_self.searchVC.top = -(SCREEN_WITDH/720.0)*57;
            weak_self.searchVC.isPull = false;
        };
    }
    return _usbVC;
}

- (AuxiliaryVC *)auxVC
{
    @weakify(self);
    if (!_auxVC) {
        _auxVC = [[AuxiliaryVC alloc] init];
        _auxVC.GotoConnectPeripheral = ^{
            weak_self.searchVC.top = -(SCREEN_WITDH/720.0)*57;
            weak_self.searchVC.isPull = false;
        };
    }
    return _auxVC;
}

- (BTWheelColorViewController *)ledVC
{
    if (!_ledVC) {
        _ledVC = [[BTWheelColorViewController alloc] init];
    }
    return _ledVC;
}

- (ExternalControlViewController *)externVC
{
    if (!_externVC) {
        _externVC = [[ExternalControlViewController alloc] init];
        [_externVC cn_startai_registerAppDelegate:[self.model getAppDelegate] mode:0];

    }
    return _externVC;
}


#pragma  mark 进入蓝牙推歌界面
- (void)bluetooth
{
//    if (self.model.connected) {
    if ([[self.model getAppDelegate].globalManager isFeatureSupport:FeatureA2dp]) {
        
    }
    self.intoUSB = false;
    self.intoFM = false;
    [self.bluetoothVC cn_startai_registerAppDelegate:[self.model getAppDelegate] mode:MODE_A2DP];
    [self.navigationController pushViewController:self.bluetoothVC animated:YES];
//    }else{
//        [self HandleEvent:@"PartybarNotPair"];
//    }
}

#pragma mark 进入fm界面。
- (void)fm
{
//    if (self.model.connected) {
    if ([[self.model getAppDelegate].globalManager isFeatureSupport:FeatureRadio]) {

    }
    self.intoUSB = false;
//        if ([self model].getAppDelegate.player.player.rate == 1) {
//            [self.bluetoothVC cn_startai_pauseSong];
//        }
    
    [self.fmVC cn_startai_registerAppDelegate:[self.model getAppDelegate] mode:MODE_RADIO];
    
    if (self.model.connected) {
        self.intoFM = true;
    }
    
    [self.navigationController pushViewController:self.fmVC animated:YES];
//    }else{
//        [self HandleEvent:@"PartybarNotPair"];
//    }
}

#pragma mark 进入usb界面
- (void)usb
{
//    if (self.model.connected) {
//        if ([self model].getAppDelegate.player.player.rate == 1) {
//            [self.bluetoothVC cn_startai_pauseSong];
//        }
    
    if (self.model.connected) {
        self.intoUSB = true;
    }
    self.intoFM = false;
    [self.usbVC cn_startai_registerAppDelegate:[self.model getAppDelegate] mode:MODE_UHOST];
    [self.navigationController pushViewController:self.usbVC animated:YES];
//    }else{
//        [self HandleEvent:@"PartybarNotPair"];
//    }
}

#pragma mark 进入aux界面
- (void)auxiliary
{
    
//    if (self.model.connected) {
    if ([[self.model getAppDelegate].globalManager isFeatureSupport:FeatureLinein]) {
        
    }
    self.intoUSB = false;
    self.intoFM = false;
//        if ([self model].getAppDelegate.player.player.rate == 1) {
//            [self.bluetoothVC cn_startai_pauseSong];
//        }
    [self.auxVC cn_startai_registerAppDelegate:[self.model getAppDelegate] mode:MODE_LINEIN];
    
    [self.navigationController pushViewController:self.auxVC animated:YES];
        
//    }else{
//        [self HandleEvent:@"PartybarNotPair"];
//    }
}

#pragma mark 进入led界面

- (void)led
{
    if (self.model.connected) {
        [self.ledVC cn_startai_registerAppDelegate:[self.model getAppDelegate] mode:0];
        [self.navigationController pushViewController:self.ledVC animated:YES];
    }else{
        [self HandleEvent:@"ConnectBluetooth"];
    }
}

- (void)registrationMode:(NSNotification *)sender{
    
    NSInteger modelInteger = [sender.object integerValue];
    
    if (modelInteger == 4) {
        [self.fmVC cn_startai_registerAppDelegate:[self.model getAppDelegate] mode:MODE_RADIO];
    }
    
}

#pragma mark 进入继电器控制界面
- (void)externalControl
{
    if (self.model.connected) {
        [self.navigationController pushViewController:self.externVC animated:true];
    }else{
        [self HandleEvent:@"ConnectBluetooth"];
    }
}

#pragma mark 搜索蓝牙
- (void)paired
{
    if (!self.searchVC.connected) {
        [self.model GetReady];
    }else{
        self.disconnectBySelfPop.hidden = false;
        self.slideBool = NO;
    }
}

#pragma mark 系统音量变化
-(void)volumeChanged:(NSNotification *)notifi
{
    if ([notifi.name isEqualToString:@"AVSystemController_SystemVolumeDidChangeNotification"]) {
    
        NSString * style = [notifi.userInfo objectForKey:@"AVSystemController_AudioCategoryNotificationParameter"];
        CGFloat value1 = [[notifi.userInfo objectForKey:@"AVSystemController_AudioVolumeNotificationParameter"] doubleValue];
        int value2 = value1 *100;
        CGFloat value = value2/100.0;
        if ([style isEqualToString:@"Ringtone"]) {
            NSLog(@"铃声改变");
        }else if ([style isEqualToString:@"Audio/Video"]){
            NSLog(@"音量改变当前值:%f",value);
            
            if (![self.model getAppDelegate].isConnected) {
                [self.bluetoothVC setvolumeChanged:value];
                [self.auxVC setvolumeChanged:value];
                [self.usbVC setvolumeChanged:value];
                [self.fmVC setvolumeChanged:value];
            }else{
                NSInteger voice = (round)([self.model getAppDelegate].maxVoice * value);
//                [self.bluetoothVC setvolumeChanged:voice];
//                [self.auxVC setvolumeChanged:voice];
//                [self.usbVC setvolumeChanged:voice];
//                [self.fmVC setvolumeChanged:voice];
                [[self.model getAppDelegate].globalManager setVolume:(UInt32)voice];
            }

        }
        
    }
    
}

- (void)modelVolumeChanged:(NSNotification *)noti
{
    NSLog(@"------------------------------%f--------------",[self.model getAppDelegate].currentVoice);
    
//    [self.volumeSlider setValue:[self.model getAppDelegate].currentVoice/(float)[self.model getAppDelegate].maxVoice];
    
    [self.bluetoothVC setvolumeChanged:[self.model getAppDelegate].currentVoice];
    [self.auxVC setvolumeChanged:[self.model getAppDelegate].currentVoice];
    [self.usbVC setvolumeChanged:[self.model getAppDelegate].currentVoice];
    [self.fmVC setvolumeChanged:[self.model getAppDelegate].currentVoice];
    
//    //避免频繁改动音量 导致音量条抖动
//    if (_timer) {
//        [_timer invalidate];
//    }
//    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onTimeFire:) userInfo:nil repeats:false];
}

- (void)onTimeFire:(NSTimer *)timer
{
    [self.bluetoothVC setvolumeChanged:[self.model getAppDelegate].currentVoice];
    [self.auxVC setvolumeChanged:[self.model getAppDelegate].currentVoice];
    [self.usbVC setvolumeChanged:[self.model getAppDelegate].currentVoice];
    [self.fmVC setvolumeChanged:[self.model getAppDelegate].currentVoice];
    
    if (self.connected) {
        self.connected = false;
        [self.volumeSlider setValue:[self.model getAppDelegate].currentVoice/(float)[self.model getAppDelegate].maxVoice];
    }
    
    _timer = nil;
}

#pragma mark 通知跳转连接蓝牙界面
- (void)gotoConnectPeripheral:(NSNotification *)noti
{
    self.searchVC.top = -(SCREEN_WITDH/720.0)*57;
    self.searchVC.isPull = false;
}

#pragma mark 开始搜索蓝牙 弹出搜索界面
- (void)cbManagerStatePoweredOn:(NSNotification *)sender{
    
    self.searchView.hidden = false;
    self.searchView.alpha = 1.0;
    self.model.peripheralArr = [NSMutableArray array];
    self.searchView.dataArr = [NSMutableArray array];
    
    if (!hud) {
        hud = [[MBProgressHUD alloc] initWithView:self.view];
        hud.centerY = self.searchView.bottom;
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.userInteractionEnabled = false;
        hud.label.text = NSLocalizedString(@"SearchingDevices", nil);
        hud.label.textColor = [UIColor whiteColor];
        hud.userInteractionEnabled = false;
        [self.view addSubview:hud];
        [hud showAnimated:true];
    }else{
        hud.hidden = false;
        [hud showAnimated:true];
    }
    [self.searchView bringSubviewToFront:self.view];
    
}

#pragma mark 系统关闭蓝牙 再次打开蓝牙 SDK 无刷新蓝牙连接
- (void)systemGotConnectPeripheral:(NSNotification *)sender{
    
    hud.hidden = YES;
    self.searchVC.top = -(SCREEN_WITDH/720.0)*57;
    self.searchVC.isPull = false;
    [self.breakPop removeFromSuperview];
    [self.maskView removeFromSuperview];
    
    self.model.disconnectedBySelf = true;
    self.model.peripheralArr = [NSMutableArray array];
    [self.model disConnected];
    self.searchView.dataArr = [NSMutableArray array];
    self.searchView.alpha = 0.3;
    self.searchView.hidden = true;
    
    self.slideBool = NO;
    
}

#pragma mark 主界面动画
- (void)goAnimation:(NSNotification *)noti
{
    if (!self.model.connected) {
        self.searchVC.top = -(SCREEN_WITDH/720.0)*57;
        self.searchVC.isPull = false;
    }
    self.currentIndex = 0;
    NSTimer *timer =  [NSTimer scheduledTimerWithTimeInterval:0.25 target:self selector:@selector(animationChange:) userInfo:nil repeats:true];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)animationChange:(NSTimer *)timer
{
//    NSArray *arr = @[self.bluetoothBtn,self.fmBtn,self.usbBtn,self.auxiliaryBtn,self.ledBtn,self.externalControlbtn];
    NSArray *arr = @[self.bluetoothBtn,self.usbBtn,self.auxiliaryBtn,self.ledBtn,self.externalControlbtn];
    UIButton *btn = arr[self.currentIndex];
    btn.hidden = false;
    btn.userInteractionEnabled = true;
    btn.alpha = 0;
    btn.height = 0;
    [UIView animateWithDuration:0.25 animations:^{
        btn.alpha = 1;
        btn.height = (92/395.0)*(SCREEN_WITDH-90);
    } completion:^(BOOL finished) {
        
    }];
    self.currentIndex ++;
    if (self.currentIndex >= arr.count) {
        [timer invalidate];
        timer = nil;
//        [self connectedPeripheralSucess:@"BAZ-G2-FM"];
//        [self performSelector:@selector(HandleEvent:) withObject:@"break" afterDelay:30];
//        [self performSelector:@selector(connectedPeripheralSucess:) withObject:@"BAZ-G2" afterDelay:10];
//        [self performSelector:@selector(connectedPeripheralSucess:) withObject:@"BAZ-G2-FM" afterDelay:20];
    }
}

- (void)tapAction:(UITapGestureRecognizer *)tap
{
    self.searchView.hidden = true;
    if (hud) {
        hud.hidden = true;
    }
}

#pragma mark 拖拽蓝牙界面
- (void)panAction:(UIPanGestureRecognizer *)pan
{
    
    if (self.slideBool == NO) {
        return;
    }
    
    if (pan.state == UIGestureRecognizerStateBegan) {
        self.offsetY = self.searchVC.top;
    }
    CGPoint point = [pan translationInView:self.view];
    self.searchVC.top = self.offsetY + point.y;
    if (self.searchVC.top<0) {
        self.searchVC.top = -(SCREEN_WITDH/720.0)*57;
        self.searchVC.isPull = false;
    }
    if (pan.state == UIGestureRecognizerStateEnded) {
        
        if (fabs(point.y)>SCREEN_HEIGHT/3.0 && point.y<0){
            [UIView animateWithDuration:0.35 animations:^{
                self.searchVC.top = -(SCREEN_WITDH/720.0)*57;
                self.searchVC.isPull = false;
            }];
        }else if(point.y>SCREEN_HEIGHT/3.0 || self.searchVC.top>80){
            self.searchView.hidden = true;
            if (hud) {
                hud.hidden = true;
            }
            [UIView animateWithDuration:0.35 animations:^{
                
                CGRect statusBarRect = [[UIApplication sharedApplication] statusBarFrame];
                
                if (!IS_IPHONE_X) {
                    
                    if (statusBarRect.size.height == 40) {
                        self.searchVC.top = SCREEN_HEIGHT - (SCREEN_WITDH/720.0)*57-IPHONEBottom - 20;
                    }else{
                        self.searchVC.top = SCREEN_HEIGHT - (SCREEN_WITDH/720.0)*57-IPHONEBottom;
                    }
                    
                }else{
                    self.searchVC.top = SCREEN_HEIGHT-(SCREEN_WITDH/720.0)*57-IPHONEBottom;
                }
                
                self.searchVC.isPull = true;
            }];
        }else if (self.searchVC.isPull == NO){
            
            [UIView animateWithDuration:0.35 animations:^{
                self.searchVC.top = -30;
            }];

        }
    }
    
}


#pragma mark 蓝牙断开事件
- (void)HandleEvent:(NSString *)hand
{
    
    self.connected = false;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"musicSuspended" object:[NSString stringWithFormat:@""]];
    
    if ([hand isEqualToString:@"break"]) {
        self.slideBool = NO;
        [[self lastWindow] addSubview:self.maskView];
        [self.maskView addSubview:self.breakPop];
        _breakPop.text = NSLocalizedString(@"PartyConnectFailure", nil);
        _breakPop.single = 1;
    }else if([hand isEqualToString:@"PartybarNotPair"]){
        self.slideBool = NO;
        [[self lastWindow] addSubview:self.maskView];
        [self.maskView addSubview:self.breakPop];
        _breakPop.text = NSLocalizedString(@"PartybarNotPair", nil);
        _breakPop.single = 1;
    }else if ([hand isEqualToString:@"ConnectBluetooth"]){
        self.slideBool = NO;
        [[self lastWindow] addSubview:self.maskView];
        [self.maskView addSubview:self.breakPop];
        _breakPop.text = NSLocalizedString(@"ConnectBluetooth", nil);
        _breakPop.single = 1;
    }else{
        self.slideBool = NO;
        
        [self.navigationController popToRootViewControllerAnimated:true];
        self.searchVC.top = -(SCREEN_WITDH/720.0)*57;
        self.searchVC.isPull = false;
        [self.breakPop removeFromSuperview];
        [self.maskView removeFromSuperview];
        self.slideBool = NO;
//        [self.model disConnected];
        
//        self.resulView.hidden = false;
//        self.resulView.result = false;
//        self.resulView.alpha = 1.0;
//        [UIView animateWithDuration:1.0 animations:^{
//            self.resulView.alpha = 0.3;
//        } completion:^(BOOL finished) {
//            self.resulView.hidden = true;
//            
//        }];
    }
    self.model.disconnectedBySelf = false;
    self.model.peripheralArr = [NSMutableArray array];
    self.searchView.dataArr = [NSMutableArray array];
    self.searchView.hidden = true;
    self.searchVC.connected = false;
    if (hud) {
        [hud hideAnimated:true];
    }
    self.searchVC.modelText = @"";
    self.intoUSB = false;
    self.intoFM = false;
    
    if ([[NSUserDefaults standardUserDefaults]integerForKey:@"updateSucess"] == 1) {
        [self cn_startai_showToastWithTitle:@"升级失败"];
    }
    
//    [self.model getAppDelegate].conncetType = BAZ_None;
//    vertical = 20;
//    self.fmBtn.hidden = false;
//    self.usbBtn.hidden = false;
//    self.auxiliaryBtn.hidden = false;
//    self.externalControlbtn.hidden = false;
//    self.bluetoothBtn.frame = CGRectMake(30, NavBarHeight+20, SCREEN_WITDH-60, (92/395.0)*(SCREEN_WITDH-60));
//    self.fmBtn.frame = CGRectMake( 30, _bluetoothBtn.bottom+vertical, SCREEN_WITDH-60, (92/395.0)*(SCREEN_WITDH-60));
//    self.usbBtn.frame = CGRectMake( 30, _fmBtn.bottom+vertical, SCREEN_WITDH-60, (92/395.0)*(SCREEN_WITDH-60));
//    self.auxiliaryBtn.frame = CGRectMake( 30, _usbBtn.bottom+vertical, SCREEN_WITDH-60, (92/395.0)*(SCREEN_WITDH-60));
//    self.ledBtn.frame = CGRectMake( 30, _auxiliaryBtn.bottom+vertical, SCREEN_WITDH-60, (92/395.0)*(SCREEN_WITDH-60));
//    self.externalControlbtn.frame =  CGRectMake( 30, _ledBtn.bottom+vertical, SCREEN_WITDH-60, (92/395.0)*(SCREEN_WITDH-60));
    
//    vertical = 30;
//    self.fmBtn.hidden = true;
//    self.usbBtn.hidden = false;
//    self.auxiliaryBtn.hidden = false;
//    self.externalControlbtn.hidden = false;
//    self.bluetoothBtn.frame = CGRectMake(30, NavBarHeight+20, SCREEN_WITDH-60, (92/395.0)*(SCREEN_WITDH-60));
//    //        self.fmBtn.frame = CGRectMake( 30, _bluetoothBtn.bottom+vertical, SCREEN_WITDH-60, (92/395.0)*(SCREEN_WITDH-60));
//    self.usbBtn.frame = CGRectMake( 30, _bluetoothBtn.bottom+vertical, SCREEN_WITDH-60, (92/395.0)*(SCREEN_WITDH-60));
//    self.auxiliaryBtn.frame = CGRectMake( 30, _usbBtn.bottom+vertical, SCREEN_WITDH-60, (92/395.0)*(SCREEN_WITDH-60));
//    self.ledBtn.frame = CGRectMake( 30, _auxiliaryBtn.bottom+vertical, SCREEN_WITDH-60, (92/395.0)*(SCREEN_WITDH-60));
//    self.externalControlbtn.frame =  CGRectMake( 30, _ledBtn.bottom+vertical, SCREEN_WITDH-60, (92/395.0)*(SCREEN_WITDH-60));
    
}

#pragma mark 蓝牙连接事件
- (void)connectedPeripheralSucess:(NSString *)name
{
    
    self.slideBool = YES;
    [self.connectionFailedTime invalidate];
    self.connectionFailedTime = nil;
    
    if (!self.searchView.hidden) {
        [UIView animateWithDuration:0.35 animations:^{
            self.searchView.alpha = 0.3;
        } completion:^(BOOL finished) {
            self.searchView.hidden = true;
        }];
        if (hud) {
            [hud hideAnimated:true];
        }
    }
    
    self.searchVC.connected = true;
    NSRange range = [name rangeOfString:@"_"];
    if (range.location && range.length) {
        NSArray *arr = [name componentsSeparatedByString:@"_"];
        self.searchVC.modelText = arr[0];
    }else{
        self.searchVC.modelText = name;
    }
    
    self.resulView.hidden = false;
    self.resulView.result = 0;
    self.resulView.alpha = 1.0;
    
    [UIView animateWithDuration:1.0 animations:^{
        self.resulView.alpha = 0.3;
    } completion:^(BOOL finished) {
        self.resulView.hidden = true;
        self.searchVC.top = SCREEN_HEIGHT-(SCREEN_WITDH/720.0)*57-IPHONEBottom;
        self.searchVC.isPull = true;
    }];
    
//    @"BAZ-G2-FM"
    if ([name containsString:@"FM"]) {
        [self.model getAppDelegate].conncetType = BAZ_G2_FM;
        vertical = SCREEN_WITDH * 0.12;
        self.fmBtn.hidden = false;
        self.usbBtn.hidden = false;
        self.auxiliaryBtn.hidden = true;
        self.externalControlbtn.hidden = true;
        
        self.bluetoothBtn.frame = CGRectMake(30, NavBarHeight+60, SCREEN_WITDH-60, (92/395.0)*(SCREEN_WITDH-60));
        self.fmBtn.frame = CGRectMake( 30, _bluetoothBtn.bottom+vertical, SCREEN_WITDH-60, (92/395.0)*(SCREEN_WITDH-60));
        self.usbBtn.frame = CGRectMake( 30, _fmBtn.bottom+vertical, SCREEN_WITDH-60, (92/395.0)*(SCREEN_WITDH-60));
//        self.auxiliaryBtn.frame = CGRectMake( 30, _usbBtn.bottom+vertical, SCREEN_WITDH-60, (92/395.0)*(SCREEN_WITDH-60));
        self.ledBtn.frame = CGRectMake( 30, _usbBtn.bottom+vertical, SCREEN_WITDH-60, (92/395.0)*(SCREEN_WITDH-60));
//        self.externalControlbtn.frame =  CGRectMake( 30, _ledBtn.bottom+vertical, SCREEN_WITDH-60, (92/395.0)*(SCREEN_WITDH-60));
    }else{
        [self.model getAppDelegate].conncetType = BAZ_G2;
        vertical = SCREEN_WITDH * 0.08;
        self.fmBtn.hidden = true;
        self.usbBtn.hidden = false;
        self.auxiliaryBtn.hidden = false;
        self.externalControlbtn.hidden = false;
        
//        [self.bluetoothBtn setFrame:CGRectMake(30, NavBarHeight+20, SCREEN_WITDH-60, (92/395.0)*(SCREEN_WITDH-60))];
        
        self.bluetoothBtn.frame = CGRectMake(30, NavBarHeight+20, SCREEN_WITDH-60, (92/395.0)*(SCREEN_WITDH-60));
//        self.fmBtn.frame = CGRectMake( 30, _bluetoothBtn.bottom+vertical, SCREEN_WITDH-60, (92/395.0)*(SCREEN_WITDH-60));
        
        self.usbBtn.frame = CGRectMake( 30, _bluetoothBtn.bottom+vertical, SCREEN_WITDH-60, (92/395.0)*(SCREEN_WITDH-60));
        self.auxiliaryBtn.frame = CGRectMake( 30, _usbBtn.bottom+vertical, SCREEN_WITDH-60, (92/395.0)*(SCREEN_WITDH-60));
        self.ledBtn.frame = CGRectMake( 30, _auxiliaryBtn.bottom+vertical, SCREEN_WITDH-60, (92/395.0)*(SCREEN_WITDH-60));
        self.externalControlbtn.frame =  CGRectMake( 30, _ledBtn.bottom+vertical, SCREEN_WITDH-60, (92/395.0)*(SCREEN_WITDH-60));
    }
    
    if ([[NSUserDefaults standardUserDefaults]integerForKey:@"updateSucess"] == 1) {
        [self update];
    }
    self.connected = true;
}


- (void)correctVolume
{
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    CGFloat volume = audioSession.outputVolume;
    int value2 = volume *100;
    CGFloat value = value2/100.0;
    NSInteger voice = (round)([self.model getAppDelegate].maxVoice * value);
    [[self.model getAppDelegate].globalManager setVolume:(UInt32)voice];
}

#pragma mark 连接蓝牙 5s 判断为连接失败
- (void)connectionFailed:(NSString *)name{
    
    [self.connectionFailedTime invalidate];
    self.connectionFailedTime = nil;
    self.connectionFailedTime = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(connectionFailedTimeEnd) userInfo:nil repeats:NO];
    //不重复，只调用一次。timer运行一次就会自动停止运行
    
}

- (void)connectionFailedTimeEnd{
    
    self.resulView.hidden = false;
    self.resulView.result = 1;
    self.resulView.alpha = 1.0;
    
    [UIView animateWithDuration:1.0 animations:^{
        self.resulView.alpha = 0.3;
    } completion:^(BOOL finished) {
        self.resulView.hidden = true;
    }];
    
}

#pragma mark 搜索蓝牙列表 60s 无ble设备判断 搜索超时
- (void)searchListOvertime{
    [self.connectionFailedTime invalidate];
    self.connectionFailedTime = nil;
    self.connectionFailedTime = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(searchListTimeEnd) userInfo:nil repeats:NO];
}

- (void)searchListTimeEnd{
    hud.hidden = YES;
    [hud showAnimated:false];
    
    self.resulView.hidden = false;
    self.resulView.result = 2;
    self.resulView.alpha = 1.0;
    
    [UIView animateWithDuration:1.0 animations:^{
        self.resulView.alpha = 0.3;
    } completion:^(BOOL finished) {
        self.resulView.hidden = true;
    }];
    
}

#pragma mark 刷新蓝牙展示列表
- (void)refershPeripheral:(NSMutableArray *)peripherialArr
{
    [self.connectionFailedTime invalidate];
    self.connectionFailedTime = nil;
    self.searchView.dataArr = peripherialArr;
}

- (void)modeChanged:(NSNotification *)sender{
    
    [self.model modeChanged:[sender.object intValue]];
    
}

- (void)statusBarFrameWillChange:(NSNotification *)sender{
    
    [self statusBarChange];
    
}

- (void)layoutControllerSubViews:(NSNotification *)sender{
    
    [self statusBarChange];
    
}

#pragma mark   状态栏 变化改变布局
- (void)statusBarChange{
    
    CGRect statusBarRect = [[UIApplication sharedApplication] statusBarFrame];
    
    NSLog(@"%f",statusBarRect.size.height);
    
    if (self.searchVC.isPull == NO) {
        
    }else if (self.searchVC.isPull == YES){
        
        [UIView animateWithDuration:0.35 animations:^{
            
            if (!IS_IPHONE_X) {
                
                if (statusBarRect.size.height == 40) {
                    self.searchVC.top = SCREEN_HEIGHT - (SCREEN_WITDH/720.0)*57-IPHONEBottom - 20;
                }else{
                    self.searchVC.top = SCREEN_HEIGHT - (SCREEN_WITDH/720.0)*57-IPHONEBottom;
                }
                
            }else{
                self.searchVC.top = SCREEN_HEIGHT-(SCREEN_WITDH/720.0)*57-IPHONEBottom;
            }
            
        }];
        
    }
    
}


- (UIWindow *)lastWindow
{
//    NSArray *windows = [UIApplication sharedApplication].windows;
//    for(UIWindow *window in [windows reverseObjectEnumerator]) {
//        
//        if ([window isKindOfClass:[UIWindow class]] &&
//            CGRectEqualToRect(window.bounds, [UIScreen mainScreen].bounds))
//            
//            return window;
//    }
//    
    return [UIApplication sharedApplication].keyWindow;
}

- (void)layoutControllerSubViews{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
