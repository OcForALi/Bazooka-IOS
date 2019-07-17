//
//  BTWheelColorViewController.m
//  BTMate
//
//  Created by Mac on 2017/8/18.
//  Copyright © 2017年 QiXing. All rights reserved.
//

#import "BTWheelColorViewController.h"
#import "UIImage+ColorSelect.h"
#import "BTWheelColorNav.h"
#import "BTWheelColorViewMask.h"
#import "BTWheelRGBEntity.h"
#import "BTSeqListViewController.h"
#import "BTWheelSliderView.h"
#import "BTSaveSeqListEntity.h"
#import "BTSeqListCellEntity.h"
#import "UIView+ColorSelect.h"
#import "BTWheelPickColorView.h"
#import "BTWheelPickColorCarbon.h"
#import "PopView.h"

@interface BTWheelColorViewController ()<UIGestureRecognizerDelegate,GlobalDelegate>
{
    AppDelegate *appDelegate;
}
@property (nonatomic, strong) BTWheelColorNav *navBar;          //导航栏
@property (nonatomic, strong) BTWheelColorViewMask *colorMask;      //颜色手动输入遮罩
@property (nonatomic, strong) BTWheelPickColorView *pickView;   //颜色滑动选择器
@property (nonatomic, strong) BTWheelPickColorCarbon *colorCarbon;  //颜色副本 FM连接蓝牙下的

@property (nonatomic, strong) UIImageView  *sourceImgView;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, strong) UIButton *demoBtn;
@property (nonatomic, strong) UIButton *onOffBtn;
@property (nonatomic, strong) BTWheelSliderView *sliderView;    //亮度 速度 切换闪法
@property (nonatomic, strong) UIImageView *yuanxinView;
@property (nonatomic, strong) NSMutableArray *dataArr;          //M模式切换闪法存储的闪法列表名称
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) PopView *noPairPop;          //未匹配蓝牙提示

@property (nonatomic, assign) BOOL firstBool;

@end

@implementation BTWheelColorViewController

