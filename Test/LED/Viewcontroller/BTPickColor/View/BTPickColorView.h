//
//  BTPickColorView.h
//  Test
//
//  Created by Mac on 2017/12/25.
//  Copyright © 2017年 QiXing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTWheelRGBEntity.h"

@interface BTPickColorView : UIView

@property (nonatomic, copy) void(^getColorValueHandler)(BTWheelRGBEntity *rgb);
@property (nonatomic, copy) void(^addColorHandler)(BTWheelRGBEntity *rgb);
@end
