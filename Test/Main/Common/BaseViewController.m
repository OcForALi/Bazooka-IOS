//
//  BaseViewController.m
//  BluetoothBox
//
//  Created by Mac on 2017/9/14.
//  Copyright © 2017年 Actions. All rights reserved.
//

#import "BaseViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "AppDelegate.h"

@interface BaseViewController ()
{
    AppDelegate *appDelegate;
}
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) CGFloat angle;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UIButton *leftView;
@property (nonatomic, strong) UIButton *rightView;
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) CABasicAnimation *animation;
@property (nonatomic, strong) MPVolumeView *volumeView;
@end

@implementation BaseViewController

-(void)dealloc
{
    [_timer invalidate];
    _timer = nil;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    if (appDelegate.player.player.rate == 1) {
//        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
//    }else{
//        [[AVAudioSession sharedInstance] setActive:true error:nil];
//    }
    
//    if (!IS_IPHONE_X) {
//
//        [UIView animateWithDuration:0.25
//                         animations:^{
//                             if (CGRectGetHeight([[UIApplication sharedApplication] statusBarFrame]) > 20) {
//                                 self.view.height = SCREEN_HEIGHT - 20;
//                             } else {
//                                 self.view.height = SCREEN_HEIGHT;
//                            }
//                         }];
//
//    }

}



- (void)viewDidLoad {
    
    appDelegate = [UIApplication sharedApplication].delegate;
    [super viewDidLoad];
    [self controlVolume];
    [self.view addSubview:self.backGroundView];
    [self.view addSubview:self.navBg];
    [self.navBg addSubview:self.leftView];
    [self.navBg addSubview:self.rightView];
//    [self.navBg addSubview:self.logoView];
//    [self.view addSubview:self.line];
    [self.view addSubview:self.signView];
    [self.view addSubview:self.backBtn];
    [self.view addSubview:self.rightBtn];
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    //默认是顺时针效果，若将fromValue和toValue的值互换，则为逆时针效果
    animation.fromValue = [NSNumber numberWithFloat:0.f];
    animation.toValue = [NSNumber numberWithFloat: M_PI *2];
    animation.duration = 4;
    animation.autoreverses = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.repeatCount = MAXFLOAT; //如果这里想设置成一直自旋转，可以设置为MAXFLOAT，否则设置具体的数值则代表执行多少次
    animation.removedOnCompletion = false;
    [self.signView.layer addAnimation:animation forKey:nil];
     self.angle = 0.0;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(returnMain:) name:@"ReturnMain" object:nil];
}

- (void)returnMain:(NSNotification *)not{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

-(void)controlVolume
{
    
    _volumeView = [[MPVolumeView alloc]init];
    
    _volumeView.showsRouteButton = NO;
    //默认YES，这里为了突出，故意设置一遍
    _volumeView.showsVolumeSlider = false;
    
    [_volumeView sizeToFit];
    [_volumeView setFrame:CGRectMake(100, 100, 10, 10)];
    
    [self.view addSubview:_volumeView];
    [_volumeView userActivity];
    
    for (UIView *view in [_volumeView subviews]){
        if ([[view.class description] isEqualToString:@"MPVolumeSlider"]){
            _volumeSlider = (UISlider*)view;
            break;
        }
    }
    //设置默认打开视频时声音为0.3，如果不设置的话，获取的当前声音始终是0
//    [_volumeSlider setValue:0.3];

}


- (UIImageView *)navBg
{
    if (!_navBg) {
        _navBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WITDH, 79)];
        _navBg.contentMode = UIViewContentModeScaleAspectFill;
        _navBg.userInteractionEnabled = YES;
        _navBg.layer.masksToBounds = false;
        if (IS_IPHONE_X) {
            _navBg.image = [UIImage imageNamed:@"UIHeader196"];
        }else{
            _navBg.image = [UIImage imageNamed:@"UIHeader128"];
        }
    }
    return _navBg;
}

- (UIImageView *)logoView
{
    if (!_logoView) {
        _logoView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WITDH-164.5)/2.0,
                                                                IPHONEFringe + (79-45.5)/2.0, 164.5, 45.5)];
        _logoView.image = [UIImage imageNamed:@"logo"];
    }
    return _logoView;
}

- (UIButton *)leftView
{
    if (!_leftView) {
        _leftView = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftView.frame = CGRectMake(11, 22 + IPHONEFringe, 18, 25);
        [_leftView setBackgroundImage:[UIImage imageNamed:@"goBack"] forState:UIControlStateNormal];
        [_leftView addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftView;
}

- (UIButton *)rightView
{
    if (!_rightView) {
        _rightView = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightView.frame = CGRectMake(SCREEN_WITDH - 42, 22 + IPHONEFringe, 31, 31);
        [_rightView addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightView;
}

- (UIButton *)backBtn
{
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _backBtn.frame = CGRectMake(0, IPHONEFringe, 60, 79);
        [_backBtn addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (UIButton *)rightBtn
{
    if (!_rightBtn) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightBtn.frame = CGRectMake(SCREEN_WITDH-60, IPHONEFringe, 60, 79);
        [_rightBtn addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}

- (UIView *)line
{
    if (!_line) {
        _line = [[UIView alloc] initWithFrame:CGRectMake(0, self.navBg.bottom, SCREEN_WITDH, 0.5)];
        _line.backgroundColor = [UIColor colorWithHexColorString:@"dddddd"];
    }
    return _line;
}


- (UIImageView *)signView
{
    CGFloat top = IS_IPHONE_5_OR_LESS ? 180 : 200;
    if (!_signView) {
        _signView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WITDH-180)/2.0, IPHONEFringe+(top/1080.0)*SCREEN_HEIGHT, 180, 180)];
        _signView.contentMode = UIViewContentModeCenter;
        _signView.layer.cornerRadius = 90;
    }
    return _signView;
}

- (UIImageView *)backGroundView
{
    if (!_backGroundView) {
        _backGroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WITDH, SCREEN_HEIGHT)];
        _backGroundView.contentMode = UIViewContentModeScaleAspectFill;
        _backGroundView.clipsToBounds = YES;
        _backGroundView.image = [UIImage imageNamed:@"MainBackGround"];
    }
    return _backGroundView;
}

- (void)leftAction
{

}

- (void)rightAction
{

}

- (void)setLeftImg:(UIImage *)leftImg
{
    [self.leftView setBackgroundImage:leftImg forState:UIControlStateNormal];
}

- (void)setRightImg:(UIImage *)rightImg
{
    [self.rightView setImage:rightImg forState:UIControlStateNormal];
}

- (void)setLogo:(UIImage *)logo
{
    self.signView.image = logo;
    self.signView.backgroundColor = [UIColor colorWithHexColorString:@"ffffff" withAlpha:0.5];

}

- (void)cn_startai_showToastWithTitle:(NSString *)title
{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    hud.userInteractionEnabled = false;
    hud.mode = MBProgressHUDModeText;
    hud.label.text = title;
    hud.label.numberOfLines = 0;
    [[self lastWindow] addSubview:hud];
    [hud showAnimated:true];
    [hud hideAnimated:true afterDelay:2.0];
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
    
    return [UIApplication sharedApplication].keyWindow;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