- (void)cn_startai_registerAppDelegate:(AppDelegate *)delegate mode:(uint32_t)mode
{
    appDelegate = delegate;
    appDelegate.globalManager = [appDelegate.mMediaManager getGlobalManager:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    if (appDelegate.player.player.rate == 1) {
//        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
//    }else{
//        [[AVAudioSession sharedInstance] setActive:true error:nil];
//    }

    [self cn_startai_getSaveList];
    [self cn_startai_queFlash];
    appDelegate.globalManager = [appDelegate.mMediaManager getGlobalManager:self];
    
    [self.navBar updateNavgation];
    
//    [self.sliderView updateSliderView];
    if (appDelegate.conncetType == BAZ_G2_FM) {
        self.pickView.hidden = true;
        self.sourceImgView.hidden = true;
        self.yuanxinView.hidden = true;
        self.colorCarbon.hidden = false;
        self.tapGesture.enabled = false;
        self.isFM = NO;
//        self.sourceImgView.frame = CGRectMake((SCREEN_WITDH-(SCREEN_WITDH-120))/2.0, self.navBar.bottom + 33, (SCREEN_WITDH-120), (SCREEN_WITDH-120));
//        self.sourceImgView.layer.cornerRadius = (SCREEN_WITDH-120)/2.0;
//        self.sourceImgView.image = [UIImage imageNamed:@"pickerColorWheelG2"];
        NSMutableArray *arr = [NSMutableArray array];
        for (NSString *name in self.dataArr) {
            if (![name containsString:@"FLASH"]) {
                [arr addObject:name];
            }
        }
        self.sliderView.dataArr = arr;
    }else{
        self.tapGesture.enabled = true;
        self.colorCarbon.hidden = true;
        self.pickView.hidden = false;
        self.sourceImgView.hidden = false;
        self.yuanxinView.hidden = false;
//        self.sourceImgView.frame = CGRectMake((SCREEN_WITDH-(SCREEN_WITDH-80))/2.0, self.navBar.bottom + 33, (SCREEN_WITDH-80), (SCREEN_WITDH-80));
        self.sourceImgView.layer.cornerRadius = (SCREEN_WITDH-80)/2.0;
        self.sourceImgView.image = [UIImage imageNamed:@"pickerColorWheel"];
        self.sliderView.dataArr = self.dataArr;
        self.isFM = YES;
    }
    
    self.firstBool = NO;
    
    //默认灯光光亮度与闪烁速度为0.5
    [self cn_startai_setBrightnessWithValue:0.5];
    [self cn_startai_setSpeedWithValue:0.5];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)cn_startai_queFlash
{
    int key = [appDelegate.globalManager buildKey:QUE cmdID:0x98];
    if (key != -1) {
        [appDelegate.globalManager sendCustomCommand:key param1:0 param2:0 others:nil];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.userInteractionEnabled = YES;
    
    [self cn_startai_initContentView];
}

- (void)cn_startai_initContentView
{
    [self.view addSubview:self.sourceImgView];
    [self.view addSubview:self.yuanxinView];
    [self.view addSubview:self.navBar];
    [self.view addSubview:self.pickView];
    [self.view addSubview:self.colorCarbon];
    [self.view addGestureRecognizer:self.tapGesture];

    [self.view addSubview:self.sliderView];
    
    [self.view addSubview:self.demoBtn];
    [self.view addSubview:self.onOffBtn];
    
    [self.view addSubview:self.maskView];
//    [self.view addSubview:self.colorMask];
    [self.maskView addSubview:self.noPairPop];

}

-(BTWheelColorNav *)navBar
{
    __weak typeof(self) weakSelf = self;
    if (!_navBar) {
        _navBar = [[BTWheelColorNav alloc] initWithFrame:CGRectMake(0, IPHONEFringe + 40, SCREEN_WITDH, 44)];
        _navBar.colorhandler = ^{
            weakSelf.maskView.hidden = NO;
            weakSelf.colorMask.hidden = NO;
            weakSelf.tapGesture.enabled = NO;
            weakSelf.sliderView.isPopup = YES;
            [weakSelf.onOffBtn setBackgroundImage:[UIImage imageNamed:@"onoff"] forState:UIControlStateNormal];
            [weakSelf.demoBtn setBackgroundImage:[UIImage imageNamed:@"demo"] forState:UIControlStateNormal];
        };
        _navBar.menuHandler = ^{
            BTSeqListViewController *seqVC = [[BTSeqListViewController alloc] init];
            [seqVC cn_startai_registerAppDelegate:appDelegate mode:0];
//            seqVC.seqTitle = weakSelf.sliderView.seqLabel.text;
            [weakSelf.navigationController pushViewController:seqVC animated:YES];
        };
        _navBar.popHandler = ^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        };
    }
    return _navBar;
}

- (BTWheelPickColorView *)pickView
{
    @weakify(self);
    if (!_pickView) {
        _pickView = [[BTWheelPickColorView alloc] initWithFrame:CGRectMake(50,IPHONEFringe +40, SCREEN_WITDH-100, (SCREEN_WITDH-100)*(93/494.0))];
        _pickView.colorHandle = ^(BTWheelRGBEntity *rgb) {
            int key = [appDelegate.globalManager buildKey:SET cmdID:0x81];
            if (key != -1) {
                
                UInt8 red = (UInt8)rgb.red ;
                UInt8 greeen = (UInt8)rgb.green;
                UInt8 blue = (UInt8)rgb.blue;
                NSMutableData *colorData = [NSMutableData data];
                [colorData appendBytes:&red length:sizeof(red)];
                [colorData appendBytes:&greeen length:sizeof(greeen)];
                [colorData appendBytes:&blue length:sizeof(blue)];
                
                [appDelegate.globalManager sendCustomCommand:key param1:0x62 param2:3 others:colorData];
                [weak_self cn_startai_queFlash];
            }
        };
    }
    return _pickView;
}

- (UIView *)maskView
{
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:self.view.bounds];
        _maskView.backgroundColor = [UIColor colorWithHexColorString:@"000000" withAlpha:0.7];
        _maskView.hidden = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cn_startai_hideMask)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        [_maskView addGestureRecognizer:tap];
    }
    return _maskView;
}

