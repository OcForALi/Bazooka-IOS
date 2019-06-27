//
//  ExternalView.h
//  Test
//
//  Created by Mac on 2017/11/3.
//  Copyright © 2017年 QiXing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExternalView : UIView

@property (nonatomic, strong) UIButton *nameBtn;
@property (nonatomic, assign) BOOL onOffState;
@property (nonatomic, assign) NSInteger serial;
@property (nonatomic, copy) void(^cliekDeviceHandler)(BOOL selected);
@property (nonatomic, copy) void(^changeNameHandler)(NSInteger serial);
@property (nonatomic, copy) NSString *title;
@end
