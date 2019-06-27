//
//  SendResultView.h
//  Test
//
//  Created by Mac on 2018/1/4.
//  Copyright © 2018年 QiXing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SendResultView : UIView

@property (nonatomic, strong) void (^sendSucessdHandler)();
@property (nonatomic, copy) NSString *title;

@end
