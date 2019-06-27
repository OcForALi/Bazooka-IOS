//
//  BTSeqListViewCell.m
//  BTMate
//
//  Created by Mac on 2017/8/18.
//  Copyright © 2017年 QiXing. All rights reserved.
//

#import "BTSeqListViewCell.h"
#import "BTSeqListSerialView.h"
#import "BTInpuValueView.h"
#import "BTWheelCustomeSlider.h"
#import "UIColor+HexColor.h"
#import "BTSeqRepeatView.h"

@interface BTSeqListViewCell ()

@property (nonatomic, strong) BTSeqListSerialView *serialView;
@property (nonatomic, strong) UIButton *colorChunkOne;
@property (nonatomic, strong) UIButton *colorChunkTwo;
@property (nonatomic, strong) UIButton *gradientModel;
@property (nonatomic, strong) UIButton *breathModel;
@property (nonatomic, strong) UIButton *flashModel;
@property (nonatomic, strong) UIButton *gradientModelCopy;
@property (nonatomic, strong) UIButton *breathModelCopy;
@property (nonatomic, strong) UIButton *flashModelCopy;
@property (nonatomic, strong) UILabel *onView;
@property (nonatomic, strong) UILabel *offView;
@property (nonatomic, strong) UILabel *brightnessView;
@property (nonatomic, strong) BTWheelCustomeSlider *onSlider;
@property (nonatomic, strong) BTWheelCustomeSlider *offSlider;
@property (nonatomic, strong) BTWheelCustomeSlider *brightnessSlider;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, assign) NSInteger row;
@property (nonatomic, strong) UILabel *onMinLabel;
@property (nonatomic, strong) UILabel *offMinLabel;
@property (nonatomic, strong) UILabel *brightnessMinLabel;

@property (nonatomic, strong) UILabel *onMaxLabel;
@property (nonatomic, strong) UILabel *offMaxLabel;
@property (nonatomic, strong) UILabel *brightnessMaxLabel;

@property (nonatomic, strong) UILabel *repeatLabel;
@property (nonatomic, strong) BTSeqRepeatView *repeatView;


@property (nonatomic, strong) UIImageView *maskView;

@property (nonatomic, assign) NSInteger model;
@property (nonatomic, strong) NSString *nextHexStr;
@property (nonatomic, strong) NSString *hexStr;
@property (nonatomic, assign)  BOOL isModelChange;
@property (nonatomic, assign) NSInteger currentRepeat;

@end

