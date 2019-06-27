//
//  BluzModel.m
//  Test
//
//  Created by Mac on 2017/10/24.
//  Copyright © 2017年 QiXing. All rights reserved.
//

#import "BluzModel.h"
#import "AppDelegate.h"
#include <CommonCrypto/CommonDigest.h>
#define FileHashDefaultChunkSizeForReadingData 1024*8
@interface  BluzModel ()<GlobalManager,ConnectDelegate,CBCentralManagerDelegate>
{
    AppDelegate *app;
    CBCentralManager *manb;
    CBPeripheral *myPeripheral;
    BOOL peripheralConneted;    //蓝牙连接状态
    BOOL reconnection;  //重连
    BOOL state;
}

@end

@implementation BluzModel

+ (BluzModel *)shareInstance
{
    static id instacne;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instacne = [[self alloc] init];
    });
    return instacne;
}

- (instancetype)init
{
    if (self = [super init]) {
        app = [UIApplication sharedApplication].delegate;
    }
    return self;
}

- (NSMutableArray *)peripheralArr
{
    if (!_peripheralArr) {
        _peripheralArr = [NSMutableArray array];
    }
    return _peripheralArr;
}

- (void)GetReady
{
    manb = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
//    if (!app.player) {
//        app.player = [[LoaclMusic alloc] init];
//        [app.player getData];
//    }
}

/**
 查看中心设备是否打开蓝牙
 */
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    switch (central.state) {
        case CBManagerStateUnknown:
            NSLog(@"unknown");
            state = false;
            break;
        case CBManagerStateResetting:
            NSLog(@"resetting");
            state = false;
            break;
        case CBManagerStateUnsupported:
            NSLog(@"unsupported");
            state = false;
            break;
        case CBManagerStateUnauthorized:
            NSLog(@"unauthorized");
            state = false;
            break;
        case CBManagerStatePoweredOff:
         
            NSLog(@"poweredOff");
            state = false;
            if (app.mBluzConnector) {
                [app.mBluzConnector scanStop];
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SystemGotConnectPeripheral" object:nil];
            
            break;
        case CBManagerStatePoweredOn:
            NSLog(@"poweredOn");
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CBManagerStatePoweredOn" object:nil];
            state = true;
            [self openBluetooth];
            //扫描周围外设
            break;
            
        default:
            break;
    }
    if (!state) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SystemGotConnectPeripheral" object:nil];
        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"SetBluetooth", nil) message:NSLocalizedString(@"BuettoothClose", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", nil) otherButtonTitles:NSLocalizedString(@"setUp", nil), nil];
//        [alert show];
        
        return;
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    id alertbutton = [alertView buttonTitleAtIndex:buttonIndex];
    
    NSString *string = [NSString stringWithFormat:@"%@",alertbutton];
    if ([string isEqualToString:@"设置"]) {
        
        NSURL *url = [NSURL URLWithString:@"App-Prefs:root=Bluetooth"];
        if ([[UIApplication sharedApplication]canOpenURL:url]) {
            
            [[UIApplication sharedApplication]openURL:url];
        }
        
    }
    
}

- (void)openBluetooth
{
    if (!state) {
        return;
    }
    app.mBluzConnector = [[BluzDevice alloc] init];
    [app.mBluzConnector setConnectDelegate:self];
    [app.mBluzConnector setAppForeground:true];
    [app.mBluzConnector scanStart];
    
    if ([self.delegate respondsToSelector:@selector(searchListOvertime)]) {
        [self.delegate searchListOvertime];
    }
    
}


#pragma mark - ConnectDelegate

- (void)foundPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData
{
    
//    NSData *adver = [advertisementData objectForKey:@"kCBAdvDataManufacturerData"];
//    NSString *mac = [[NSString alloc] initWithData:adver encoding:NSUTF8StringEncoding];
    NSString* deviceName = [advertisementData objectForKey:CBAdvertisementDataLocalNameKey];
    NSLog(@"foundPeripheral-------------------------------------------- %@", deviceName);
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    for (NSMutableDictionary *dic in self.peripheralArr) {
       CBPeripheral *per =  [dic objectForKey:@"peripheral"];
        if ([self isPeripheral:per equalPeripheral:peripheral]) {
            //如果前面存储过此外设
            return;
        }
    }
    
    if ([self isPeripheral:peripheral equalPeripheral:myPeripheral]) {
        myPeripheral = peripheral;
        [app.mBluzConnector connect:myPeripheral];
        return;
    }
    
    if (deviceName != nil && deviceName != NULL && deviceName.length && deviceName) {
        [dic setObject:deviceName forKey:@"name"];
        [dic setObject:peripheral forKey:@"peripheral"];
        [self.peripheralArr addObject:dic];
    }
    
    if ([self.delegate respondsToSelector:@selector(refershPeripheral:)]) {
        [self.delegate refershPeripheral:self.peripheralArr];
    }

}