- (BTWheelColorViewMask *)colorMask
{
    __weak typeof(self) weakSelf = self;
    if (!_colorMask) {
        _colorMask = [[BTWheelColorViewMask alloc] initWithFrame:CGRectMake(30, (SCREEN_HEIGHT-360)/2.0, SCREEN_WITDH-60, 300)];
        _colorMask.hidden = YES;
        _colorMask.backgroundColor = [UIColor whiteColor];
        _colorMask.cancleHandle = ^(BTWheelRGBEntity *rgb){
            if (rgb) {
                [weakSelf.navBar updateColorValueWithRed:rgb.red Green:rgb.green Blue:rgb.blue];
            }
            int key = [appDelegate.globalManager buildKey:SET cmdID:0x81];
            if (key != -1) {
                
                UInt8 red = (UInt8)rgb.red ;
                UInt8 greeen = (UInt8)rgb.green;
                UInt8 blue = (UInt8)rgb.blue;
                NSMutableData *colorData = [NSMutableData data];
                [colorData appendBytes:&red length:sizeof(red)];
                [colorData appendBytes:&greeen length:sizeof(greeen)];
                [colorData appendBytes:&blue length:sizeof(blue)];
                
                [appDelegate.globalManager sendCustomCommand:key param1:0x62 param2:3 others:colorData];
                [self cn_startai_queFlash];
            }
            weakSelf.colorMask.hidden = YES;
            weakSelf.tapGesture.enabled = YES;
            weakSelf.maskView.hidden = YES;
            weakSelf.sliderView.isPopup = NO;
            [weakSelf.onOffBtn setBackgroundImage:[UIImage imageNamed:@"onoffSelected"] forState:UIControlStateNormal];
            [weakSelf.demoBtn setBackgroundImage:[UIImage imageNamed:@"demoSelected"] forState:UIControlStateNormal];
        };
    }
    return _colorMask;
}

- (UIImageView *)sourceImgView
{
    if (!_sourceImgView) {
        _sourceImgView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WITDH-(SCREEN_WITDH-80))/2.0,
                                                                       self.navBar.bottom + 33,
                                                                       (SCREEN_WITDH-80),
                                                                       (SCREEN_WITDH-80))];
        _sourceImgView.image = [UIImage imageNamed:@"pickerColorWheel"];
        _sourceImgView.layer.borderWidth = 0;
        _sourceImgView.userInteractionEnabled = true;
        _sourceImgView.layer.masksToBounds = true;
        _sourceImgView.layer.cornerRadius = (SCREEN_WITDH-80)/2.0;
    }
    return _sourceImgView;
}

- (UIImageView *)yuanxinView
{
    if (!_yuanxinView) {
        _yuanxinView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 41, 41)];
        _yuanxinView.image = [UIImage imageNamed:@"yuanxin"];
        _yuanxinView.center = self.sourceImgView.center;
    }
    return _yuanxinView;
}

- (BTWheelPickColorCarbon *)colorCarbon
{
    __weak typeof(self) weakSelf = self;
    if (!_colorCarbon) {
        
        _colorCarbon = [[BTWheelPickColorCarbon alloc] initWithFrame:CGRectMake((SCREEN_WITDH-SCREEN_WITDH * 0.8)/2.0,
                                                                                self.navBar.bottom + 33, SCREEN_WITDH * 0.8, SCREEN_WITDH * 0.8)];
        _colorCarbon.hidden = true;
        _colorCarbon.getColorHanlder = ^(NSArray * _Nonnull colorArr) {
            [weakSelf sendColorChange:colorArr];
        };
    }
    return _colorCarbon;
}

- (UITapGestureRecognizer *)tapGesture
{
    if(!_tapGesture){
        _tapGesture =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectColorAction:)];
        _tapGesture.numberOfTapsRequired = 1;
        _tapGesture.numberOfTouchesRequired = 1;
    }
    return _tapGesture;
}

- (UIButton *)demoBtn
{
    if (!_demoBtn) {
        _demoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _demoBtn.frame = CGRectMake(28, self.navBar.bottom + 33 + SCREEN_WITDH * 0.81, 34.5*1.2, 34*1.2);
        [_demoBtn setBackgroundImage:[UIImage imageNamed:@"demoSelected"] forState:UIControlStateNormal];
        [_demoBtn setBackgroundImage:[UIImage imageNamed:@"demoClick"] forState:UIControlStateHighlighted];
        [_demoBtn addTarget:self action:@selector(cn_startai_demoClick) forControlEvents:UIControlEventTouchUpInside];
        _demoBtn.selected = false;
    }
    return _demoBtn;
}

-(UIButton *)onOffBtn
{
    if (!_onOffBtn) {
        _onOffBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _onOffBtn.frame = CGRectMake(SCREEN_WITDH-28-34.5, self.navBar.bottom + 33 + SCREEN_WITDH * 0.81, 34.5*1.2, 34*1.2);
        [_onOffBtn setBackgroundImage:[UIImage imageNamed:@"onoffSelected"] forState:UIControlStateNormal];
        [_onOffBtn setBackgroundImage:[UIImage imageNamed:@"onClick"] forState:UIControlStateSelected];
        [_onOffBtn addTarget:self action:@selector(cn_startai_onOffClick) forControlEvents:UIControlEventTouchUpInside];
        _onOffBtn.selected = true;
    }
    return _onOffBtn;
}