@implementation BTSeqListViewCell

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat off = IS_IPHONE_5_OR_LESS ? 1 : 1.5;
    CGFloat leftOff = IS_IPHONE_5_OR_LESS ? 40 : 57;
    
    [self.serialView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self).offset(0);
        make.width.equalTo(@(SCREEN_WITDH));
        make.height.equalTo(@(55));
    }];
    
    if (!_isGradientModel) {
        self.colorChunkTwo.hidden = true;
        [self.colorChunkOne mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(leftOff);
            make.top.equalTo(self.serialView.mas_bottom).offset(5);
            make.width.equalTo(@(30));
            make.height.equalTo(@(30));
        }];
    }else{
        self.colorChunkTwo.hidden = false;
        [self.colorChunkOne mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(29);
            make.top.equalTo(self.serialView.mas_bottom).offset(5);
            make.width.equalTo(@(30));
            make.height.equalTo(@(30));
        }];
        
        [self.colorChunkTwo mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.colorChunkOne.mas_right).offset(5);
            make.top.equalTo(self.serialView.mas_bottom).offset(5);
            make.width.equalTo(@(30));
            make.height.equalTo(@(30));
        }];
    }
    
    
    
    [self.gradientModel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        if (self.isGradientModel) {
            make.left.equalTo(self.colorChunkTwo.mas_right).offset(15*off);
        }else{
            make.left.equalTo(self.colorChunkOne.mas_right).offset(15*off);
        }
        make.centerY.equalTo(self.colorChunkOne);
        make.width.equalTo(@(50));
        make.height.equalTo(@(20));
    }];
    
    [self.breathModel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.gradientModel.mas_right).offset(15*off);
        make.centerY.equalTo(self.colorChunkOne);
        make.width.equalTo(@(50));
        make.height.equalTo(@(20));
    }];
    
    [self.flashModel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.breathModel.mas_right).offset(15*off);
        make.centerY.equalTo(self.colorChunkOne);
        make.width.equalTo(@(50));
        make.height.equalTo(@(20));
    }];
    
    [self.gradientModelCopy mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.gradientModel);
        make.centerY.equalTo(self.gradientModel);
        make.width.equalTo(@(50));
        make.height.equalTo(@(50));
    }];
    
    [self.breathModelCopy mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.breathModel);
        make.centerY.equalTo(self.breathModel);
        make.width.equalTo(@(50));
        make.height.equalTo(@(50));
    }];
    
    [self.flashModelCopy mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.flashModel);
        make.centerY.equalTo(self.flashModel);
        make.width.equalTo(@(50));
        make.height.equalTo(@(50));
    }];
    

    [self.onView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(leftOff);
        make.top.equalTo(self.colorChunkOne.mas_bottom).offset(22);
        make.width.equalTo(@(50));
        make.height.equalTo(@(20));
    }];
    
    [self.offView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(leftOff);
        make.top.equalTo(self.onView.mas_bottom).offset(35);
        make.width.equalTo(@(50));
        make.height.equalTo(@(20));
    }];
    
    [self.brightnessView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(leftOff);
        make.top.equalTo(self.offView.mas_bottom).offset(35);
        make.width.equalTo(@(50));
        make.height.equalTo(@(20));
    }];
    
    CGFloat width = self.width - 140 ;
    
    [self.onSlider mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.onView.mas_right).offset(0);
        make.centerY.equalTo(self.onView);
        make.width.equalTo(@(width));
        make.height.equalTo(@(12.5*2.0));
    }];
    
    [self.offSlider mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.offView.mas_right).offset(0);
        make.centerY.equalTo(self.offView);
        make.width.equalTo(@(width));
        make.height.equalTo(@(12.5*2.0));
    }];
    
    [self.brightnessSlider mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.brightnessView.mas_right).offset(0);
        make.centerY.equalTo(self.brightnessView);
        make.width.equalTo(@(width/2.0));
        make.height.equalTo(@(12.5*2.0));
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(30));
        make.top.equalTo(self.brightnessSlider.mas_bottom).offset(20);
        make.width.equalTo(@(SCREEN_WITDH - 60));
        make.height.equalTo(@(1));
    }];
    
    
    [self.onMinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.onSlider.mas_left);
        make.top.equalTo(self.onView.mas_bottom).offset(2);
        [self.onMinLabel sizeToFit];
    }];
    
    [self.onMaxLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.onSlider.mas_right).offset(-30);
        make.top.equalTo(self.onView.mas_bottom).offset(2);
        [self.onMaxLabel sizeToFit];
    }];
    
    [self.offMinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.offSlider.mas_left);
        make.top.equalTo(self.offView.mas_bottom).offset(2);
        [self.offMinLabel sizeToFit];
    }];
    
    [self.offMaxLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.offSlider.mas_right).offset(-30);
        make.top.equalTo(self.offView.mas_bottom).offset(2);
        [self.offMaxLabel sizeToFit];
    }];
    
    [self.brightnessMinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.brightnessSlider.mas_left);
        make.top.equalTo(self.brightnessView.mas_bottom).offset(2);
        [self.brightnessSlider sizeToFit];
    }];
    
    [self.brightnessMaxLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.brightnessSlider.mas_right).offset(-30);
        make.top.equalTo(self.brightnessView.mas_bottom).offset(2);
        [self.brightnessMaxLabel sizeToFit];
    }];
    
    [self.repeatLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.brightnessSlider.mas_right).offset(5);
        make.centerY.equalTo(self.brightnessSlider);
        [self.repeatLabel sizeToFit];
    }];
    
    [self.repeatView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.repeatLabel.mas_right).offset(5);
        make.centerY.equalTo(self.repeatLabel);
        make.width.equalTo(@(80));
        make.height.equalTo(@(60));
    }];
    
    [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(@(0));
    }];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.clipsToBounds = false;
        [self cn_startai_initContentView];
    }
    return self;
}

- (void)cn_startai_initContentView
{
    [self addSubview:self.serialView];

    [self addSubview:self.gradientModel];
    [self addSubview:self.breathModel];
    [self addSubview:self.flashModel];
    [self addSubview:self.gradientModelCopy];
    [self addSubview:self.breathModelCopy];
    [self addSubview:self.flashModelCopy];
    [self addSubview:self.onView];
    [self addSubview:self.offView];
    [self addSubview:self.brightnessView];
    [self addSubview:self.onSlider];
    [self addSubview:self.offSlider];
    [self addSubview:self.brightnessSlider];
    [self addSubview:self.line];
    
    [self addSubview:self.onMinLabel];
    [self addSubview:self.onMaxLabel];
    [self addSubview:self.offMinLabel];
    [self addSubview:self.offMaxLabel];
    [self addSubview:self.brightnessMinLabel];
    [self addSubview:self.brightnessMaxLabel];
    [self addSubview:self.repeatLabel];
    [self addSubview:self.repeatView];
    [self addSubview:self.maskView];
    [self addSubview:self.colorChunkOne];
    [self addSubview:self.colorChunkTwo];
}

