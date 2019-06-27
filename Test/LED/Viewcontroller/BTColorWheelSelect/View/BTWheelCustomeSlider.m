//
//  BTWheelCustomeSlider.m
//  BTMate
//
//  Created by Mac on 2017/8/21.
//  Copyright © 2017年 QiXing. All rights reserved.
//

#import "BTWheelCustomeSlider.h"

@interface BTWheelCustomeSlider ()

@property (nonatomic, strong) UIImageView *proessBg;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) UIImageView *chunkImg;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, strong) UILabel *min; //进度条左边文案
@property (nonatomic, strong) UILabel *max; //进度条右边文案
@end

@implementation BTWheelCustomeSlider

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat width = self.show?self.width - 50 : self.width-20;
    self.min.hidden = !self.show;
    self.max.hidden = !self.show;
    
    self.progressView.frame = CGRectMake((self.width - width)/2.0, (self.height-self.lineHeght)/2.0, width, self.lineHeght);
    self.proessBg.frame = CGRectMake((self.width - width)/2.0, (self.height-self.lineHeght)/2.0, width, self.lineHeght);
    self.chunkImg.frame = CGRectMake(self.progressView.left + (self.progressView.width-self.thumbW)*_value, (self.height - self.thumbH)/2.0, self.thumbW, self.thumbH);
    
    [self.min mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.progressView.mas_left).offset(-3);
        make.centerY.equalTo(self);
        [self.min sizeToFit];
    }];
    
    [self.max mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.progressView.mas_right).offset(3);
        make.centerY.equalTo(self);
        [self.max sizeToFit];
    }];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.clipsToBounds = YES;
        self.slideError = false;
        self.minimumValue = 0;
        self.maximumValue = 1.0;
        [self cn_startai_initContentView];
    }
    return self;
}

- (void)cn_startai_initContentView
{
    [self addSubview:self.min];
    [self addSubview:self.proessBg];
    [self addSubview:self.progressView];
    [self addSubview:self.max];
    [self addSubview:self.chunkImg];
    [self.progressView addGestureRecognizer:self.tapGesture];

    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    pan.minimumNumberOfTouches = 1;
    [self addGestureRecognizer:pan];
}


- (UITapGestureRecognizer *)tapGesture
{
    if (!_tapGesture) {
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeValue:)];
        _tapGesture.numberOfTapsRequired = 1;
        _tapGesture.numberOfTouchesRequired = 1;
    }
    return _tapGesture;
}

- (UILabel *)min
{
    if (!_min) {
        _min = [[UILabel alloc] init];
        _min.text = @"MIN";
        _min.textColor = [UIColor whiteColor];
        _min.font = [UIFont systemFontOfSize:8];
    }
    return _min;
}

- (UILabel *)max
{
    if (!_max) {
        _max = [[UILabel alloc] init];
        _max.text = @"MAX";
        _max.textColor = [UIColor whiteColor];
        _max.font = [UIFont systemFontOfSize:8];
    }
    return _max;
}

- (UIImageView *)proessBg
{
    if (!_proessBg) {
        _proessBg = [[UIImageView alloc] init];
        _proessBg.backgroundColor = [UIColor clearColor];
//        _proessBg.contentMode = UIViewContentModeScaleAspectFill;
        _proessBg.layer.masksToBounds = true;

    }
    return _proessBg;
}

- (UIProgressView *)progressView
{
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectZero];
        _progressView.progressViewStyle = UIProgressViewStyleDefault;
        _progressView.userInteractionEnabled = true;
    }
    return _progressView;
}

- (UIImageView *)chunkImg
{
    if (!_chunkImg) {
        _chunkImg = [[UIImageView alloc] initWithFrame:CGRectZero];
//        _chunkImg.layer.cornerRadius = 10;
    }
    return _chunkImg;
}

