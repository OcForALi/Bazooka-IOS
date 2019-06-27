//
//  ExternalControlViewController.h
//  Test
//
//  Created by Mac on 2017/11/3.
//  Copyright © 2017年 QiXing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "BaseViewController.h"
@interface ExternalControlViewController : BaseViewController

@property (nonatomic, assign) BOOL isConnected;

-(void)cn_startai_registerAppDelegate:(AppDelegate*)delegate mode:(UInt32)mode;

@end
