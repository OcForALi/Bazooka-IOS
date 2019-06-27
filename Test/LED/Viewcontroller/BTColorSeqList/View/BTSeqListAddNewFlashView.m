//
//  BTSeqListAddNewFlashView.m
//  Test
//
//  Created by Mac on 2017/9/22.
//  Copyright © 2017年 QiXing. All rights reserved.
//

#import "BTSeqListAddNewFlashView.h"
#import "BTWheelCustomeSlider.h"

@interface BTSeqListAddNewFlashView ()

@property (nonatomic, strong) UIButton *cancleView;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UIButton *gradientModel;
@property (nonatomic, strong) UIButton *breathModel;
@property (nonatomic, strong) UIButton *flashModel;
@property (nonatomic, strong) UILabel *onView;
@property (nonatomic, strong) UILabel *offView;
@property (nonatomic, strong) UILabel *brightnessView;
@property (nonatomic, strong) BTWheelCustomeSlider *onSlider;
@property (nonatomic, strong) BTWheelCustomeSlider *offSlider;
@property (nonatomic, strong) BTWheelCustomeSlider *brightnessSlider;
@property (nonatomic, strong) UILabel *onMinLabel;
@property (nonatomic, strong) UILabel *offMinLabel;
@property (nonatomic, strong) UILabel *brightnessMinLabel;

@property (nonatomic, strong) UILabel *onMaxLabel;
@property (nonatomic, strong) UILabel *offMaxLabel;
@property (nonatomic, strong) UILabel *brightnessMaxLabel;
@property (nonatomic, strong) UIButton *saveBtn;

@property (nonatomic, assign) NSInteger selected;

@end

@implementation BTSeqListAddNewFlashView

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat off = IS_IPHONE_5_OR_LESS ? 0 : 10;
    
    [self.cancleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(15));
        make.top.equalTo(@(5));
        make.width.height.equalTo(@(40));
    }];
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.cancleView.mas_top).offset(20);
        make.width.equalTo(@(200));
        make.height.equalTo(@(30));
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(25));
        make.top.equalTo(self.textField.mas_bottom).offset(5);
        make.right.equalTo(@(-25));
        make.height.equalTo(@(1));
    }];
    
    [self.gradientModel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(80);
        make.top.equalTo(self.textField.mas_bottom).offset(20);
        make.width.equalTo(@(60));
        make.height.equalTo(@(20));
    }];
    
    [self.breathModel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.gradientModel.mas_right).offset(10);
        make.top.equalTo(self.textField.mas_bottom).offset(20);
        make.width.equalTo(@(60));
        make.height.equalTo(@(20));
    }];
    
    [self.flashModel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.breathModel.mas_right).offset(off);
        make.top.equalTo(self.textField.mas_bottom).offset(20);
        make.width.equalTo(@(60));
        make.height.equalTo(@(20));
    }];
    
    
    [self.onView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(30);
        make.top.equalTo(self.gradientModel.mas_bottom).offset(10);
        make.width.equalTo(@(60));
        make.height.equalTo(@(20));
    }];
    
    [self.offView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(30);
        make.top.equalTo(self.onView.mas_bottom).offset(10);
        make.width.equalTo(@(60));
        make.height.equalTo(@(20));
    }];
    
    [self.brightnessView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(30);
        make.top.equalTo(self.offView.mas_bottom).offset(10);
        make.width.equalTo(@(60));
        make.height.equalTo(@(20));
    }];
    
    [self.onSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.onView.mas_right).offset(0);
        make.centerY.equalTo(self.onView);
        make.right.equalTo(self.mas_right).offset(-50);
        make.height.equalTo(@(12.5*2));
    }];
    
    [self.offSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.offView.mas_right).offset(0);
        make.centerY.equalTo(self.offView);
        make.right.equalTo(self.mas_right).offset(-50);
        make.height.equalTo(@(12.5*2));
    }];
    
    [self.brightnessSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.brightnessView.mas_right).offset(0);
        make.centerY.equalTo(self.brightnessView);
        make.right.equalTo(self.mas_right).offset(-50);
        make.height.equalTo(@(12.5*2));
    }];
    
    
    [self.onMinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.onSlider.mas_left);
        make.top.equalTo(self.onSlider.mas_bottom).offset(2);
        [self.onMinLabel sizeToFit];
    }];
    
    [self.onMaxLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.onSlider.mas_right).offset(-30);
        make.top.equalTo(self.onSlider.mas_bottom).offset(2);
        [self.onMaxLabel sizeToFit];
    }];
    
    [self.offMinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.offSlider.mas_left);
        make.top.equalTo(self.offSlider.mas_bottom).offset(2);
        [self.offMinLabel sizeToFit];
    }];
    
    [self.offMaxLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.offSlider.mas_right).offset(-30);
        make.top.equalTo(self.offSlider.mas_bottom).offset(2);
        [self.offMaxLabel sizeToFit];
    }];
    
    [self.brightnessMinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.brightnessSlider.mas_left);
        make.top.equalTo(self.brightnessSlider.mas_bottom).offset(2);
        [self.brightnessSlider sizeToFit];
    }];
    
    [self.brightnessMaxLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.brightnessSlider.mas_right).offset(-30);
        make.top.equalTo(self.brightnessSlider.mas_bottom).offset(2);
        [self.brightnessMaxLabel sizeToFit];
    }];
    
    [self.saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.brightnessMaxLabel.mas_bottom).offset(10);
        make.width.equalTo(@(392/2.0));
        make.height.equalTo(@(93/2.0));
    }];
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.selected = 3;
        [self cn_startai_initContentView];
    }
    return self;
}

