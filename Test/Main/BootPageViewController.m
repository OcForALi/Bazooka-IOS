//
//  BootPageViewController.m
//  Test
//
//  Created by Mac on 2017/10/13.
//  Copyright © 2017年 QiXing. All rights reserved.
//

#import "BootPageViewController.h"

@interface BootPageViewController ()
{
    NSInteger num;
}
@property (nonatomic, strong) UIImageView *backGroundView;
@property (nonatomic, strong) UIImageView *logoView;
@property (nonatomic, strong) UILabel *sloganView;
@property (nonatomic, strong) UILabel *welcomeView;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation BootPageViewController

- (void)dealloc
{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self cn_startai_initContentView];
}

- (void)cn_startai_initContentView
{
    [self.view addSubview:self.backGroundView];
    [self.view addSubview:self.logoView];
    [self.view addSubview:self.sloganView];
    [self.view addSubview:self.welcomeView];
    num = 0;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(numChange) userInfo:nil repeats:true];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)numChange
{
    NSString *title = @"LET THE PARTY BEGIN";
    if (num > title.length){
        [_timer invalidate];
        _timer = nil;
        [UIView animateWithDuration:1 animations:^{
            self.logoView.alpha = 0.1;
            self.sloganView.alpha = 0.1;
            self.welcomeView.alpha = 0.1;
        } completion:^(BOOL finished) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"MainAnimation" object:nil];
            self.view.hidden = true;
            [self.view removeFromSuperview];
        }];
    }else{
    self.welcomeView.text = [title substringToIndex:num];
    num++;
    }
}

- (UIImageView *)backGroundView
{
    if (!_backGroundView) {
        _backGroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WITDH, SCREEN_HEIGHT)];
        _backGroundView.contentMode = UIViewContentModeScaleToFill;
        _backGroundView.image = [UIImage imageNamed:@"BootBackGround"];
    }
    return _backGroundView;
}

- (UIImageView *)logoView
{
    if (!_logoView) {
        _logoView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WITDH-492/2.0)/2.0, 125, 492/2.0, 137/2.0)];
        _logoView.image = [UIImage imageNamed:@"logo"];
    }
    return _logoView;
}

- (UILabel *)sloganView
{
    if (!_sloganView) {
        _sloganView = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-150-IPHONEBottom, SCREEN_WITDH, 30)];
        _sloganView.text = @"PartyBar Control Application";
        _sloganView.font = [UIFont fontWithName:@"Source Sans Pro" size:24];
        _sloganView.font = [UIFont boldSystemFontOfSize:24];
        _sloganView.textColor = [UIColor whiteColor];
        _sloganView.textAlignment = NSTextAlignmentCenter;
//        _sloganView.hidden =true;
    }
    return _sloganView;
}

- (UILabel *)welcomeView
{
    if (!_welcomeView) {
        _welcomeView = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-100-IPHONEBottom, SCREEN_WITDH, 50)];
        _welcomeView.text = @"";//@"LET THE PARTY BEGIN";
        _welcomeView.font = [UIFont fontWithName:@"Impact" size:24];
        _welcomeView.font = [UIFont boldSystemFontOfSize:24];
        _welcomeView.textColor = [UIColor whiteColor];
        _welcomeView.textAlignment = NSTextAlignmentCenter;
//        _welcomeView.hidden = true;
    }
    return _welcomeView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
