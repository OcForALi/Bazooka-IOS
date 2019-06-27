//
//  BluetoothVC.h
//  BluetoothBox
//
//  Created by Mac on 2017/9/15.
//  Copyright © 2017年 Actions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "AppDelegate.h"

@interface BluetoothVC : BaseViewController

-(void)cn_startai_registerAppDelegate:(AppDelegate*)delegate mode:(UInt32)mode;
- (void)cn_startai_pauseSong;
- (void)setvolumeChanged:(CGFloat)voice;
@end
