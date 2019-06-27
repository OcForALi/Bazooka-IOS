//
//  SendPopView.h
//  Test
//
//  Created by Mac on 2017/10/13.
//  Copyright © 2017年 QiXing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SendPopView : UIView

@property (nonatomic, strong) void (^sendSucessdHandler)();

- (void)sendSucessNum:(NSInteger)sendNum Total:(NSInteger)total;

@end
