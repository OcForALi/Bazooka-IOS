//
//  BTWheelPickColorView.h
//  Test
//
//  Created by Mac on 2017/12/21.
//  Copyright © 2017年 QiXing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTWheelRGBEntity.h"

typedef void(^getColorValueHandler)(BTWheelRGBEntity *rgb);

@interface BTWheelPickColorView : UIView

@property (nonatomic, strong) BTWheelRGBEntity *rgb;
@property (nonatomic, copy) getColorValueHandler colorHandle;

- (void)updateColorValueWithRed:(NSInteger)red Green:(NSInteger)green Blue:(NSInteger)blue;



@end