- (BTWheelSliderView *)sliderView
{
    @weakify(self);
    CGFloat heigth = IS_IPHONE_5_OR_LESS ? 180 : 220;
    if (!_sliderView) {
        _sliderView = [[BTWheelSliderView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-heigth-IPHONEBottom, SCREEN_WITDH, heigth)];
        _sliderView.BrightnessValueHandler = ^(CGFloat value) {
            if (value>0.1 && value<1){
                [weak_self cn_startai_setBrightnessWithValue:value];
            }
        };
        _sliderView.ChromaValueHandler = ^(CGFloat value) {
            if (value>0.1 && value<1) {
                [weak_self cn_startai_setSpeedWithValue:value];
            }
        };
        _sliderView.ModelValueHandler = ^(NSString *flashName) {
            [weak_self cn_startai_setFlashWithName:flashName];
        };
        
    }
    return _sliderView;
}

- (PopView *)noPairPop
{
    CGFloat hei = IS_IPHONE_5_OR_LESS ? 250 : 335;
    @weakify(self);
    if (!_noPairPop) {
        _noPairPop = [[PopView alloc] initWithFrame:CGRectMake(20, (SCREEN_HEIGHT-hei)/2.0, SCREEN_WITDH-40, hei)];
        _noPairPop.backgroundColor = [UIColor whiteColor];
        _noPairPop.alpha = 0.7;
        _noPairPop.text = NSLocalizedString(@"PartybarNotPair", nil);
        _noPairPop.leftText = @"Cancel";
        _noPairPop.rightText = @"Setting";
        _noPairPop.leftHandler = ^{
            weak_self.maskView.hidden = true;
        };
        _noPairPop.rightHandler = ^{
            weak_self.maskView.hidden = true;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"GotoConnectPeripheral" object:nil];
            [weak_self.navigationController popViewControllerAnimated:false];
            
        };
    }
    return _noPairPop;
}

#pragma colorEvent
- (void)cn_startai_hideMask
{
    [self.view endEditing:YES];
    
    [_onOffBtn setBackgroundImage:[UIImage imageNamed:@"onoffSelected"] forState:UIControlStateNormal];
    [_demoBtn setBackgroundImage:[UIImage imageNamed:@"demoSelected"]
                        forState:UIControlStateNormal];
    self.sliderView.isPopup = NO;
    self.colorMask.hidden = YES;
    self.maskView.hidden = YES;
}

- (BOOL)point:(CGPoint)point inCircleRect:(CGRect)rect {
    CGFloat radius = rect.size.width/2.0;
    CGPoint center = CGPointMake(rect.origin.x + radius, rect.origin.y + radius);
    double dx = fabs(point.x - center.x);
    double dy = fabs(point.y - center.y);
    double dis = hypot(dx, dy);
    return dis <= radius;
}

//选择颜色
-(void)selectColorAction:(UITapGestureRecognizer *)sender{
    
    CGPoint tempPoint = [sender locationInView:self.view];
    if ([self point:tempPoint inCircleRect:self.sourceImgView.frame]) {
        [self finishedAction:tempPoint end:true];

    }
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    if (self.isFM == NO) {
        return;
    }
    UITouch *touch = [touches anyObject];
    CGPoint tempPoint = [touch locationInView:self.view];
    [self finishedAction:tempPoint end:false];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.isFM == NO) {
        return;
    }
    UITouch *touch = [touches anyObject];
    CGPoint tempPoint = [touch locationInView:self.view];
    [self finishedAction:tempPoint end:true];
    
}

