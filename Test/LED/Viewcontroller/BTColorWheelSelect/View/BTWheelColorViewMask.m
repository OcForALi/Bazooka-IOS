//
//  BTWheelColorViewMask.m
//  BTMate
//
//  Created by Mac on 2017/8/18.
//  Copyright © 2017年 QiXing. All rights reserved.
//

#import "BTWheelColorViewMask.h"

@interface BTWheelColorViewMask ()<UITextFieldDelegate>

@property (nonatomic, strong) UIButton *cancleView;
@property (nonatomic, strong) UIImageView *redLabel;
@property (nonatomic, strong) UITextField *redValue;
@property (nonatomic, strong) UIImageView *greenLabel;
@property (nonatomic, strong) UITextField *greenValue;
@property (nonatomic, strong) UIImageView *blueLabel;
@property (nonatomic, strong) UITextField *blueValue;

@property (nonatomic, strong) UIView *lineOne;
@property (nonatomic, strong) UIView *lineTwo;
@property (nonatomic, strong) UIView *lineThree;

@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, strong) UIButton *saveBtn;

@end

@implementation BTWheelColorViewMask


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.cancleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(@(15));
        make.width.height.equalTo(@(20));
    }];
    
    [self.redLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@((self.width-150)/2.0));
        make.top.equalTo(self.mas_top).offset(49);
        make.width.equalTo(@(24.5));
        make.height.equalTo(@(25.5));
    }];
    
    [self.lineOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.redLabel.mas_right).offset(31);
        make.bottom.equalTo(self.redLabel.mas_bottom);
        make.width.equalTo(@(80));
        make.height.equalTo(@(1));
    }];
    
    [self.redValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.lineOne);
        make.bottom.equalTo(self.lineOne.mas_top).offset(-5);
//        [self.redValue sizeToFit];
        make.width.equalTo(@(80));
        make.height.equalTo(@(40));
    }];
    
    [self.greenLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@((self.width-150)/2.0));
        make.top.equalTo(self.redLabel.mas_bottom).offset(34);
        make.width.equalTo(@(25.5));
        make.height.equalTo(@(26));
    }];
    
    [self.lineTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.greenLabel.mas_right).offset(31);
        make.bottom.equalTo(self.greenLabel.mas_bottom);
        make.width.equalTo(@(80));
        make.height.equalTo(@(1));
    }];
    
    [self.greenValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.lineTwo);
        make.bottom.equalTo(self.lineTwo.mas_top).offset(-5);
//        [self.greenValue sizeToFit];
        make.width.equalTo(@(80));
        make.height.equalTo(@(40));
    }];
    

    
    [self.blueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@((self.width-150)/2.0));
        make.top.equalTo(self.greenLabel.mas_bottom).offset(34);
        make.width.equalTo(@(23.5));
        make.height.equalTo(@(25.5));
    }];
    
    [self.lineThree mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.blueLabel.mas_right).offset(31);
        make.bottom.equalTo(self.blueLabel.mas_bottom);
        make.width.equalTo(@(80));
        make.height.equalTo(@(1));
    }];
    
    [self.blueValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.lineThree);
        make.bottom.equalTo(self.lineThree.mas_top).offset(-5);
//        [self.blueValue sizeToFit];
        make.width.equalTo(@(80));
        make.height.equalTo(@(40));
    }];

    
    [self.saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.lineThree.mas_bottom).offset(30);
        make.width.equalTo(@(392/2.0));
        make.height.equalTo(@(93/2.0));
    }];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        [self cn_startai_initContentView];
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)cn_startai_initContentView
{
    [self addSubview:self.cancleView];
    [self addSubview:self.redLabel];
    [self addSubview:self.redValue];
    [self addSubview:self.lineOne];
    [self addSubview:self.greenLabel];
    [self addSubview:self.greenValue];
    [self addSubview:self.lineTwo];
    [self addSubview:self.blueLabel];
    [self addSubview:self.blueValue];
    [self addSubview:self.lineThree];
    [self addSubview:self.saveBtn];
}