- (BTSeqListSerialView *)serialView
{
    @weakify(self);
    if (!_serialView) {
        _serialView = [[BTSeqListSerialView alloc] initWithFrame:CGRectZero];
        _serialView.layer.masksToBounds = true;
        _serialView.deleteHandler = ^(NSInteger row) {
            if (weak_self.BTSeqListSerialDeleteHandler) {
                weak_self.BTSeqListSerialDeleteHandler(row);
            }
        };
        _serialView.copyHandler = ^(NSInteger row) {
            if (weak_self.copyHandler) {
                weak_self.copyHandler(row);
            }
        };
    }
    return _serialView;
}

- (UIButton *)colorChunkOne
{
    if (!_colorChunkOne) {
        _colorChunkOne = [UIButton buttonWithType:UIButtonTypeCustom];
        [_colorChunkOne addTarget:self action:@selector(pickColor) forControlEvents:UIControlEventTouchUpInside];
        _colorChunkOne.layer.borderColor = [UIColor colorWithHexColorString:@"333333"].CGColor;
        _colorChunkOne.layer.borderWidth = 1;

    }
    return _colorChunkOne;
}

- (UIButton *)colorChunkTwo
{
    if (!_colorChunkTwo) {
        _colorChunkTwo = [UIButton buttonWithType:UIButtonTypeCustom];
        [_colorChunkTwo addTarget:self action:@selector(pickSecondColor) forControlEvents:UIControlEventTouchUpInside];
        _colorChunkTwo.layer.borderColor = [UIColor colorWithHexColorString:@"333333"].CGColor;
        _colorChunkTwo.layer.borderWidth = 1;

    }
    return _colorChunkTwo;
}

