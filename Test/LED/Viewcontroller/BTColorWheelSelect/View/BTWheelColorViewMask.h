//
//  BTWheelColorViewMask.h
//  BTMate
//
//  Created by Mac on 2017/8/18.
//  Copyright © 2017年 QiXing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTWheelRGBEntity.h"

typedef void(^ColorViewMaskCancle)(BTWheelRGBEntity *rgb);

@interface BTWheelColorViewMask : UIView

@property (nonatomic, copy) ColorViewMaskCancle cancleHandle;


- (void)updateColorValueWithRed:(NSInteger)red Green:(NSInteger)green Blue:(NSInteger)blue;


@end
