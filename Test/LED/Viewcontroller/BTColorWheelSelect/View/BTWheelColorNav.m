//
//  BTWheelColorNav.m
//  BTMate
//
//  Created by Mac on 2017/8/18.
//  Copyright © 2017年 QiXing. All rights reserved.
//

#import "BTWheelColorNav.h"
//#import "BTWheelColorValueView.h"
#import "BTWheelPickColorView.h"

@interface BTWheelColorNav ()

@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UIButton *leftView;
//@property (nonatomic, strong) BTWheelColorValueView *colorValueView;
@property (nonatomic, strong) UIButton *menuBtn;
@property (nonatomic, strong) UIView *line;

@end

@implementation BTWheelColorNav

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(15));
        make.centerY.equalTo(self);
        make.width.equalTo(@(18));
        make.height.equalTo(@(25));
    }];
    
    [self.menuBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-10);
        make.width.height.equalTo(@(40));
        make.centerY.equalTo(self);
    }];

//    [self.colorValueView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.menuBtn.mas_left).offset(-5);
//        make.width.equalTo(@(89*1.2));
//        make.height.equalTo(@(16*1.2));
//        make.centerY.equalTo(self);
//    }];
    
//    [self.pickView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.menuBtn.mas_left).offset(-5);
//        make.width.equalTo(@(200));
//        make.height.equalTo(@(40));
//        make.centerY.equalTo(self);
//    }];
    
//    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(@(0));
//        make.width.equalTo(self);
//        make.height.equalTo(@(0.5));
//        make.top.equalTo(self.mas_bottom).offset(-0.5);
//    }];
   
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        
        [self cn_startai_initContentView];
    }
    return self;
}


- (void)cn_startai_initContentView
{
    [self addSubview:self.leftView];
    [self addSubview:self.backBtn];
//    [self addSubview:self.colorValueView];
    [self addSubview:self.menuBtn];
//    [self addSubview:self.line];
//    [self addSubview:self.pickView];
}

- (UIButton *)leftView
{
    if (!_leftView) {
        _leftView = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftView.frame = CGRectMake(15, 23+IPHONEFringe, 18, 25);
        [_leftView setBackgroundImage:[UIImage imageNamed:@"goBack"] forState:UIControlStateNormal];
        [_leftView addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftView;
}

//- (BTWheelPickColorView *)pickView
//{
//    if (!_pickView) {
//        _pickView = [[BTWheelPickColorView alloc] init];
//    }
//    return _pickView;
//}

//- (BTWheelColorValueView *)colorValueView
//{
//    __weak typeof(self) weakSelf = self;
//    if (!_colorValueView) {
//        _colorValueView = [[BTWheelColorValueView alloc] initWithFrame:CGRectZero];
//        _colorValueView.layer.masksToBounds = true;
//        _colorValueView.colorhandler = ^(){
//            if (weakSelf.colorhandler) {
//                weakSelf.colorhandler();
//            }
//        };
//    }
//    return _colorValueView;
//}


- (UIButton *)menuBtn
{
    if (!_menuBtn) {
        _menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_menuBtn setBackgroundImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
        [_menuBtn addTarget:self action:@selector(menuClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _menuBtn;
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


- (UIView *)line
{
    if (!_line) {
        _line = [[UIView alloc] initWithFrame:CGRectZero];
        _line.backgroundColor = [UIColor colorWithHexColorString:@"dddddd"];
    }
    return _line;
}

- (void)leftAction
{
    if (self.popHandler) {
        self.popHandler();
    }
}

- (void)menuClick
{
    if (self.menuHandler) {
        self.menuHandler();
    }
}

- (void)updateNavgation
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (appDelegate.conncetType == BAZ_G2_FM) {
        self.menuBtn.hidden = true;
    }else{
        self.menuBtn.hidden = false;
    }
}

- (void)updateColorValueWithRed:(NSInteger)red Green:(NSInteger)green Blue:(NSInteger)blue
{
    
//    [self.colorValueView updateColorValueWithRed:red
//                                           Green:green
//                                            Blue:blue];
    
}
@end
