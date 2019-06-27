//
//  BluetoothSerarchView.h
//  Test
//
//  Created by Mac on 2017/11/2.
//  Copyright © 2017年 QiXing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BluetoothSerarchView : UIView

@property (nonatomic, copy) void(^BluetoothSelectedPeripheral)(NSInteger index);
@property (nonatomic, weak) NSMutableArray *dataArr;

@end
