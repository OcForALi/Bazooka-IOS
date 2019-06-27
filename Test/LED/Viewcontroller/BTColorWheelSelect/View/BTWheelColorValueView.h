//
//  BTWheelColorValueView.h
//  BTMate
//
//  Created by Mac on 2017/8/18.
//  Copyright © 2017年 QiXing. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ColorValueDisplay)();


@interface BTWheelColorValueView : UIView

@property (nonatomic, copy) ColorValueDisplay colorhandler;


- (void)updateColorValueWithRed:(NSInteger)red Green:(NSInteger)green Blue:(NSInteger)blue;


@end