-(UIButton *)cancleView
{
    if (!_cancleView) {
        _cancleView = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancleView setImage:[UIImage imageNamed:@"fork"] forState:UIControlStateNormal];
        [_cancleView addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancleView;
}

- (UIImageView *)redLabel
{
    if (!_redLabel) {
        _redLabel = ({
            UIImageView *tmpL = [[UIImageView alloc] initWithFrame:CGRectZero];
            tmpL.image = [UIImage imageNamed:@"red"];
            
            tmpL;
        });
    }
    return _redLabel;
    
}

- (UITextField *)redValue
{
    if (!_redValue) {
        _redValue = ({
            UITextField *tmpL = [[UITextField alloc] initWithFrame:CGRectZero];
            tmpL.delegate = self;
            tmpL.textColor = [UIColor colorWithHexColorString:@"595858"];
            tmpL.font = [UIFont fontWithName:@"Arial" size:31];
            tmpL.text = @"127";
            tmpL.borderStyle = UITextBorderStyleNone;
            tmpL.keyboardType = UIKeyboardTypeNumberPad;
            tmpL.textAlignment = NSTextAlignmentRight;
            [tmpL addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
            
            tmpL;
        });
    }
    return _redValue;
    
}

- (UIView *)lineOne
{
    if (!_lineOne) {
        _lineOne = ({
            UIView *tmpV = [[UIView alloc] initWithFrame:CGRectZero];
            tmpV.backgroundColor = [UIColor blackColor];
            
            tmpV;
        });
    }
    return _lineOne;
}

-(UIImageView *)greenLabel
{
    if (!_greenLabel) {
        _greenLabel = ({
            UIImageView *tmpL = [[UIImageView alloc] initWithFrame:CGRectZero];
            tmpL.image = [UIImage imageNamed:@"green"];
            
            tmpL;
        });
    }
    return _greenLabel;
    
}

- (UITextField *)greenValue
{
    if (!_greenValue) {
        _greenValue = ({
            UITextField *tmpL = [[UITextField alloc] initWithFrame:CGRectZero];
            tmpL.delegate = self;
            tmpL.textColor = [UIColor colorWithHexColorString:@"595858"];
            tmpL.font = [UIFont fontWithName:@"Arial" size:31];
            tmpL.text = @"127";
            tmpL.borderStyle = UITextBorderStyleNone;
            tmpL.keyboardType = UIKeyboardTypeNumberPad;
            tmpL.textAlignment = NSTextAlignmentRight;
            [tmpL addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
            
            tmpL;
        });
    }
    return _greenValue;
    
}

- (UIView *)lineTwo
{
    if (!_lineTwo) {
        _lineTwo = ({
            UIView *tmpV = [[UIView alloc] initWithFrame:CGRectZero];
            tmpV.backgroundColor = [UIColor blackColor];
            
            tmpV;
        });
    }
    return _lineTwo;
}


- (UIImageView *)blueLabel
{
    if (!_blueLabel) {
        _blueLabel = ({
            UIImageView *tmpL = [[UIImageView alloc] initWithFrame:CGRectZero];
            tmpL.image = [UIImage imageNamed:@"blue"];
            
            tmpL;
        });
    }
    return _blueLabel;
    
}

- (UITextField *)blueValue
{
    if (!_blueValue) {
        _blueValue = ({
            UITextField *tmpL = [[UITextField alloc] initWithFrame:CGRectZero];
            tmpL.delegate = self;
            tmpL.textColor = [UIColor colorWithHexColorString:@"595858"];
            tmpL.font = [UIFont fontWithName:@"Arial" size:31];
            tmpL.text = @"127";
            tmpL.borderStyle = UITextBorderStyleNone;
            tmpL.keyboardType = UIKeyboardTypeNumberPad;
            tmpL.textAlignment = NSTextAlignmentRight;
            [tmpL addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
            
            tmpL;
        });
    }
    return _blueValue;
    
}

- (UIView *)lineThree
{
    if (!_lineThree) {
        _lineThree = ({
            UIView *tmpV = [[UIView alloc] initWithFrame:CGRectZero];
            tmpV.backgroundColor = [UIColor blackColor];
            
            tmpV;
        });
    }
    return _lineThree;
}

- (UIButton *)saveBtn
{
    if (!_saveBtn) {
        _saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_saveBtn setBackgroundImage:[UIImage imageNamed:@"saveNormal"] forState:UIControlStateNormal];
        [_saveBtn setBackgroundImage:[UIImage imageNamed:@"saveHighlighted"] forState:UIControlStateHighlighted];
        [_saveBtn addTarget:self action:@selector(selectColorAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveBtn;
}

#pragma mark -event

- (void)hide
{
    self.hidden = YES;
    [self endEditing:true];
//    BTWheelRGBEntity *rgb = [[BTWheelRGBEntity alloc] init];
    if (self.cancleHandle) {
        self.cancleHandle(nil);
    }
}
- (UITapGestureRecognizer *)tapGesture
{
    if(!_tapGesture){
        _tapGesture =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectColorAction)];
    }
    return _tapGesture;
}

- (void)selectColorAction
{
    [self endEditing:YES];
    BTWheelRGBEntity *rgb = [[BTWheelRGBEntity alloc] init];
    rgb.red = [self.redValue.text integerValue];
    rgb.green = [self.greenValue.text integerValue];
    rgb.green = [self.blueValue.text integerValue];
    
    if (self.cancleHandle) {
        self.cancleHandle(rgb);
    }
}


- (void)textFieldDidChange:(UITextField *)textfile
{
    
    if (self.redValue.text.length>3) {
        self.redValue.text = [self.redValue.text substringToIndex:3];
    }else if (self.greenValue.text.length>3){
        self.greenValue.text = [self.greenValue.text substringToIndex:3];;
    }else if (self.blueValue.text.length>3){
        self.blueValue.text = [self.blueValue.text substringToIndex:3];;
    }
    
    if ([textfile.text integerValue]>255) {
        MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.superview];
        hud.mode = MBProgressHUDModeText;
        hud.label.numberOfLines = 0;
        hud.label.text = NSLocalizedString(@"RGBError", nil);
        [self.superview addSubview:hud];
        [hud showAnimated:true];
        [hud hideAnimated:true afterDelay:2];
    }
    
    if ([self.redValue.text integerValue] > 255) {
        self.redValue.text = [self.redValue.text substringToIndex:2];
    }else if ([self.greenValue.text integerValue] > 255){
        self.greenValue.text = [self.greenValue.text substringToIndex:2];;
    }else if ([self.blueValue.text integerValue] > 255){
        self.blueValue.text = [self.blueValue.text substringToIndex:2];;
    }

    
    self.redValue.text = [NSString stringWithFormat:@"%ld",[self.redValue.text integerValue]];
    self.greenValue.text = [NSString stringWithFormat:@"%ld",[self.greenValue.text integerValue]];
    self.blueValue.text = [NSString stringWithFormat:@"%ld",[self.blueValue.text integerValue]];
    [self layoutIfNeeded];

}

- (void)updateColorValueWithRed:(NSInteger)red Green:(NSInteger)green Blue:(NSInteger)blue
{
    self.redValue.text = [NSString stringWithFormat:@"%ld", red];
    self.greenValue.text = [NSString stringWithFormat:@"%ld", green];
    self.blueValue.text = [NSString stringWithFormat:@"%ld", blue];
    
    [self layoutIfNeeded];
}

@end