- (UIButton *)gradientModel
{
    if (!_gradientModel) {
        _gradientModel = ({
            UIButton *tmpV = [UIButton buttonWithType:UIButtonTypeCustom];
            [tmpV setTitle:@"Gradient" forState:UIControlStateNormal];
            [tmpV setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            tmpV.tag = GradientModel;
            tmpV.titleLabel.font = [UIFont fontWithName:@"Arial" size:10];
            tmpV.layer.borderColor = [UIColor whiteColor].CGColor;
            tmpV.layer.borderWidth = 1;
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
            tmpV.tag = BreathModel;
            tmpV.titleLabel.font = [UIFont fontWithName:@"Arial" size:10];
            tmpV.layer.borderColor = [UIColor whiteColor].CGColor;
            tmpV.layer.borderWidth = 1;
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
            tmpV.tag = FlashModel;
            tmpV.titleLabel.font = [UIFont fontWithName:@"Arial" size:10];
            tmpV.layer.borderColor = [UIColor whiteColor].CGColor;
            tmpV.layer.borderWidth = 1;
            [tmpV addTarget:self action:@selector(selectedModel:) forControlEvents:UIControlEventTouchUpInside];
            
            tmpV;
        });
    }
    return _flashModel;
}

- (UIButton *)gradientModelCopy
{
    if (!_gradientModelCopy) {
        _gradientModelCopy = ({
            UIButton *tmpV = [UIButton buttonWithType:UIButtonTypeCustom];
            [tmpV setBackgroundColor:[UIColor clearColor]];
            tmpV.tag = GradientModel+100;
            [tmpV addTarget:self action:@selector(selectedModel:) forControlEvents:UIControlEventTouchUpInside];
            
            tmpV;
        });
        
    }
    return _gradientModelCopy;
}

- (UIButton *)breathModelCopy
{
    if (!_breathModelCopy) {
        _breathModelCopy = ({
            UIButton *tmpV = [UIButton buttonWithType:UIButtonTypeCustom];
            [tmpV setBackgroundColor:[UIColor clearColor]];
            tmpV.tag = BreathModel+100;
            [tmpV addTarget:self action:@selector(selectedModel:) forControlEvents:UIControlEventTouchUpInside];
            
            tmpV;
        });
    }
    return _breathModelCopy;
}

- (UIButton *)flashModelCopy
{
    if (!_flashModelCopy) {
        _flashModelCopy = ({
            UIButton *tmpV = [UIButton buttonWithType:UIButtonTypeCustom];
            [tmpV setBackgroundColor:[UIColor clearColor]];
            tmpV.tag = FlashModel+100;
            [tmpV addTarget:self action:@selector(selectedModel:) forControlEvents:UIControlEventTouchUpInside];
            
            tmpV;
        });
    }
    return _flashModelCopy;
}

- (UILabel *)onView
{
    if (!_onView) {
        _onView = ({
            UILabel *tmpV = [[UILabel alloc] initWithFrame:CGRectZero];
            tmpV.text = @"ON";
            tmpV.textColor = [UIColor blackColor];
            tmpV.font = [UIFont fontWithName:@"Arial" size:13];
            
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
            tmpV.font = [UIFont fontWithName:@"Arial" size:13];
            
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
            tmpV.font = [UIFont fontWithName:@"Arial" size:13];
            tmpV.layer.borderColor = [UIColor whiteColor].CGColor;
            tmpV.layer.borderWidth = 0.5;
            
            tmpV;
        });
    }
    return _brightnessView;
}

- (BTWheelCustomeSlider *)onSlider
{
    @weakify(self);
    if (!_onSlider) {
        _onSlider = [[BTWheelCustomeSlider alloc] init];
        _onSlider.lineHeght = 6.5*1.5;
        _onSlider.thumbW = 5*2;
        _onSlider.thumbH = 12.5*2;
        _onSlider.progressImage = [UIImage imageNamed:@"onOffSlider"];
        _onSlider.thumbImage = [UIImage imageNamed:@"blackTriangle"];
        _onSlider.translatesAutoresizingMaskIntoConstraints = false;
        _onSlider.BTWheelCustomeSliderEndValue = ^(CGFloat value) {
            [weak_self ChangeEntity];
        };
//        _onSlider.backgroundColor = [UIColor yellowColor];

    }
    return _onSlider;
}

- (BTWheelCustomeSlider *)offSlider
{
    @weakify(self);
    if (!_offSlider) {
        _offSlider = [[BTWheelCustomeSlider alloc] init];
        _offSlider.lineHeght = 6.5*1.5;
        _offSlider.thumbW = 5*2;
        _offSlider.thumbH = 12.5*2;
        _offSlider.progressImage = [UIImage imageNamed:@"onOffSlider"];
        _offSlider.thumbImage = [UIImage imageNamed:@"blackTriangle"];
        _offSlider.translatesAutoresizingMaskIntoConstraints = false;
        _offSlider.BTWheelCustomeSliderEndValue = ^(CGFloat value) {
            [weak_self ChangeEntity];
        };
//        _offSlider.backgroundColor = [UIColor redColor];

    }
    return _offSlider;
}

-(BTWheelCustomeSlider *)brightnessSlider
{
    @weakify(self);
    if (!_brightnessSlider) {
        _brightnessSlider = [[BTWheelCustomeSlider alloc] init];
        _brightnessSlider.lineHeght = 3.5*1.5;
        _brightnessSlider.thumbW = 5*2;
        _brightnessSlider.thumbH = 12.5*2;
        _brightnessSlider.translatesAutoresizingMaskIntoConstraints = false;
        _brightnessSlider.progressImage = [UIImage imageNamed:@"brighrnessSlider"];
        _brightnessSlider.thumbImage = [UIImage imageNamed:@"blackTriangle"];
        _brightnessSlider.BTWheelCustomeSliderEndValue = ^(CGFloat value) {
            [weak_self ChangeEntity];
        };
//        _brightnessSlider.backgroundColor = [UIColor grayColor];
    }
    return _brightnessSlider;
}

- (UILabel *)onMinLabel
{
    if (!_onMinLabel) {
        _onMinLabel = ({
            UILabel *tmpV = [[UILabel alloc] init];
            tmpV.text = @"10";
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
            tmpV.text = @"10";
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
            tmpV.text = @"10";
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
            tmpV.text = @"100";
            tmpV.textColor = [UIColor grayColor];
            tmpV.font = [UIFont systemFontOfSize:11];
            
            tmpV;
        });
    }
    return _brightnessMaxLabel;
}

- (UILabel *)repeatLabel
{
    if (!_repeatLabel) {
        _repeatLabel = [[UILabel alloc] init];
        _repeatLabel.text = @"Repeat";
        _repeatLabel.font = [UIFont fontWithName:@"Arial" size:13];
    }
    return _repeatLabel;
}

-(BTSeqRepeatView *)repeatView
{
    @weakify(self);
    if (!_repeatView) {
        _repeatView = [[BTSeqRepeatView alloc] initWithFrame:CGRectMake(0, 0, 80, 60)];
        _repeatView.BTSeqReapeatHandler = ^(NSInteger repeat) {
            weak_self.currentRepeat = repeat;
            [weak_self ChangeEntity];
        };
        
    }
    return _repeatView;
}

- (UIView *)line
{
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = [UIColor blackColor];
    }
    return _line;
}

