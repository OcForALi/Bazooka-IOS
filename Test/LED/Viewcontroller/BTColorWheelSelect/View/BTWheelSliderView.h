//
//  BTWheelSliderView.h
//  BTMate
//
//  Created by Mac on 2017/8/21.
//  Copyright © 2017年 QiXing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BTWheelSliderView : UIView

@property (nonatomic, copy) void(^BrightnessValueHandler)(CGFloat value);
@property (nonatomic, copy) void(^ChromaValueHandler)(CGFloat value);
@property (nonatomic, copy) void(^ModelValueHandler)(NSString *flashName);
@property (nonatomic, strong) UILabel *seqLabel;    //当前闪法名称
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, assign) BOOL isPopup;
@property (nonatomic, assign) BOOL slideError;

- (void)updateSliderView;

@end
