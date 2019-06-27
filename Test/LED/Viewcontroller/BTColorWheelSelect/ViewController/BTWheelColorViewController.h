//
//  BTWheelColorViewController.h
//  BTMate
//
//  Created by Mac on 2017/8/18.
//  Copyright © 2017年 QiXing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface BTWheelColorViewController : UIViewController

@property (nonatomic ,assign) BOOL isFM;

-(void)cn_startai_registerAppDelegate:(AppDelegate*)delegate mode:(uint32_t)mode;

-(void)cn_startai_getSaveList;

@end
