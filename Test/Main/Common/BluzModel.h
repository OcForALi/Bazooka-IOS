//
//  BluzModel.h
//  Test
//
//  Created by Mac on 2017/10/24.
//  Copyright © 2017年 QiXing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@protocol BluzProtocolDelegate <NSObject>
///蓝牙连接失败 5s 判断为连接失败
- (void)connectionFailed:(NSString *)name;
///蓝牙搜索列表 60s 无搜索到ble设备 搜索超时
- (void)searchListOvertime;

- (void)refershPeripheral:(NSMutableArray *)peripherialArr;

- (void)connectedPeripheralSucess:(NSString *)name;

- (void)HandleEvent:(NSString *)hand;

@optional

@end

@interface BluzModel : NSObject

@property (nonatomic, weak) id<BluzProtocolDelegate>delegate;
@property (nonatomic, strong) NSMutableArray *peripheralArr;
@property (nonatomic, assign) NSInteger connectPeripheralIndex;
@property (nonatomic, assign) BOOL disconnectedBySelf;      //是否主动断开
@property (nonatomic, assign) BOOL isUsbModel;

- (BOOL)connected;
+ (BluzModel *)shareInstance;
- (AppDelegate *)getAppDelegate;
- (void)GetReady;
- (void)disConnected;
-(void)modeChanged:(UInt32)mode;

@end
