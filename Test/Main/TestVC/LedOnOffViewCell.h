//
//  LedOnOffViewCell.h
//  Test
//
//  Created by Mac on 2017/12/13.
//  Copyright © 2017年 QiXing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LedOnOffViewCell : UITableViewCell

@property (nonatomic, strong) UITextField *commandTextfiled;

@property (nonatomic, strong) UITextField *repeatTextfiled;

@property (nonatomic, strong) UITextField *intervalTimeTextfiled;

@property (nonatomic, copy) void(^tapSendHandler)();

@end
