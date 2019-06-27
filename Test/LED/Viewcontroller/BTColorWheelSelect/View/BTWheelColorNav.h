//
//  BTWheelColorNav.h
//  BTMate
//
//  Created by Mac on 2017/8/18.
//  Copyright © 2017年 QiXing. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ColorValueDisplay)();
typedef void(^menuClickHandelr)();
typedef void(^popLastVC)();

@interface BTWheelColorNav : UIView

@property (nonatomic, copy) popLastVC popHandler;
@property (nonatomic, copy) ColorValueDisplay colorhandler;
@property (nonatomic, copy) menuClickHandelr menuHandler;


- (void)updateNavgation;
- (void)updateColorValueWithRed:(NSInteger)red Green:(NSInteger)green Blue:(NSInteger)blue;

@end
