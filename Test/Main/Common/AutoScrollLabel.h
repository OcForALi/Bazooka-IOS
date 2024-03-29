//
//  AutoScrollLabel.h
//  Test
//
//  Created by Mac on 2018/1/4.
//  Copyright © 2018年 QiXing. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    JJTextCycleStyleDefault, //当文字长度大于label长度的长度才可以进行滚动
    JJTextCycleStyleAlways,  //无论文字长短，一直滚动
}  JJTextCycleStyle;

IB_DESIGNABLE
@interface AutoScrollLabel : UIView

@property (nonatomic, assign) JJTextCycleStyle style; //默认ORTextCycleStyleDefault
@property (nonatomic, assign)IBInspectable CGFloat interval; //间隔 默认 70
@property (nonatomic, assign)IBInspectable CGFloat rate;//速率 0~1 默认 0.5

@property (nonatomic, copy)IBInspectable NSString *text;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong)IBInspectable UIColor *textColor;
@property (nonatomic, assign) NSTextAlignment textAlignment;

- (void)start; //默认开启
- (void)pause;
- (void)stop;

@end