- (void)connectedPeripheral:(CBPeripheral *)peripheral
{
//    @weakify(self);
    peripheralConneted = true;
    myPeripheral = peripheral;
    app.isConnected = true;
    app.mMediaManager = [[BluzManager alloc] initWithConnector:app.mBluzConnector];
    app.globalManager = [app.mMediaManager getGlobalManager:self];
    if ([self.delegate respondsToSelector:@selector(connectedPeripheralSucess:)]) {
        [self.delegate connectedPeripheralSucess:peripheral.name];
    }
    app.model = 99;
    int key = [app.globalManager buildKey:QUE cmdID:0x80];
    if (key!=-1) {
        [app.globalManager sendCustomCommand:key param1:0 param2:0 others:nil];
    }
  
}

- (void)disconnectedPeripheral:(CBPeripheral *)peripheral
{
    peripheralConneted = false;
    reconnection = false;
    [app.mBluzConnector close];
    [app.mMediaManager close];
    [app.globalManager close];
    app.mMediaManager = nil;
    app.globalManager = nil;
    app.musicManager = nil;
    app.radioManager = nil;
    app.auxManager = nil;
    app.mBluzConnector = nil;
    app.isConnected = false;
    _peripheralArr = nil;

    if (!self.disconnectedBySelf) {
        myPeripheral = peripheral;
//        [app.mBluzConnector connect:myPeripheral];
//        reconnection = true;
        if ([self.delegate respondsToSelector:@selector(HandleEvent:)]) {
            [self.delegate HandleEvent:@"break"];
        }
//        [self GetReady];
    }else{
        myPeripheral = nil;
        if ([self.delegate respondsToSelector:@selector(HandleEvent:)]) {
            [self.delegate HandleEvent:@"off"];
        }
    }
}


-(BOOL)isPeripheral:(CBPeripheral*)peripheral1 equalPeripheral:(CBPeripheral*)peripheral2 {
    if (peripheral1 == nil || peripheral2 == nil) {
        return NO;
    }
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
#ifndef __IPHONE_9_0
        return peripheral1.UUID == peripheral2.UUID;
#endif
    } else {
        return [peripheral1.identifier isEqual: peripheral2.identifier];
    }
    
    return NO;
}

#pragma mark --------------------------------------GlobalDelegate

#pragma mark 收到自定义命令回调，处理返回信息
- (void)customCommandArrived:(UInt32)cmdKey param1:(UInt32)arg1 param2:(UInt32)arg2 others:(NSData *)data
{
    NSLog(@"收到消息....................>%@",data);
//    if (cmdKey == [app.globalManager buildKey:ANS cmdID:0x80] && !reconnection) {
//        int index = 0;
//        Byte* bytes = (Byte*)malloc(data.length);
//        memcpy(bytes, [data bytes], data.length);
//
//        NSString *var = [self bytes2String:bytes+index length:5 encode:bytes[7]];
//        index += 8;
//        NSString *name = [self bytes2String:bytes+index length:56 encode:bytes[7]];
//
//        NSString *title = NSLocalizedString(@"deviceinfo", nil);
//        NSString *message = [[NSString alloc] initWithString:[NSString stringWithFormat:@"%@: %@\n%@: %@", NSLocalizedString(@"name", nil), name, NSLocalizedString(@"version", nil), var]];
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:NSLocalizedString(@"ok", nil) otherButtonTitles:nil, nil];
//        [alert show];
//    }
}

#pragma mark 准备就绪
- (void)managerReady
{
    
}

#pragma mark 音箱功能模式变化
-(void)modeChanged:(UInt32)mode
{
//    if (mode == 2) {
//        self.isUsbModel = true;
//    }else{
//        self.isUsbModel = false;
//    }

    if (app.model == 99) {
        app.model = mode;
        return;
    }

    if (mode == 14) {
        
    }else if (mode == 0){
        
        [app.usbSpeakerManager pause];
        [app.musicManager pause];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RegistrationMode" object:[NSString stringWithFormat:@"%@", [NSString stringWithFormat:@"%ld",app.model]]];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"musicStart" object:[NSString stringWithFormat:@""]];
        app.model = mode;
        
    }else if (mode == 2){
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"musicSuspended" object:[NSString stringWithFormat:@""]];
        [app.musicManager pause];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RegistrationMode" object:[NSString stringWithFormat:@"%@", [NSString stringWithFormat:@"%ld",app.model]]];
        
        [app.usbSpeakerManager play];
        app.model = mode;
    }else if (mode == 3){
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"musicSuspended" object:[NSString stringWithFormat:@""]];
        [app.usbSpeakerManager pause];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RegistrationMode" object:[NSString stringWithFormat:@"%@", [NSString stringWithFormat:@"%ld",app.model]]];
        
        [app.musicManager play];
        app.model = mode;
    }else if (mode == 4){
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"musicSuspended" object:[NSString stringWithFormat:@""]];
        [app.usbSpeakerManager pause];
        [app.musicManager pause];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RegistrationMode" object:[NSString stringWithFormat:@"%ld",app.model]];
        app.model = mode;
    }else{
        app.model = mode;
    }
    
    NSLog(@"音箱当前模式 ---- %u , -存储的模式%ld",(unsigned int)mode,app.model);
    
}

