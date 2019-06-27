//
//  BTInpuValueView.h
//  BTMate
//
//  Created by Mac on 2017/8/18.
//  Copyright © 2017年 QiXing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BTInpuValueView : UIView

@property (nonatomic, copy) void(^BTInpuValueHandler)(NSInteger value);
@property (nonatomic, strong) UITextField *textField;

- (void)setValueWithTitle:(NSString *)title Value:(NSInteger)value;


@end
