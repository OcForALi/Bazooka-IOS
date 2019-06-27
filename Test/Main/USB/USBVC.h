//
//  USBVC.h
//  BluetoothBox
//
//  Created by Mac on 2017/9/18.
//  Copyright © 2017年 Actions. All rights reserved.
//

#import "BaseViewController.h"
#import "AppDelegate.h"

@interface USBVC : BaseViewController

@property (nonatomic, assign) BOOL isConnected;
@property (nonatomic, assign) BOOL canUseUSB;
@property (nonatomic, copy) void(^GotoConnectPeripheral)();

-(void)cn_startai_registerAppDelegate:(AppDelegate*)delegate mode:(UInt32)mode;
//- (void)cn_startai_pauseSong;
- (void)setvolumeChanged:(CGFloat)voice;

@end
