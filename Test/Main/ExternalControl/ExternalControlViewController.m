//
//  ExternalControlViewController.m
//  Test
//
//  Created by Mac on 2017/11/3.
//  Copyright © 2017年 QiXing. All rights reserved.
//

#import "ExternalControlViewController.h"
#import "ExternalView.h"
#import "ExternalRenameView.h"

@interface ExternalControlViewController ()<GlobalDelegate>
{
    AppDelegate *appDelegate;;
}

@property (nonatomic, strong) ExternalView *firstView;
@property (nonatomic, strong) ExternalView *secondView;
@property (nonatomic, strong) ExternalView *thirdView;
@property (nonatomic, strong) ExternalView *forthView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) ExternalRenameView *reNameView;

@end

@implementation ExternalControlViewController

- (void)cn_startai_registerAppDelegate:(AppDelegate *)delegate mode:(UInt32)mode
{
    appDelegate = delegate;
    appDelegate.globalManager = [appDelegate.mMediaManager getGlobalManager:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self cn_startai_queFlash];
    appDelegate.globalManager = [appDelegate.mMediaManager getGlobalManager:self];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.reNameView.hidden = true;
}

- (void)cn_startai_queFlash
{
    int key = [appDelegate.globalManager buildKey:QUE cmdID:0x98];
    if (key != -1) {
        [appDelegate.globalManager sendCustomCommand:key param1:0 param2:0 others:nil];
    }
}

- (instancetype)init
{
    if (self == [super init]) {
        self.view.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:self.firstView];
        [self.view addSubview:self.secondView];
        [self.view addSubview:self.thirdView];
        [self.view addSubview:self.forthView];
        [self.view addSubview:self.reNameView];
//        [self cn_startai_switchControl:0 onoff:0];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.backGroundView.image = [UIImage imageNamed:@"SWITCHPAGEBG"];
}

- (ExternalRenameView *)reNameView
{
    @weakify(self);
    if (!_reNameView) {
        _reNameView = [[ExternalRenameView alloc] initWithFrame:CGRectMake(15, 150,SCREEN_WITDH-30, 220)];
        _reNameView.backgroundColor = [UIColor whiteColor];
        _reNameView.layer.cornerRadius = 5;
        _reNameView.hidden = true;
        _reNameView.layer.masksToBounds = true;
        _reNameView.renameHandler = ^(NSInteger serail, NSString *name) {
            if ( serail >0 && !name.length) {
                [weak_self cn_startai_showToastWithTitle:NSLocalizedString(@"SwitchRenameFail", nil)];
            }else{
                if (serail == 1) {
                    weak_self.firstView.title = name;
                }else if (serail == 2){
                    weak_self.secondView.title = name;
                }else if (serail == 3){
                    weak_self.thirdView.title = name;
                }else if (serail == 4){
                    weak_self.forthView.title = name;
                }
            }
            weak_self.reNameView.hidden = true;
            [weak_self.view endEditing:true];
        };
    }
    return _reNameView;
}

- (UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WITDH, 50)];
        _bottomView.backgroundColor = [UIColor grayColor];
        _bottomView.alpha  = 0.3;
    }
    return _bottomView;
}

- (ExternalView *)firstView
{
    @weakify(self);
    if (!_firstView) {
        _firstView = [[ExternalView alloc] initWithFrame:CGRectMake(0, 100, SCREEN_WITDH, (SCREEN_HEIGHT-100-IPHONEBottom)/4.5)];
        _firstView.serial = 1;
        _firstView.cliekDeviceHandler = ^(BOOL selected){
            [weak_self cn_startai_switchControl:0 onoff:selected];
        };
        _firstView.changeNameHandler = ^(NSInteger serial) {
            weak_self.reNameView.hidden = false;
            weak_self.reNameView.serial = serial;
            weak_self.reNameView.title = weak_self.firstView.nameBtn.titleLabel.text;
        };
    }
    return _firstView;
}

- (ExternalView *)secondView
{
    @weakify(self);
    if (!_secondView) {
        _secondView = [[ExternalView alloc] initWithFrame:CGRectMake(0, self.firstView.bottom, SCREEN_WITDH, (SCREEN_HEIGHT-100-IPHONEBottom)/4.5)];
        _secondView.serial = 2;
        _secondView.cliekDeviceHandler = ^(BOOL selected){
            [weak_self cn_startai_switchControl:1 onoff:selected];
        };
        _secondView.changeNameHandler = ^(NSInteger serial) {
            weak_self.reNameView.hidden = false;
            weak_self.reNameView.serial = serial;
            weak_self.reNameView.title = weak_self.secondView.nameBtn.titleLabel.text;
        };
    }
    return _secondView;
}

- (ExternalView *)thirdView
{
    @weakify(self);
    if (!_thirdView) {
        _thirdView = [[ExternalView alloc] initWithFrame:CGRectMake(0, self.secondView.bottom, SCREEN_WITDH, (SCREEN_HEIGHT-100-IPHONEBottom)/4.5)];
        _thirdView.serial = 3;
        _thirdView.cliekDeviceHandler = ^(BOOL selected){
            [weak_self cn_startai_switchControl:2 onoff:selected];
        };
        _thirdView.changeNameHandler = ^(NSInteger serial) {
            weak_self.reNameView.hidden = false;
            weak_self.reNameView.serial = serial;
            weak_self.reNameView.title = weak_self.thirdView.nameBtn.titleLabel.text;
        };
    }
    return _thirdView;
}

