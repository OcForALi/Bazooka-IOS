//
//  BTWheelSliderView.m
//  BTMate
//
//  Created by Mac on 2017/8/21.
//  Copyright © 2017年 QiXing. All rights reserved.
//

#import "BTWheelSliderView.h"
#import "BTWheelCustomeSlider.h"
#import "BTSaveSeqListEntity.h"

static const CGFloat kLeftHorzontal = 39;
static const CGFloat kLeftImgAndSliderHorzontal = 24;
static const CGFloat kVertical = 34;

@interface BTWheelSliderView ()
{
    CGFloat ViewScale ;

}
@property (nonatomic, strong) UIImageView *brightnessImg;           //亮度
@property (nonatomic, strong) BTWheelCustomeSlider *brightnessSlider;   //亮度进度条
@property (nonatomic, strong) UIImageView *chromaImg;               //速度
@property (nonatomic, strong) BTWheelCustomeSlider *chromaSlider;   //速度进度条
@property (nonatomic, strong) UIImageView *modelImg;    //闪法模式
@property (nonatomic, strong) UIButton *leftBtn;        //上一个闪法
@property (nonatomic, strong) UIButton *rightBtn;       //下一个闪法
@property (nonatomic, assign) NSInteger index;          //当前闪法下标

@property (nonatomic, strong) UILabel *multipleSpeedOne;
@property (nonatomic, strong) UILabel *multipleSpeedTwo;
@property (nonatomic, strong) UILabel *multipleSpeedThree;

@property (nonatomic, strong) UILabel *multipleBrightnessOne;
@property (nonatomic, strong) UILabel *multipleBrightnessTwo;
@property (nonatomic, strong) UILabel *multipleBrightnessThree;

@property (nonatomic, strong) UIButton *leftButton; //加大闪法按钮触发范围
@property (nonatomic, strong) UIButton *rightButton;

@end

@implementation BTWheelSliderView

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.brightnessImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(kLeftHorzontal);
        make.top.equalTo(self.mas_top).offset(kVertical);
        make.width.height.equalTo(@(21*ViewScale));
    }];
    
    [self.chromaImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(kLeftHorzontal);
        make.top.equalTo(self.brightnessImg.mas_bottom).offset(kVertical);
        make.width.height.equalTo(@(21*ViewScale));
    }];
    
    [self.modelImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(kLeftHorzontal);
        make.top.equalTo(self.chromaImg.mas_bottom).offset(kVertical);
        make.width.height.equalTo(@(21*ViewScale));
    }];
    
    [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.modelImg.mas_right).offset(kLeftImgAndSliderHorzontal);
        make.centerY.equalTo(self.modelImg);
        make.width.equalTo(@(16.5*ViewScale));
        make.height.equalTo(@(19*ViewScale));
    }];
    
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-kLeftHorzontal);
        make.centerY.equalTo(self.modelImg);
        make.width.equalTo(@(16.5*ViewScale));
        make.height.equalTo(@(19*ViewScale));
    }];
    
    [self.seqLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.modelImg);
        [self.seqLabel sizeToFit];
        make.left.equalTo(self.leftBtn.mas_right).offset(0);
        make.width.equalTo(@(self.rightBtn.left - self.leftBtn.right));
    }];
    
    self.seqLabel.frame = CGRectMake(self.leftBtn.right, self.modelImg.top, self.rightBtn.left - self.leftBtn.right, 30);
    
    [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.leftBtn);
        make.centerY.equalTo(self.leftBtn);
        make.width.equalTo(@(16.5*ViewScale*2));
        make.height.equalTo(@(19*ViewScale*2));
    }];
    
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.rightBtn);
        make.centerY.equalTo(self.rightBtn);
        make.width.equalTo(@(16.5*ViewScale*2));
        make.height.equalTo(@(19*ViewScale*2));
    }];
    
    [self.brightnessSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.brightnessImg.mas_right).offset(kLeftImgAndSliderHorzontal);
        make.centerY.equalTo(self.brightnessImg);
        make.right.equalTo(self.mas_right).offset(-34);