- (void)cn_startai_initContentView
{
    [self addSubview:self.cancleView];
    [self addSubview:self.textField];
    [self addSubview:self.line];
    [self addSubview:self.gradientModel];
    [self addSubview:self.breathModel];
    [self addSubview:self.flashModel];
    [self addSubview:self.onView];
    [self addSubview:self.offView];
    [self addSubview:self.brightnessView];
    [self addSubview:self.onSlider];
    [self addSubview:self.offSlider];
    [self addSubview:self.brightnessSlider];
    
    [self addSubview:self.onMinLabel];
    [self addSubview:self.onMaxLabel];
    [self addSubview:self.offMinLabel];
    [self addSubview:self.offMaxLabel];
    [self addSubview:self.brightnessMinLabel];
    [self addSubview:self.brightnessMaxLabel];
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

-(UITextField *)textField
{
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.placeholder = @"闪法名称（如：002，008）";
        _textField.font = [UIFont systemFontOfSize:15];
        _textField.textAlignment = NSTextAlignmentCenter;
        _textField.keyboardType = UIKeyboardTypeNumberPad;
        [_textField addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _textField;
}

- (UIView *)line
{
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = [UIColor colorWithHexColorString:@"dddddd"];
    }
    return _line;
}

- (UIButton *)gradientModel
{
    if (!_gradientModel) {
        _gradientModel = ({
            UIButton *tmpV = [UIButton buttonWithType:UIButtonTypeCustom];
            [tmpV setTitle:@"Gradient" forState:UIControlStateNormal];
            [tmpV setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            tmpV.selected = true;
            tmpV.tag = GradientModel;
            tmpV.titleLabel.font = [UIFont systemFontOfSize:15];
            tmpV.layer.borderColor = [UIColor whiteColor].CGColor;
            tmpV.layer.borderWidth = 0.5;
            [tmpV addTarget:self action:@selector(selectedModel:) forControlEvents:UIControlEventTouchUpInside];
            
            tmpV;
        });
        
    }
    return _gradientModel;
}

- (UIButton *)breathModel
{
    if (!_breathModel) {
        _breathModel = ({
            UIButton *tmpV = [UIButton buttonWithType:UIButtonTypeCustom];
            [tmpV setTitle:@"Breath" forState:UIControlStateNormal];
            [tmpV setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            tmpV.selected = NO;
            tmpV.tag = BreathModel;
            tmpV.titleLabel.font = [UIFont systemFontOfSize:15];
            tmpV.layer.borderColor = [UIColor whiteColor].CGColor;
            tmpV.layer.borderWidth = 0.5;
            [tmpV addTarget:self action:@selector(selectedModel:) forControlEvents:UIControlEventTouchUpInside];
            
            tmpV;
        });
    }
    return _breathModel;
}

- (UIButton *)flashModel
{
    if (!_flashModel) {
        _flashModel = ({
            UIButton *tmpV = [UIButton buttonWithType:UIButtonTypeCustom];
            [tmpV setTitle:@"Flash" forState:UIControlStateNormal];
            [tmpV setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            tmpV.selected = NO;
            tmpV.tag = FlashModel;
            tmpV.titleLabel.font = [UIFont systemFontOfSize:15];
            tmpV.layer.borderColor = [UIColor whiteColor].CGColor;
            tmpV.layer.borderWidth = 0.5;
            [tmpV addTarget:self action:@selector(selectedModel:) forControlEvents:UIControlEventTouchUpInside];
            
            tmpV;
        });
    }
    return _flashModel;
}

- (UILabel *)onView
{
    if (!_onView) {
        _onView = ({
            UILabel *tmpV = [[UILabel alloc] initWithFrame:CGRectZero];
            tmpV.text = @"ON";
            tmpV.textColor = [UIColor blackColor];
            tmpV.font = [UIFont boldSystemFontOfSize:15];
            
            tmpV;
        });
    }
    return _onView;
}

- (UILabel *)offView
{
    if (!_offView) {
        _offView = ({
            UILabel *tmpV = [[UILabel alloc] initWithFrame:CGRectZero];
            tmpV.text = @"OFF";
            tmpV.textColor = [UIColor blackColor];
            tmpV.font = [UIFont boldSystemFontOfSize:15];
            
            tmpV;
        });
    }
    return _offView;
}


- (UILabel *)brightnessView
{
    if (!_brightnessView) {
        _brightnessView = ({
            UILabel *tmpV = [[UILabel alloc] initWithFrame:CGRectZero];
            tmpV.text = @"Bright";
            tmpV.textColor = [UIColor blackColor];
            tmpV.font = [UIFont boldSystemFontOfSize:15];
            tmpV.layer.borderColor = [UIColor whiteColor].CGColor;
            tmpV.layer.borderWidth = 0.5;
            
            tmpV;
        });
    }
    return _brightnessView;
}

- (BTWheelCustomeSlider *)onSlider
{
    if (!_onSlider) {
        _onSlider = [[BTWheelCustomeSlider alloc] initWithFrame:CGRectZero];
        _onSlider.lineHeght = 6.5;
        _onSlider.thumbW = 5*1.5;
        _onSlider.thumbH = 12.5*1.5;
        _onSlider.imgModel = true;
        _onSlider.progressImage = [UIImage imageNamed:@"onOffSlider"];
        _onSlider.thumbImage = [UIImage imageNamed:@"blackTriangle"];
        
    }
    return _onSlider;
}

- (BTWheelCustomeSlider *)offSlider
{
    if (!_offSlider) {
        _offSlider = [[BTWheelCustomeSlider alloc] initWithFrame:CGRectZero];
        _offSlider.lineHeght = 6.5;
        _offSlider.thumbW = 5*1.5;
        _offSlider.thumbH = 12.5*1.5;
        _offSlider.imgModel = true;
        _offSlider.progressImage = [UIImage imageNamed:@"onOffSlider"];
        _offSlider.thumbImage = [UIImage imageNamed:@"blackTriangle"];
        
    }
    return _offSlider;
}

-(BTWheelCustomeSlider *)brightnessSlider
{
    if (!_brightnessSlider) {
        _brightnessSlider = [[BTWheelCustomeSlider alloc] initWithFrame:CGRectZero];
        _brightnessSlider.lineHeght = 3.5;
        _brightnessSlider.thumbW = 5*1.5;
        _brightnessSlider.thumbH = 12.5*1.5;
        _brightnessSlider.imgModel = true;
        _brightnessSlider.progressImage = [UIImage imageNamed:@"brighrnessSlider"];
        _brightnessSlider.thumbImage = [UIImage imageNamed:@"blackTriangle"];
        
    }
    return _brightnessSlider;
}

- (UILabel *)onMinLabel
{
    if (!_onMinLabel) {
        _onMinLabel = ({
            UILabel *tmpV = [[UILabel alloc] init];
            tmpV.text = @"1";
            tmpV.textColor = [UIColor grayColor];
            tmpV.font = [UIFont systemFontOfSize:11];
            
            tmpV;
        });
    }
    return _onMinLabel;
}

- (UILabel *)onMaxLabel
{
    if (!_onMaxLabel) {
        _onMaxLabel = ({
            UILabel *tmpV = [[UILabel alloc] init];
            tmpV.text = @"100";
            tmpV.textColor = [UIColor grayColor];
            tmpV.font = [UIFont systemFontOfSize:11];
            
            tmpV;
        });
    }
    return _onMaxLabel;
}

- (UILabel *)offMinLabel
{
    if (!_offMinLabel) {
        _offMinLabel = ({
            UILabel *tmpV = [[UILabel alloc] init];
            tmpV.text = @"1";
            tmpV.textColor = [UIColor grayColor];
            tmpV.font = [UIFont systemFontOfSize:11];
            
            tmpV;
        });
    }
    return _offMinLabel;
}

- (UILabel *)offMaxLabel
{
    if (!_offMaxLabel) {
        _offMaxLabel = ({
            UILabel *tmpV = [[UILabel alloc] init];
            tmpV.text = @"100";
            tmpV.textColor = [UIColor grayColor];
            tmpV.font = [UIFont systemFontOfSize:11];
            
            tmpV;
        });
    }
    return _offMaxLabel;
}

- (UILabel *)brightnessMinLabel
{
    if (!_brightnessMinLabel) {
        _brightnessMinLabel = ({
            UILabel *tmpV = [[UILabel alloc] init];
            tmpV.text = @"100";
            tmpV.textColor = [UIColor grayColor];
            tmpV.font = [UIFont systemFontOfSize:11];
            
            tmpV;
        });
    }
    return _brightnessMinLabel;
}

- (UILabel *)brightnessMaxLabel
{
    if (!_brightnessMaxLabel) {
        _brightnessMaxLabel = ({
            UILabel *tmpV = [[UILabel alloc] init];
            tmpV.text = @"4500(mcd)";
            tmpV.textColor = [UIColor grayColor];
            tmpV.font = [UIFont systemFontOfSize:11];
            
            tmpV;
        });
    }
    return _brightnessMaxLabel;
}

- (UIButton *)saveBtn
{
    if (!_saveBtn) {
        _saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_saveBtn setBackgroundImage:[UIImage imageNamed:@"saveHighlighted"] forState:UIControlStateNormal];
//        [_saveBtn setBackgroundImage:[UIImage imageNamed:@"saveHighlighted"] forState:UIControlStateHighlighted];
        [_saveBtn addTarget:self action:@selector(saveFlash) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveBtn;
}

#pragma mark - event

- (void)saveFlash
{
    
    if( [self.textField.text integerValue]>8
       || [self.textField.text integerValue]==0
       || self.textField.text.length != 3){
        MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.superview];
        hud.mode = MBProgressHUDModeText;
        hud.label.text  =@"闪法的名称范围是001-008,请重新输入";
        hud.label.numberOfLines = 0;
        [self.superview addSubview:hud];
        [hud showAnimated:true];
        [hud hideAnimated:true afterDelay:2];
        return;
    }
    for (BTSeqListCellEntity *entity in self.dataArr) {
        if (entity.serial == [self.textField.text integerValue]) {
            MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.superview];
            hud.mode = MBProgressHUDModeText;
            hud.label.text  = NSLocalizedString(@"FlashNameRepeat", nil);
            hud.label.numberOfLines = 0;
            [self.superview addSubview:hud];
            [hud showAnimated:true];
            [hud hideAnimated:true afterDelay:2];
//            return;
        }
    }
    
    [self endEditing:YES];
    BTSeqListCellEntity *tEntity = [[BTSeqListCellEntity alloc] init];
    tEntity.modelNum = self.selected;
    tEntity.serial = [self.textField.text integerValue];
    tEntity.onms = self.onSlider.KValue;
    tEntity.offms = self.offSlider.KValue;
    tEntity.brigthness = self.brightnessSlider.KValue;
    if (self.cancleOrAddFlash) {
        self.cancleOrAddFlash(tEntity);
    }
}

- (void)hide
{
    if (self.cancleOrAddFlash) {
        self.cancleOrAddFlash(nil);
    }
}
- (void)selectedModel:(UIButton *)btn
{
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)view;
            button.selected = NO;
            button.layer.borderColor = [UIColor whiteColor].CGColor;
        }
    }
    btn.selected = YES;
    btn.layer.borderColor = [UIColor orangeColor].CGColor;
    self.selected = btn.tag;
}

- (void)textChange:(UITextField *)textField
{
    if (textField.text.length>3) {
        textField.text = [textField.text substringFromIndex:3];
    }
    if(0<[self.textField.text integerValue] && [self.textField.text integerValue]<6 && self.textField.text.length == 3){
        [self.saveBtn setBackgroundImage:[UIImage imageNamed:@"saveNormal"] forState:UIControlStateNormal];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self endEditing:YES];

}

@end
