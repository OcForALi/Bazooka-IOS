//
//  BTSeqListViewController.h
//  BTMate
//
//  Created by Mac on 2017/8/18.
//  Copyright © 2017年 QiXing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "AppDelegate.h"

@interface BTSeqListViewController : UIViewController

@property (nonatomic, copy) NSString *seqTitle;

- (void)cn_startai_registerAppDelegate:(AppDelegate *)delegate mode:(uint32_t)mode;

@end