//        make.width.equalTo(@(SCREEN_WITDH - self.brightnessImg.right - kLeftImgAndSliderHorzontal - 54));
        make.height.equalTo(@(16.5*ViewScale));
    }];
    
    [self.chromaSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.brightnessImg.mas_right).offset(kLeftImgAndSliderHorzontal);
        make.centerY.equalTo(self.chromaImg);
        make.right.equalTo(self.mas_right).offset(-34);
        make.height.equalTo(@(16.5*ViewScale));
    }];
    
    [self.multipleSpeedOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.chromaSlider.mas_left).offset(0);
        make.top.equalTo(self.chromaSlider.mas_bottom).offset(0);
        [self.multipleSpeedOne sizeToFit];
    }];
    
    [self.multipleSpeedTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.chromaSlider);
        make.top.equalTo(self.chromaSlider.mas_bottom).offset(0);
        [self.multipleSpeedTwo sizeToFit];
    }];
    
    [self.multipleSpeedThree mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.chromaSlider.mas_right).offset(0);
        make.top.equalTo(self.chromaSlider.mas_bottom).offset(0);
        [self.multipleSpeedThree sizeToFit];
    }];
    
    [self.multipleBrightnessOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.brightnessSlider.mas_left).offset(0);
        make.top.equalTo(self.brightnessSlider.mas_bottom).offset(0);
        [self.multipleBrightnessOne sizeToFit];
    }];
    
    [self.multipleBrightnessTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.brightnessSlider);
        make.top.equalTo(self.brightnessSlider.mas_bottom).offset(0);
        [self.multipleBrightnessTwo sizeToFit];
    }];
    
    [self.multipleBrightnessThree mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.brightnessSlider.mas_right).offset(0);
        make.top.equalTo(self.brightnessSlider.mas_bottom).offset(0);
        [self.multipleBrightnessThree sizeToFit];
    }];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.index = 0;
        ViewScale = IS_IPHONE_5_OR_LESS ? 1.0 : 1.5;
        [self cn_startai_initContentView];
    }
    return self;
}

- (void)cn_startai_initContentView
{
    [self addSubview:self.brightnessImg];
    [self addSubview:self.brightnessSlider];
    [self addSubview:self.chromaImg];
    [self addSubview:self.chromaSlider];
    [self addSubview:self.modelImg];
    [self addSubview:self.leftBtn];
    [self addSubview:self.seqLabel];
    [self addSubview:self.rightBtn];
    
    [self addSubview:self.leftButton];
    [self addSubview:self.rightButton];
    
    [self addSubview:self.multipleSpeedOne];
    [self addSubview:self.multipleSpeedTwo];
    [self addSubview:self.multipleSpeedThree];
    [self addSubview:self.multipleBrightnessOne];
    [self addSubview:self.multipleBrightnessTwo];
    [self addSubview:self.multipleBrightnessThree];
}

- (UIImageView *)brightnessImg
{
    if (!_brightnessImg) {
        _brightnessImg = [[UIImageView alloc] init];
        _brightnessImg.image = [UIImage imageNamed:@"brightnessSelected"];
    }
    return _brightnessImg;
}

- (BTWheelCustomeSlider *)brightnessSlider
{
    @weakify(self);
    if (!_brightnessSlider) {
        
        _brightnessSlider = [[BTWheelCustomeSlider alloc] init];
//        _brightnessSlider.maximumValue = 100;
//        _brightnessSlider.minimumValue = 0;
        _brightnessSlider.value = 0.5;
        _brightnessSlider.lineHeght = 7;
        _brightnessSlider.thumbW = 14*ViewScale;
        _brightnessSlider.thumbH = 16.5*ViewScale;
        _brightnessSlider.show = false;
        _brightnessSlider.imgModel = true;
        _brightnessSlider.thumbImage = [UIImage imageNamed:@"chunkSelected"];
        _brightnessSlider.progressImage = [UIImage imageNamed:@"lightLongSliderSelected"];
        _brightnessSlider.translatesAutoresizingMaskIntoConstraints = false;
        _brightnessSlider.BTWheelCustomeSliderValue = ^(CGFloat value) {
            if (weak_self.BrightnessValueHandler) {
                weak_self.BrightnessValueHandler(value);
            }
        };
        _brightnessSlider.BTWheelCustomeSliderError = ^{
//            [weak_self cn_startai_showToastWithTitle:NSLocalizedString(@"LedOff", nil)];
        };
//        _brightnessSlider.backgroundColor = [UIColor redColor];
    }
    return _brightnessSlider;
}

- (UIImageView *)chromaImg
{
    if (!_chromaImg) {
        _chromaImg = [[UIImageView alloc] init];
        _chromaImg.image = [UIImage imageNamed:@"speedSelected"];
    }
    return _chromaImg;
}

