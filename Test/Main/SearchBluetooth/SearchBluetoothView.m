//
//  SearchBluetoothView.m
//  Test
//
//  Created by Mac on 2017/12/15.
//  Copyright © 2017年 QiXing. All rights reserved.
//

#import "SearchBluetoothView.h"

@interface SearchBluetoothView ()
{
    NSInteger currentIndex;
}

@property (nonatomic, strong) UIImageView *pullView;
@property (nonatomic, strong) UIImageView *dropDownView;
@property (nonatomic, strong) UIImageView *backGroundView;
@property (nonatomic, strong) UIImageView *speakerView;
@property (nonatomic, strong) UIButton *phoneBtn;
@property (nonatomic, strong) UIButton *wifiView;
@property (nonatomic, strong) UILabel *pdidLabel;
@property (nonatomic, strong) UILabel *modelLabel;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation SearchBluetoothView

- (void)dealloc
{
    [self stopTimer];
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
    [self addSubview:self.pullView];
    [self addSubview:self.backGroundView];
    [self addSubview:self.dropDownView];
    [self addSubview:self.speakerView];
    [self addSubview:self.phoneBtn];
    [self addSubview:self.wifiView];
    [self addSubview:self.modelLabel];
    [self wifiAnimation];
    [self goToAnimation];
    currentIndex = 1;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(handleTimer:) userInfo:nil repeats:true];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (UIImageView *)pullView
{
    if (!_pullView) {
        _pullView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WITDH, (SCREEN_WITDH/720.0)*57+1)];
        _pullView.image = [UIImage imageNamed:@"Pull"];
    }
    return _pullView;
}

- (UIImageView *)dropDownView
{
    if (!_dropDownView) {
        _dropDownView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (SCREEN_WITDH/720.0)*57+IPHONEBottom, SCREEN_WITDH, (SCREEN_WITDH/720.0)*149)];
        _dropDownView.image = [UIImage imageNamed:@"Dropdown"];
    }
     return _dropDownView;
}

-(UIImageView *)backGroundView
{
    if (!_backGroundView) {
        _backGroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (SCREEN_WITDH/720.0)*57, SCREEN_WITDH+1, SCREEN_HEIGHT)];
        [_backGroundView setImage:[UIImage imageNamed:@"SearchBluetoothBackGround"]];
        [_backGroundView setContentMode:UIViewContentModeScaleAspectFill];
    }
    return _backGroundView;
}

- (UIButton *)phoneBtn
{
    if (!_phoneBtn) {
        _phoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _phoneBtn.frame = CGRectMake((SCREEN_WITDH-50)/2.0, 200, 50, 105);
        [_phoneBtn setBackgroundImage:[UIImage imageNamed:@"PhoneNotConnected"] forState:UIControlStateNormal];
        [_phoneBtn addTarget:self action:@selector(connectedBluetooth) forControlEvents:UIControlEventTouchUpInside];
    }
    return _phoneBtn;
}

- (UIButton *)wifiView
{
    if (!_wifiView) {
        _wifiView = [[UIButton alloc] initWithFrame:CGRectMake(self.phoneBtn.right+10, self.phoneBtn.bottom+30, 25, 25)];
        [_wifiView setBackgroundImage:[UIImage imageNamed:@"BluetoothNotConnected"] forState:UIControlStateNormal];
        [_wifiView addTarget:self action:@selector(connectedBluetooth) forControlEvents:UIControlEventTouchUpInside];
    }
    return _wifiView;
}

- (UILabel *)modelLabel
{
    if (!_modelLabel) {
        _modelLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WITDH, 30)];
        _modelLabel.text = @"Model--------";
        _modelLabel.textColor = [UIColor colorWithHexColorString:@"ffffff"];
        _modelLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _modelLabel;
}

- (UIImageView *)speakerView
{
    if (!_speakerView) {
        _speakerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - (SCREEN_WITDH/1080.0 *550) + (SCREEN_WITDH/720.0)*57, SCREEN_WITDH, (SCREEN_WITDH/1080.0 *550))];
        _speakerView.backgroundColor = [UIColor clearColor];
    }
    return _speakerView;
}

- (void)setConnected:(BOOL)connected
{
    _connected = connected;
    if (connected) {
        [self.wifiView.layer removeAnimationForKey:@"Animation"];
        [_phoneBtn setBackgroundImage:[UIImage imageNamed:@"PhoneConnected"] forState:UIControlStateNormal];
        [_wifiView setBackgroundImage:[UIImage imageNamed:@"BluetoothConnected"] forState:UIControlStateNormal];
    }else{
        [self wifiAnimation];
        [_phoneBtn setBackgroundImage:[UIImage imageNamed:@"PhoneNotConnected"] forState:UIControlStateNormal];
         [_wifiView setBackgroundImage:[UIImage imageNamed:@"BluetoothNotConnected"] forState:UIControlStateNormal];
    }
}

- (void)setIsPull:(BOOL)isPull
{
    _isPull = isPull;
    if (isPull) {
        self.pullView.hidden = false;
        self.dropDownView.hidden = true;
    }else{
        self.pullView.hidden = true;
        self.dropDownView.hidden = false;
    }
}

- (void)setModelText:(NSString *)modelText
{
    [self.wifiView.layer removeAllAnimations];
    if (modelText.length) {
        self.modelLabel.text = modelText;
        self.modelLabel.textColor = [UIColor colorWithHexColorString:@"00ffff"];
        
    }else{
        self.modelLabel.text = @"Model--------";
        self.modelLabel.textColor = [UIColor colorWithHexColorString:@"ffffff"];
        [self wifiAnimation];
    }
}

- (void)connectedBluetooth
{
    if (self.connectedPeripheral) {
        self.connectedPeripheral();
    }
}

- (void)wifiAnimation
{
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 1.5;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.5, 0.5, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.5, 1.5, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.5, 0.5, 1.0)]];
    animation.values = values;
    animation.repeatCount = MAXFLOAT;
    animation.removedOnCompletion = false;
    [self.wifiView.layer addAnimation:animation forKey:@"Animation"];
}

- (void)handleTimer:(NSTimer *)timer
{
    NSInteger index = currentIndex;
    if (currentIndex > 32) {
        index = 65 - currentIndex;
    }

    NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%ld",index] ofType:@"png"];
    self.speakerView.image = [UIImage imageWithContentsOfFile:path];//[UIImage imageNamed:[NSString stringWithFormat:@"%ld",currentIndex]];
    currentIndex ++;
    if (currentIndex>64) {
        currentIndex = 1;
    }
}

- (void)stopTimer
{
    [self.timer invalidate];
    self.timer = nil;
}

-(void)goToAnimation
{
//    NSMutableArray *imgArr = [NSMutableArray array];
//    for (NSInteger i = 1; i<64; i++) {
//        NSInteger index = i;
//        if (i > 32) {
//            index = 65 - i;
//        }
////        NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%ld",i] ofType:@"png"];
//        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld",index]];
//        [imgArr addObject:image];
//    }
//    self.speakerView.animationImages = imgArr;
//    self.speakerView.animationDuration = 8;
//    self.speakerView.animationRepeatCount = MAXFLOAT;
//    [self.speakerView startAnimating];
}
@end