#pragma mark 完成颜色选择发送颜色
-(void)finishedAction:(CGPoint)point end:(BOOL)end
{
//    if (!self.onOffBtn.selected) {
//        [self cn_startai_showToastWithTitle:NSLocalizedString(@"LedOff", nil)];
//        return;
//    }

    if ([self point:point inCircleRect:CGRectMake(self.sourceImgView.left+20,
                                          self.sourceImgView.top+20,
                                          self.sourceImgView.width-40,
                                          self.sourceImgView.height-40)] ) {
      
        self.yuanxinView.center = point;
        
        NSArray *colorArr = [self.view colorAtPixel:self.yuanxinView.center];
        
        [self.pickView updateColorValueWithRed:[colorArr[0] integerValue]
                                         Green:[colorArr[1] integerValue]
                                          Blue:[colorArr[2] integerValue]];
        
    }else if([self point:point inCircleRect:CGRectMake(self.sourceImgView.left,
                                                       self.sourceImgView.top,
                                                       self.sourceImgView.width,
                                                       self.sourceImgView.height)]){
        
    }else{
//        return;
    }
    
    NSArray *array = @[@(self.pickView.rgb.red),@(self.pickView.rgb.green),@(self.pickView.rgb.blue)];
    if (end) {
        [self sendColorChange:array];
    }
    
}

- (void)sendColorChange:(NSArray *)colorArr
{
    int key = [appDelegate.globalManager buildKey:SET cmdID:0x81];
    if (key != -1) {
        
        UInt8 red = (UInt8)[colorArr[0]integerValue];
        UInt8 greeen = (UInt8)[colorArr[1]integerValue];
        UInt8 blue = (UInt8)[colorArr[2]integerValue];
        NSMutableData *colorData = [NSMutableData data];
        [colorData appendBytes:&red length:sizeof(red)];
        [colorData appendBytes:&greeen length:sizeof(greeen)];
        [colorData appendBytes:&blue length:sizeof(blue)];
        if (appDelegate.conncetType == BAZ_G2_FM) {
//            if ((red>100 && red<255) &&
//                (greeen>100 && greeen<255 &&
//                 (blue>100 && blue<255))) {
                    NSLog(@"rgb色值-------------------%d,--------------------%d----------------------%d",red,greeen,blue);
            
            if (red == 0 && greeen == 0&& blue == 0) {
                return;
            }
            
                    [appDelegate.globalManager sendCustomCommand:key param1:0x62 param2:(UInt32)colorData.length others:colorData];
                    [self cn_startai_queFlash];
//                }
        }else{
            NSLog(@"rgb色值-------------------%d,--------------------%d----------------------%d",red,greeen,blue);
            [appDelegate.globalManager sendCustomCommand:key param1:0x62 param2:(UInt32)colorData.length others:colorData];
            [self cn_startai_queFlash];
        }
    }
}

#pragma mark 获取已存Seq列表

- (void)cn_startai_getSaveList
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDitrctory = [paths objectAtIndex:0];
    NSString *box = [documentDitrctory stringByAppendingPathComponent:@"sendBox"];
    if (!box) {
        [[NSFileManager defaultManager] createDirectoryAtPath:box withIntermediateDirectories:true attributes:nil error:nil];
    }
    NSString *path = [box stringByAppendingPathComponent:@"sendSeq.plist"];
    NSArray *dataArr = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithFile:path]];
    self.dataArr = [NSMutableArray array];
    
    for (BTSaveSeqListEntity *entity in dataArr) {
        [self.dataArr addObject:entity.title];
    }
    
    if (!self.dataArr.count) {
        NSArray *titleArr = @[@"DOME",@"GRADIENT",@"FADE1",@"FADE2",@"FADE3",@"FADE4",@"FADE5",@"FADE6",@"CHANGE1",@"CHANGE2",@"FLASH1",
                              @"FLASH2",@"FLASH3",@"FLASH4",@"FLASH5",@"FLASH6",@"FLASH7"];
        
        self.dataArr = [NSMutableArray arrayWithArray:titleArr];
    }

    self.sliderView.dataArr = self.dataArr;

}

#pragma mark 设置亮度
- (void)cn_startai_setBrightnessWithValue:(CGFloat)value
{
    int key = [appDelegate.globalManager buildKey:SET cmdID:0x81];
    UInt8 bright = value*100;
    NSData *data = [NSData dataWithBytes:&bright length:sizeof(bright)];
    if (key != -1) {
        NSLog(@"============亮度===============+%d",bright);
        [appDelegate.globalManager sendCustomCommand:key param1:0x63 param2:(UInt32)data.length others:data];
    }
}

#pragma mark 设置速度
- (void)cn_startai_setSpeedWithValue:(CGFloat)value
{
    int key = [appDelegate.globalManager buildKey:SET cmdID:0x81];
    UInt8 speed = (1-value)*100;
    NSData *data = [NSData dataWithBytes:&speed length:sizeof(speed)];
    if (key != -1) {
        NSLog(@"=============速度==============+%d",speed);
        [appDelegate.globalManager sendCustomCommand:key param1:0x64 param2:(UInt32)data.length others:data];
    }
}