-(BTWheelCustomeSlider *)chromaSlider
{
    @weakify(self);
    if (!_chromaSlider) {
        _chromaSlider = [[BTWheelCustomeSlider alloc] init];
//        _chromaSlider.maximumValue = 100;
//        _chromaSlider.minimumValue = 0;
        _chromaSlider.value = 0.5;
        _chromaSlider.lineHeght = 7;
        _chromaSlider.thumbW = 14*ViewScale;
        _chromaSlider.thumbH = 16.5*ViewScale;
        _chromaSlider.show = false;
        _chromaSlider.imgModel = true;
        _chromaSlider.thumbImage = [UIImage imageNamed:@"chunkSelected"];
        _chromaSlider.progressImage = [UIImage imageNamed:@"lightLongSliderSelected"];
        _chromaSlider.translatesAutoresizingMaskIntoConstraints = false;
        _chromaSlider.BTWheelCustomeSliderValue = ^(CGFloat value) {
            
            if (weak_self.ChromaValueHandler) {
                weak_self.ChromaValueHandler(value);
            }
        };
        _chromaSlider.BTWheelCustomeSliderError = ^{
//            [weak_self cn_startai_showToastWithTitle:NSLocalizedString(@"LedOff", nil)];
        };
//        _chromaSlider.backgroundColor = [UIColor redColor];
    }
    return _chromaSlider;
}

- (UIImageView *)modelImg
{
    if (!_modelImg) {
        _modelImg = [[UIImageView alloc] init];
        _modelImg.image = [UIImage imageNamed:@"modelSelected"];
    }
    return _modelImg;
}

