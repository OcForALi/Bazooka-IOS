//
//  BTWheelCustomeSlider.h
//  BTMate
//
//  Created by Mac on 2017/8/21.
//  Copyright © 2017年 QiXing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BTWheelCustomeSlider : UIView

@property (nonatomic, assign) CGFloat lineHeght;
@property (nonatomic, assign) CGFloat thumbW;
@property (nonatomic, assign) CGFloat thumbH;

@property (nonatomic, strong) UIColor *minimumTrackTintColor;
@property (nonatomic, strong) UIColor *maximumTrackTintColor;
@property (nonatomic, assign) CGFloat minimumValue;
@property (nonatomic, assign) CGFloat maximumValue;
@property (nonatomic, assign) CGFloat value;
@property (nonatomic, strong) UIColor *thumbTintColor;

@property (nonatomic, strong) UIImage* progressImage;
@property (nonatomic, strong) UIImage* thumbImage;
@property (nonatomic, assign) BOOL show;        //展示左右两端文案

@property (nonatomic, assign) CGFloat KValue;
@property (nonatomic, assign) BOOL slideError;

@property (nonatomic, assign) BOOL imgModel;    //背景是否是图片

@property (nonatomic, copy) void(^BTWheelCustomeSliderEndValue)(CGFloat value);
@property (nonatomic, copy) void(^BTWheelCustomeSliderValue)(CGFloat value);
@property (nonatomic, copy) void(^BTWheelCustomeSliderIntValue)(int value);
@property (nonatomic, copy) void(^BTWheelCustomeSliderError)();
@end