- (UIImageView *)maskView
{
    if (!_maskView) {
        _maskView = [[UIImageView alloc] init];
        _maskView.backgroundColor = [UIColor colorWithHexColorString:@"f2f2f2" withAlpha:0.5];
        _maskView.hidden = true;
        _maskView.userInteractionEnabled = true;

    }
    return _maskView;
}


- (void)pickColor
{
    
    if (self.BTPickColorHandler) {
        self.BTPickColorHandler(self.row);
    }
}

- (void)pickSecondColor
{
    
    if (self.BTPickNextColorHandler) {
        self.BTPickNextColorHandler(self.row);
    }
}


- (void)setCanClickFirstColor:(BOOL)canClickFirstColor
{
    _canClickFirstColor = canClickFirstColor;
    if (!canClickFirstColor) {
        self.colorChunkOne.enabled = false;
    }else{
        self.colorChunkTwo.enabled = true;
    }
}

- (void)setSeqTitle:(NSString *)seqTitle
{
    if ([seqTitle isEqualToString:@"DOME"]) {
        self.maskView.hidden = false;
    }else{
        self.maskView.hidden = true;
    }
}

- (void)setHideDelte:(BOOL)hideDelte
{
    _hideDelte = hideDelte;
    if (hideDelte) {
        self.serialView.hideDelte = true;
    }else
        self.serialView.hideDelte = false;
}


- (void)selectedModel:(UIButton *)btn
{
    if (self.model != btn.tag-100) {
        self.isModelChange = true;
    }
    
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)view;
            button.layer.borderColor = [UIColor whiteColor].CGColor;
        }
    }
    UIButton *butt = [self viewWithTag:btn.tag - 100];
    butt.layer.borderColor = [UIColor orangeColor].CGColor;
    self.colorChunkOne.layer.borderColor = [UIColor colorWithHexColorString:@"333333"].CGColor;
    self.colorChunkTwo.layer.borderColor = [UIColor colorWithHexColorString:@"333333"].CGColor;
    self.model = btn.tag-100;
    self.isGradientModel = self.model == 3 ? true : false;
    [self ChangeEntity];
}

- (void)setValueForBTSeqListViewCell:(BTSeqListCellEntity *)tEntity
{
    self.row = tEntity.serial;
    self.colorChunkOne.backgroundColor = [UIColor colorWithHexColorString:tEntity.hexStr];
    self.colorChunkTwo.backgroundColor = [UIColor colorWithHexColorString:tEntity.nextHexStr];
    [self.serialView setValueWithSerial:tEntity.serial];
    self.onSlider.value = tEntity.onms;
    self.offSlider.value = tEntity.offms;
    self.brightnessSlider.value = tEntity.brigthness;
    self.model = tEntity.modelNum;
    self.isGradientModel = tEntity.isGradientModel;
    self.hexStr = tEntity.hexStr;
    self.nextHexStr = tEntity.nextHexStr;
    self.repeatView.repeat = tEntity.repeat;
    self.isModelChange = false;
    self.currentRepeat = tEntity.repeat;
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)view;
            button.layer.borderColor = [UIColor whiteColor].CGColor;
            if (button.tag == tEntity.modelNum) {
                button.layer.borderColor = [UIColor orangeColor].CGColor;
            }
        }
    }
    self.colorChunkOne.layer.borderColor = [UIColor colorWithHexColorString:@"333333"].CGColor;
    self.colorChunkTwo.layer.borderColor = [UIColor colorWithHexColorString:@"333333"].CGColor;
    [self layoutIfNeeded];

}

- (void)ChangeEntity
{
    BTSeqListCellEntity *entity = [[BTSeqListCellEntity alloc] init];
    entity.serial = self.row;
    entity.onms = self.onSlider.KValue;
    entity.offms = self.offSlider.KValue ;
    entity.brigthness = self.brightnessSlider.KValue;
    entity.modelNum = self.model;
    entity.isGradientModel = self.isGradientModel;
    entity.nextHexStr = self.nextHexStr;
    entity.hexStr = self.hexStr;
    entity.isModelChanged = self.isModelChange;
    entity.repeat = self.currentRepeat;
    
    if (self.BTSeqListViewCellChangeEntity) {
        self.BTSeqListViewCellChangeEntity(entity);
    }
}

- (void)update:(BTSeqListCellEntity *)entity
{
    if (self.BTSeqListViewCellChangeEntity) {
        self.BTSeqListViewCellChangeEntity(entity);
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if(self.CancleEditingHandler){
        self.CancleEditingHandler();
    }
}

@end
