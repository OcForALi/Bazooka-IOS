//
//  BTSaveSeqListViewController.h
//  BTMate
//
//  Created by Mac on 2017/8/22.
//  Copyright © 2017年 QiXing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "AppDelegate.h"

@interface BTSaveSeqListViewController : UIViewController

- (void)cn_startai_registerAppDelegate:(AppDelegate *)delegate mode:(uint32_t)mode;

- (void)writeSeqColor;
- (void)cn_startai_getDefaultSaveList;
- (void)cn_startai_sendSeq;

@end
