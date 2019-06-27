//
//  BaseNavView.m
//  BluetoothBox
//
//  Created by Mac on 2017/9/21.
//  Copyright © 2017年 Actions. All rights reserved.
//

#import "BaseNavView.h"

@interface BaseNavView ()

@property (nonatomic, strong) UIImageView *navBg;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UIButton *leftView;
@property (nonatomic, strong) UIButton *rightView;
@property (nonatomic, strong) UIImageView *logoView;
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UIButton *rightBtn;

@end

@implementation BaseNavView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self cn_startai_initContentView];
    }
    return self;
}

- (void)cn_startai_initContentView
{
    [self addSubview:self.navBg];
    [self.navBg addSubview:self.leftView];
    [self.navBg addSubview:self.rightView];
    [self.navBg addSubview:self.logoView];
    [self.navBg addSubview:self.backBtn];
    [self.navBg addSubview:self.rightBtn];
    [self addSubview:self.line];
}

- (UIImageView *)navBg
{
    if (!_navBg) {
        _navBg = [[UIImageView alloc] initWithFrame:self.bounds];
        _navBg.backgroundColor = [UIColor whiteColor];
        _navBg.userInteractionEnabled = YES;
        _navBg.layer.masksToBounds = true;
    }
    return _navBg;
}

- (UIImageView *)logoView
{
    if (!_logoView) {
        _logoView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WITDH-164.5)/2.0, (64-45.5)/2.0, 164.5, 45.5)];
    }
    return _logoView;
}

- (UIButton *)leftView
{
    if (!_leftView) {
        _leftView = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftView.frame = CGRectMake(15, NavBarHeight-20-19, 18, 25);
        [_leftView setBackgroundImage:[UIImage imageNamed:@"goBack"] forState:UIControlStateNormal];
        [_leftView addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftView;
}

- (UIButton *)rightView
{
    if (!_rightView) {
        _rightView = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightView.frame = CGRectMake(SCREEN_WITDH - 50, 12+IPHONEFringe, 30, 30);
        _rightView.centerY = _leftView.centerY;
        [_rightView addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightView;
}

- (UIView *)line
{
    if (!_line) {
        _line = [[UIView alloc] initWithFrame:CGRectMake(0, self.navBg.bottom, SCREEN_WITDH, 0.5)];
        _line.backgroundColor = [UIColor colorWithHexColorString:@"dddddd"];
    }
    return _line;
}

- (UIButton *)backBtn
{
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _backBtn.frame = CGRectMake(0, IPHONEFringe, 60, NavBarHeight);
        [_backBtn addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (UIButton *)rightBtn
{
    if (!_rightBtn) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightBtn.frame = CGRectMake(SCREEN_WITDH-60, IPHONEFringe, 60, NavBarHeight);
        [_rightBtn addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}


- (void)leftAction
{
    if (self.leftHandler) {
        self.leftHandler();
    }
}

- (void)rightAction
{
    if (self.rightHandler) {
        self.rightHandler();
    }
}

- (void)setLeftImg:(UIImage *)leftImg
{
    [self.leftView setImage:leftImg forState:UIControlStateNormal];
}

- (void)setRightImg:(UIImage *)rightImg
{
    [self.rightView setBackgroundImage:rightImg forState:UIControlStateNormal];
}

- (void)setHideLine:(BOOL)hideLine
{
    _hideLine = hideLine;
    if (hideLine) {
        self.line.hidden = true;
    }else{
        self.line.hidden = false;
    }
}


@end
