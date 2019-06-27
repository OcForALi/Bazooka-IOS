//
//  BTSaveSeqListBottom.h
//  BluetoothBox
//
//  Created by Mac on 2017/9/20.
//  Copyright © 2017年 Actions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BTSaveSeqListBottom : UIView

@property (nonatomic, copy) void(^transHandler)();
@property (nonatomic, copy) void(^restHandler)();
@property (nonatomic, copy) void(^updateHandler)();

@end
