//
//  FMSliderView.h
//  Test
//
//  Created by Mac on 2017/9/26.
//  Copyright © 2017年 QiXing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FMSliderView : UIView

@property (nonatomic, assign) CGFloat fmValue;

@property (nonatomic, assign) CGFloat getValue;

@property (nonatomic, copy) void (^fmValueHandler)(CGFloat value);

@end