#pragma mark 设置闪法

- (void)cn_startai_setFlashWithName:(NSString *)seqName
{
    
    [self.colorCarbon setReset];
    
    uint8_t index = 0;
    for (NSInteger i=0; i<self.dataArr.count; i++) {
        if ([seqName isEqualToString:self.dataArr[i]]) {
            index = i;
        }
    }
    NSLog(@"+++++++++++++闪法序号+++++++++++++++++++++++%d",index);
    int key = [appDelegate.globalManager buildKey:SET cmdID:0x81];
    NSData *data = [[NSData alloc] initWithBytes:&index length:sizeof(index)];
    NSMutableData *muData = [NSMutableData data];
    [muData appendData:data];
    if (key != -1) {
        [appDelegate.globalManager sendCustomCommand:key param1:0x65 param2:(UInt32)muData.length others:muData];
        [self cn_startai_queFlash];
    }
}

# pragma  mark - event

- (void)LedOff
{
    @weakify(self);
    UIAlertController *con = [UIAlertController alertControllerWithTitle:@"" message:NSLocalizedString(@"LedOff", nil) preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weak_self dismissViewControllerAnimated:true completion:nil];
    }];
    [con addAction:ok];
    [self presentViewController:con animated:true completion:^{
        
    }];
}

- (void)cn_startai_demoClick
{
    
    [self.colorCarbon setReset];
    
//    if (!self.onOffBtn.selected || !appDelegate.isConnected) {
//        [self LedOff];
//    }else{
//        self.demoBtn.selected = !self.demoBtn.selected;
        int key = [appDelegate.globalManager buildKey:SET cmdID:0x81];
        if (key != -1) {
            [appDelegate.globalManager sendCustomCommand:key param1:0x57 param2:0 others:nil];
        }
        [self cn_startai_queFlash];
//    }
}

- (void)cn_startai_onOffClick
{
    
    if (self.onOffBtn.selected == YES) {
        [self.colorCarbon setReset];
    }
    
    if (!appDelegate.isConnected) {
        self.maskView.hidden = false;
        return;
    }
    
    self.onOffBtn.selected = !self.onOffBtn.selected;
    int key = [appDelegate.globalManager buildKey:SET cmdID:0x81];
    if (key != -1) {
//        self.sliderView.slideError = !self.onOffBtn.selected;
        [appDelegate.globalManager sendCustomCommand:key param1:0x54 param2:0 others:nil];
        [self cn_startai_queFlash];
    }
}

- (void)cn_startai_showToastWithTitle:(NSString *)title
{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    hud.userInteractionEnabled = false;
    hud.mode = MBProgressHUDModeText;
    hud.label.text = title;
    hud.label.numberOfLines = 0;
    [self.view addSubview:hud];
    [hud showAnimated:true];
    [hud hideAnimated:true afterDelay:2.0];
}


- (void)managerReady
{
    
}

- (void)modeChanged:(UInt32)mode
{
    appDelegate.model = mode;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ModeChanged" object:[NSString stringWithFormat:@"%d",mode]];
    
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


-(void)customCommandArrived:(UInt32)cmdKey param1:(UInt32)arg1 param2:(UInt32)arg2 others:(NSData *)data
{
    
    if (arg1 == 64) {
        self.onOffBtn.selected = false;
//        self.demoBtn.selected = true;
    }else if (arg1 == 128){
        self.onOffBtn.selected = true;
//        self.demoBtn.selected = false;
    }else if (arg1 == 192){
        self.onOffBtn.selected = true;
//        self.demoBtn.selected = true;
    }else{
        self.onOffBtn.selected = false;
//        self.demoBtn.selected = false;
    }
    
    if (self.firstBool == NO) {
        
        self.firstBool = YES;
        
        if (arg1 == 64 || arg1 == 128 || arg1 == 192) {
            
        }else{
            
            int key = [appDelegate.globalManager buildKey:SET cmdID:0x81];
            if (key != -1) {
                //        self.sliderView.slideError = !self.onOffBtn.selected;
                [appDelegate.globalManager sendCustomCommand:key param1:0x54 param2:0 others:nil];
                [self cn_startai_queFlash];
                
            }
        }
        
    }
    
//    self.sliderView.slideError = !self.onOffBtn.selected;
    NSLog(@"===========灯的状态===============%u",(unsigned int)arg1);
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