- (UIButton *)leftBtn
{
    if (!_leftBtn) {
        _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftBtn setImage:[UIImage imageNamed:@"lastSeq"] forState:UIControlStateNormal];
        [_leftBtn addTarget:self action:@selector(lastSeq) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftBtn;
}

- (UILabel *)seqLabel
{
    if (!_seqLabel) {
        _seqLabel = [[UILabel alloc] init];
        _seqLabel.textColor = [UIColor colorWithHexColorString:@"333333"];
        _seqLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
        _seqLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _seqLabel;
}

- (UIButton *)rightBtn
{
    if (!_rightBtn) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightBtn setImage:[UIImage imageNamed:@"nextSeq"] forState:UIControlStateNormal];
        [_rightBtn addTarget:self action:@selector(nextSeq) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}

- (UIButton *)leftButton
{
    if (!_leftButton) {
        _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftButton setBackgroundColor:[UIColor clearColor]];
        [_leftButton addTarget:self action:@selector(lastSeq) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftButton;
}

- (UIButton *)rightButton
{
    if (!_rightButton) {
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightButton setBackgroundColor:[UIColor clearColor]];
        [_rightButton addTarget:self action:@selector(nextSeq) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightButton;
}


- (UILabel *)multipleSpeedOne
{
    if (!_multipleSpeedOne) {
        _multipleSpeedOne = ({
            UILabel *tmpL = [[UILabel alloc] init];
            tmpL.text = @"0.5x";
            tmpL.textColor = [UIColor colorWithHexColorString:@"ddddd"];
            tmpL.font = [UIFont systemFontOfSize:12];
            
            tmpL;
        });
    }
    return _multipleSpeedOne;
}

- (UILabel *)multipleSpeedTwo
{
    if (!_multipleSpeedTwo) {
        _multipleSpeedTwo = ({
            UILabel *tmpL = [[UILabel alloc] init];
            tmpL.text = @"1x";
            tmpL.textColor = [UIColor colorWithHexColorString:@"ddddd"];
            tmpL.font = [UIFont systemFontOfSize:12];
            
            tmpL;
        });
    }
    return _multipleSpeedTwo;
}

- (UILabel *)multipleSpeedThree
{
    if (!_multipleSpeedThree) {
        _multipleSpeedThree = ({
            UILabel *tmpL = [[UILabel alloc] init];
            tmpL.text = @"2x";
            tmpL.textColor = [UIColor colorWithHexColorString:@"ddddd"];
            tmpL.font = [UIFont systemFontOfSize:12];
            
            tmpL;
        });
    }
    return _multipleSpeedThree;
}

-(UILabel *)multipleBrightnessOne
{
    if (!_multipleBrightnessOne) {
        _multipleBrightnessOne = ({
            UILabel *tmpL = [[UILabel alloc] init];
            tmpL.text = @"0.5x";
            tmpL.textColor = [UIColor colorWithHexColorString:@"ddddd"];
            tmpL.font = [UIFont systemFontOfSize:12];
            
            tmpL;
        });
    }
    return _multipleBrightnessOne;
}

- (UILabel *)multipleBrightnessTwo
{
    if (!_multipleBrightnessTwo) {
        _multipleBrightnessTwo = ({
            UILabel *tmpL = [[UILabel alloc] init];
            tmpL.text = @"1x";
            tmpL.textColor = [UIColor colorWithHexColorString:@"ddddd"];
            tmpL.font = [UIFont systemFontOfSize:12];
            
            tmpL;
        });
    }
    return _multipleBrightnessTwo;
}

- (UILabel *)multipleBrightnessThree
{
    if (!_multipleBrightnessThree) {
        _multipleBrightnessThree = ({
            UILabel *tmpL = [[UILabel alloc] init];
            tmpL.text = @"2x";
            tmpL.textColor = [UIColor colorWithHexColorString:@"ddddd"];
            tmpL.font = [UIFont systemFontOfSize:12];
            
            tmpL;
        });
    }
    return _multipleBrightnessThree;
}

- (void)setIsPopup:(BOOL)isPopup
{
    _isPopup = isPopup;
    if (isPopup) {
        _brightnessImg.image = [UIImage imageNamed:@"brightness"];
        _brightnessSlider.thumbImage = [UIImage imageNamed:@"chunk"];
        _brightnessSlider.progressImage = [UIImage imageNamed:@"lightLongSlider"];
        _chromaImg.image = [UIImage imageNamed:@"speed"];
        _chromaSlider.thumbImage = [UIImage imageNamed:@"chunk"];
        _chromaSlider.progressImage = [UIImage imageNamed:@"lightLongSlider"];
        _modelImg.image = [UIImage imageNamed:@"model"];

    }else{
        _brightnessImg.image = [UIImage imageNamed:@"brightnessSelected"];
        _brightnessSlider.thumbImage = [UIImage imageNamed:@"chunkSelected"];
        _brightnessSlider.progressImage = [UIImage imageNamed:@"lightLongSliderSelected"];
        _chromaImg.image = [UIImage imageNamed:@"speedSelected"];
        _chromaSlider.thumbImage = [UIImage imageNamed:@"chunkSelected"];
        _chromaSlider.progressImage = [UIImage imageNamed:@"lightLongSliderSelected"];
        _modelImg.image = [UIImage imageNamed:@"modelSelected"];
    }
}

#pragma mark

- (void)lastSeq
{
//    if (self.slideError) {
//        [self cn_startai_showToastWithTitle:NSLocalizedString(@"LedOff", nil)];
//        return;
//    }
    if (!self.dataArr.count) return;
    self.index -- ;
    self.seqLabel.text = self.dataArr[(self.dataArr.count+self.index)%self.dataArr.count];
    if (self.ModelValueHandler) {
        self.ModelValueHandler(self.seqLabel.text);
    }
    
}

- (void)nextSeq
{
//    if (self.slideError) {
//        [self cn_startai_showToastWithTitle:NSLocalizedString(@"LedOff", nil)];
//        return;
//    }
    if (!self.dataArr.count) return;
    self.index ++;
    self.seqLabel.text = self.dataArr[(self.dataArr.count+self.index)%self.dataArr.count];
    if (self.ModelValueHandler) {
        self.ModelValueHandler(self.seqLabel.text);
    }
}

- (void)setDataArr:(NSMutableArray *)dataArr
{
    self.index = (dataArr.count+self.index)%dataArr.count;
    _dataArr = dataArr;
    if (!dataArr.count) {
        self.seqLabel.text =  @"";
    }else if (self.index < dataArr.count){
        self.seqLabel.text =  self.dataArr[self.index];
    }else if(self.index>dataArr.count && dataArr.count){
        self.seqLabel.text = @"";
    }
    [self layoutSubviews];

}

- (void)setSlideError:(BOOL)slideError
{
    _slideError = slideError;
    self.brightnessSlider.slideError = slideError;
    self.chromaSlider.slideError = slideError;

}

- (void)cn_startai_showToastWithTitle:(NSString *)title
{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self];
    hud.userInteractionEnabled = false;
    hud.mode = MBProgressHUDModeText;
    hud.label.text = title;
    hud.label.numberOfLines = 0;
    [self addSubview:hud];
    [hud showAnimated:true];
    [hud hideAnimated:true afterDelay:2.0];
}

- (void)updateSliderView
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (appDelegate.conncetType == BAZ_G2_FM) {
        self.modelImg.hidden = true;
        self.leftBtn.hidden = true;
        self.rightBtn.hidden = true;
        self.seqLabel.hidden = true;
        self.leftButton.hidden = true;
        self.rightButton.hidden = true;
    }else{
        self.modelImg.hidden = false;
        self.leftBtn.hidden = false;
        self.rightBtn.hidden = false;
        self.seqLabel.hidden = false;
        self.leftButton.hidden = false;
        self.rightButton.hidden = false;
    }
}

@end