#pragma mark 音箱音效模式变化
-(void)soundEffectChanged:(UInt32)mode
{
    
}

#pragma mark  EQ模式变化
-(void)eqModeChanged:(UInt32)mode
{
    
}

#pragma mark 音箱电池电量或充放电状态变化
-(void)batteryChanged:(UInt32)battery charging:(BOOL)charging
{
    
}

#pragma mark 音箱静音及音量状态变化
-(void)volumeChanged:(UInt32)current max:(UInt32)max min:(UInt32)min isMute:(BOOL)mute
{
    app.currentVoice = current;
    app.maxVoice = max;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"speakerVolumeChange" object:nil];
}

#pragma mark 音箱外置卡插拔状态变化
-(void)hotplugCardChanged:(BOOL)visibility
{
    
}


#pragma mark 音箱外置U盘插拔状态变化
-(void)hotplugUhostChanged:(BOOL)visibility
{
    app.canUseUSB = visibility;
}

#pragma mark USB线插拔状态变化
-(void)hotplugUSBChanged:(BOOL)visibility
{
    
}

#pragma mark 音箱Linein连接线插拔状态变化
-(void)lineinChanged:(BOOL)visibility
{
    
}

#pragma mark 显示音箱对话框
-(void)dialogMessageArrived:(UInt32)type messageID:(UInt32)messageId
{
    
}

#pragma mark 显示音箱提示信息
-(void)toastMessageArrived:(UInt32)messageId
{
    
}

#pragma mark 取消音箱提示信息
-(void)dialogCancel
{
    
}

#pragma mark DAE音效模式变化
-(void)daeModeChangedWithVBASS:(BOOL)vbassEnable andTreble:(BOOL)trebleEnable
{
    
}

#pragma mark DAE音效模式变化
-(void)daeModeChangedWithVBASS:(BOOL)vbassEnable treble:(BOOL)trebleEnable surround:(BOOL)surroundEnable
{
    
}

#pragma mark DAE音效模式变化
-(void)daeModeChanged:(int)daeOpts
{
    
}

#pragma mark 数据处理
-(NSString*)bytes2String:(Byte*)bytes length:(int)length encode:(int)encode {
    NSStringEncoding type = [self getEncodeType:encode];
    int count = 0;
    if (type == NSUTF16LittleEndianStringEncoding || type == NSUTF16BigEndianStringEncoding) {
        while (count + 1 < length) {
            if (bytes[count] == 0 && bytes[count + 1] == 0) {
                break;
            }
            count += 2;
        }
    } else {
        while (count < length) {
            if (bytes[count] == '\0') {
                break;
            }
            count++;
        }
    }
    
    NSString* strRet = [[NSString alloc] initWithBytes:bytes length:count encoding:type];
    if (strRet != nil && strRet.length == 0) {
        strRet = nil;
    }
    return strRet;
}

-(NSStringEncoding)getEncodeType:(NSInteger)encode {
    if(encode == 0){         //"GBK"
        return CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    }
    else if(encode == 1){   //"UTF-16LE"
        return NSUTF16LittleEndianStringEncoding;
    }
    else if(encode == 2){    //"UTF-16BE"
        return NSUTF16BigEndianStringEncoding;
    }
    else{                   //"UTF-8"
        return NSUTF8StringEncoding;
    }
}

- (AppDelegate *)getAppDelegate
{
    return app;
}

- (BOOL)connected
{
    return peripheralConneted;
}


- (void)setConnectPeripheralIndex:(NSInteger)connectPeripheralIndex
{
    if (self.peripheralArr.count) {
        NSMutableDictionary *peripheralDic = self.peripheralArr[connectPeripheralIndex];
        CBPeripheral *periphera = [peripheralDic objectForKey:@"peripheral"];
        if (!periphera){
            [self.peripheralArr removeObject:peripheralDic];
            return;
        }
        if ([self.delegate respondsToSelector:@selector(refershPeripheral:)]) {
            [self.delegate refershPeripheral:self.peripheralArr];
        }
        
        if ([self.delegate respondsToSelector:@selector(connectionFailed:)]) {
            [self.delegate connectionFailed:periphera.name];
        }
        
        myPeripheral = periphera;
        [app.mBluzConnector connect:periphera];
    }
}

- (void)setPeripheralDic:(NSMutableDictionary *)peripheralDic
{
    
}

- (void)disConnected
{
    [app.mBluzConnector disconnect:myPeripheral];
}

#pragma mark event + BoxPlayControlProctol



@end