- (ExternalView *)forthView
{
    @weakify(self);
    if (!_forthView) {
        _forthView = [[ExternalView alloc] initWithFrame:CGRectMake(0, self.thirdView.bottom, SCREEN_WITDH, (SCREEN_HEIGHT-100-IPHONEBottom)/4.5)];
        _forthView.serial = 4;
        _forthView.cliekDeviceHandler = ^(BOOL selected){
            [weak_self cn_startai_switchControl:3 onoff:selected];
        };
        _forthView.changeNameHandler = ^(NSInteger serial) {
            weak_self.reNameView.hidden = false;
            weak_self.reNameView.serial = serial;
            weak_self.reNameView.title = weak_self.forthView.nameBtn.titleLabel.text;
        };
    }
    return _forthView;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:true];
}

-(void)leftAction
{
    [self.navigationController popViewControllerAnimated:true];
}

- (void)cn_startai_switchControl:(NSInteger)index onoff:(BOOL)state
{
    //高四位表示继电器序号
    //低四位表示继电器状态 1 开启 0断开
    UInt8 da = (index)*16+state;
    NSData *data = [NSData dataWithBytes:&da length:sizeof(da)];
    int key = [appDelegate.globalManager buildKey:SET cmdID:0x81];
    if (key != -1) {
        [appDelegate.globalManager sendCustomCommand:key param1:0x66 param2:1 others:data];
        [self cn_startai_queFlash];
    }
    
    NSLog(@"==继电器序号===%d=====状态======%d======",index,state);
}

#pragma  mark GlobalDelegate

- (void)managerReady
{
    
}

- (void)modeChanged:(UInt32)mode
{
    
}

#pragma mark 音箱音效模式变化
-(void)soundEffectChanged:(UInt32)mode
{
    
}

#pragma mark  EQ模式变化
-(void)eqModeChanged:(UInt32)mode
{
    
}

#pragma mark 音箱电池电量或充放电状态变化
-(void)batteryChanged:(UInt32)battery charging:(BOOL)charging
{
    
}

#pragma mark 音箱静音及音量状态变化
-(void)volumeChanged:(UInt32)current max:(UInt32)max min:(UInt32)min isMute:(BOOL)mute
{
    appDelegate.currentVoice = current;
    appDelegate.maxVoice = max;
     [[NSNotificationCenter defaultCenter] postNotificationName:@"speakerVolumeChange" object:nil];
}

#pragma mark 音箱外置卡插拔状态变化
-(void)hotplugCardChanged:(BOOL)visibility
{
}


#pragma mark 音箱外置U盘插拔状态变化
-(void)hotplugUhostChanged:(BOOL)visibility
{
    appDelegate.canUseUSB = visibility;
}

#pragma mark USB线插拔状态变化
-(void)hotplugUSBChanged:(BOOL)visibility
{
    
}

#pragma mark 音箱Linein连接线插拔状态变化
-(void)lineinChanged:(BOOL)visibility
{
    
}

#pragma mark 显示音箱对话框
-(void)dialogMessageArrived:(UInt32)type messageID:(UInt32)messageId
{
    
}

#pragma mark 显示音箱提示信息
-(void)toastMessageArrived:(UInt32)messageId
{
    
}

#pragma mark 取消音箱提示信息
-(void)dialogCancel
{
    
}

#pragma mark DAE音效模式变化
-(void)daeModeChangedWithVBASS:(BOOL)vbassEnable andTreble:(BOOL)trebleEnable
{
    
}

#pragma mark DAE音效模式变化
-(void)daeModeChangedWithVBASS:(BOOL)vbassEnable treble:(BOOL)trebleEnable surround:(BOOL)surroundEnable
{
    
}

#pragma mark DAE音效模式变化
-(void)daeModeChanged:(int)daeOpts
{
    
}

-(void)customCommandArrived:(UInt32)cmdKey param1:(UInt32)arg1 param2:(UInt32)arg2 others:(NSData*)data
{
//    self.firstView.onOffState = false;
//    self.secondView.onOffState = false;
//    self.thirdView.onOffState = false;
//    self.forthView.onOffState = false;
    
    NSLog(@"-----------------%d-----------------",arg2);
    
    NSString *str = [self getBinaryByDecimal:arg2];
    if (!str.length) {
        str = @"0000";
    }
    
    NSInteger str1 = [[str substringWithRange:NSMakeRange(0, 1)] integerValue];
    NSInteger str2 = [[str substringWithRange:NSMakeRange(1, 1)] integerValue];
    NSInteger str3 = [[str substringWithRange:NSMakeRange(2, 1)] integerValue];
    NSInteger str4 = [[str substringWithRange:NSMakeRange(3, 1)] integerValue];
    
    if (str1 == 0) {
        self.forthView.onOffState = 0;
    }else{
        self.forthView.onOffState = 1;
    }
    
    if (str2 == 0) {
        self.thirdView.onOffState = 0;
    }else{
        self.thirdView.onOffState = 1;
    }
    if (str3 == 0) {
        self.secondView.onOffState = 0;
    }else{
        self.secondView.onOffState = 1;
    }
    if (str4 == 0) {
        self.firstView.onOffState = 0;
    }else{
        self.firstView.onOffState = 1;
    }

}

- (NSString *)getBinaryByDecimal:(NSInteger)decimal {
    
    NSString *binary = @"";
    while (decimal) {
        binary = [[NSString stringWithFormat:@"%ld", decimal % 2] stringByAppendingString:binary];
        if (decimal / 2 < 1) {
            
            break;
        }
        decimal = decimal / 2 ;
    }
    if (binary.length % 4 != 0) {
        
        NSMutableString *mStr = [[NSMutableString alloc]init];;
        for (int i = 0; i < 4 - binary.length % 4; i++) {
            
            [mStr appendString:@"0"];
        }
        binary = [mStr stringByAppendingString:binary];
    }
    return binary;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
