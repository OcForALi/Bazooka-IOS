//
//  SearchBluetoothView.h
//  Test
//
//  Created by Mac on 2017/12/15.
//  Copyright © 2017年 QiXing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchBluetoothView : UIView

@property (nonatomic, copy) NSString *modelText;
@property (nonatomic, assign) BOOL connected;
@property (nonatomic, assign) BOOL isPull;
@property (nonatomic, copy) void(^connectedPeripheral)();

- (void)goToAnimation;

@end