- (void)changeValue:(UITapGestureRecognizer *)tap
{
//    if (_slideError){
//        if (self.BTWheelCustomeSliderError) {
//            self.BTWheelCustomeSliderError();
//        }
//        return;
//    }
    CGPoint tempPoint = [tap locationInView:tap.view];
    self.chunkImg.left = tempPoint.x;
    [self.progressView setProgress:tempPoint.x/self.width animated:NO];
    if (tempPoint.x<self.progressView.left) {
        self.chunkImg.left = self.progressView.left;
    }else if (tempPoint.x>self.progressView.right-self.chunkImg.width){
        self.chunkImg.right = self.progressView.right;
    }else{
        self.chunkImg.left = tempPoint.x;
    }
    CGFloat offx = (tempPoint.x-self.proessBg.left)/(self.proessBg.width-self.chunkImg.width);
    if (offx>1) {
        offx = 1.0;
    }else if (offx<0){
        offx = 0.0;
    }
    
    self.progressView.progress = offx;
    if (self.BTWheelCustomeSliderValue) {
        self.BTWheelCustomeSliderValue(offx);
    }
    
    if (self.BTWheelCustomeSliderIntValue) {
        self.BTWheelCustomeSliderIntValue((round)(offx*_maximumValue));
    }
    
    if (self.BTWheelCustomeSliderIntValue) {
        self.BTWheelCustomeSliderIntValue((int)(offx*_maximumValue));
    }
}

- (void)panAction:(UIPanGestureRecognizer *)pan
{
    CGPoint tempPoint = [pan locationInView:pan.view];
    [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"change"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.progressView setProgress:tempPoint.x/self.width animated:NO];
    if (tempPoint.x<self.progressView.left) {
        self.chunkImg.left = self.progressView.left;
    }else if (tempPoint.x>self.progressView.right- self.chunkImg.width){
        self.chunkImg.left = self.progressView.right-self.chunkImg.width;
    }else{
        self.chunkImg.left = tempPoint.x;
    }
    CGFloat offx = (tempPoint.x-self.proessBg.left)/(self.proessBg.width-self.chunkImg.width);
    
    if (offx>1) {
        offx = 1.0;
    }else if (offx<0){
        offx = 0.0;
    }
    self.progressView.progress = offx;
    
    if (self.BTWheelCustomeSliderValue) {
        self.BTWheelCustomeSliderValue(offx);
    }
    
    if (self.BTWheelCustomeSliderIntValue) {
        self.BTWheelCustomeSliderIntValue((round)(offx*_maximumValue));
    }
    
    if (pan.state == UIGestureRecognizerStateEnded) {
        if (self.BTWheelCustomeSliderEndValue) {
            self.BTWheelCustomeSliderEndValue(offx);
        }
        [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"change"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)change
{
    
}

-(CGFloat)KValue
{
    return self.progressView.progress;
}

- (void)setMinimumTrackTintColor:(UIColor *)minimumTrackTintColor
{
    self.progressView.progressTintColor = minimumTrackTintColor;
}

- (void)setMaximumTrackTintColor:(UIColor *)maximumTrackTintColor
{
    self.progressView.trackTintColor = maximumTrackTintColor;
}

- (void)setValue:(CGFloat)value
{

    if (value > 0 && value < 1) {
        _value = value;
    }else if (value >1){
        return;
    }else if (value == 0){
        _value = 0;
    } else{
        return;
    }

    [self.progressView setProgress:_value];
    [self layoutSubviews];
    
}

- (void)setThumbTintColor:(UIColor *)thumbTintColor
{
    self.chunkImg.backgroundColor = thumbTintColor;
}

- (void)setThumbImage:(UIImage *)thumbImage
{
    self.chunkImg.image = thumbImage;
}

- (void)setProgressImage:(UIImage *)progressImage
{
    self.proessBg.image = progressImage;
//    self.progressView.progressTintColor = [UIColor colorWithPatternImage:progressImage];
//    self.progressView.trackTintColor = [UIColor colorWithPatternImage:progressImage];
    self.progressView.progressTintColor = [UIColor clearColor];
    self.progressView.trackTintColor = [UIColor clearColor];
}

- (void)setImgModel:(BOOL)imgModel
{
    if (imgModel) {
        self.proessBg.layer.masksToBounds = false;
    }
}


- (void)setMinimumValue:(CGFloat)minimumValue
{
    _minimumValue = minimumValue;
}

- (void)setMaximumValue:(CGFloat)maximumValue
{
    _maximumValue = maximumValue;
}

@end
