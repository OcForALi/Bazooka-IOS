//
//  TestViewController.m
//  Test
//
//  Created by Mac on 2017/12/13.
//  Copyright © 2017年 QiXing. All rights reserved.
//

#import "TestViewController.h"
#import "RelaySwitchViewCell.h"
#import "LedOnOffViewCell.h"
#import "FlashViewCell.h"

@interface TestViewController ()<UITableViewDelegate, UITableViewDataSource,GlobalManager>
{
    AppDelegate *appDelegate;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) UInt8 relay;
@property (nonatomic, assign) NSInteger current;
@property (nonatomic, assign) NSInteger maxNum;
@end

@implementation TestViewController

- (void)cn_startai_registerAppDelegate:(AppDelegate *)delegate mode:(uint32_t)mode
{
    appDelegate = delegate;
    appDelegate.globalManager = [appDelegate.mMediaManager getGlobalManager:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self cn_startai_initContentView];
}

- (void)cn_startai_initContentView
{
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.bounces = false;
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 350;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        RelaySwitchViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RelaySwitchViewCell"];
        if (!cell) {
            cell = [[RelaySwitchViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RelaySwitchViewCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        @weakify(cell);
        @weakify(self);
        cell.tapSendHandler = ^{
            [weak_self cn_startai_showToastWithTitle:@"开始发送"];
             weak_self.relay = (UInt8)([weak_cell.serailTextfiled.text integerValue]*16+[weak_cell.stateTextField.text integerValue]);
            if (_timer) {
                [_timer invalidate];
                _timer = nil;
            }
            
            _timer = [NSTimer scheduledTimerWithTimeInterval:[weak_cell.intervalTimeTextfiled.text integerValue] target:self selector:@selector(relayFunction) userInfo:nil repeats:true];
        };
        
        return cell;
    }else if (indexPath.row == 1){
        LedOnOffViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LedOnOffViewCell"];
        if (!cell) {
            cell = [[LedOnOffViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LedOnOffViewCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        @weakify(cell);
        @weakify(self);

       
        cell.tapSendHandler = ^{
            [weak_self cn_startai_showToastWithTitle:@"开始发送"];
            weak_self.maxNum = [weak_cell.repeatTextfiled.text integerValue];
            weak_self.current = 0;
            if (_timer) {
                [_timer invalidate];
                _timer = nil;
            }
            
            _timer = [NSTimer scheduledTimerWithTimeInterval:[weak_cell.intervalTimeTextfiled.text integerValue] target:self selector:@selector(onOffFunction) userInfo:nil repeats:true];
            
        };
        return cell;
    }else{
        FlashViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FlashViewCell"];
        if (!cell) {
            cell = [[FlashViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FlashViewCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    }
}


- (void)cn_startai_queFlash
{
    int key = [appDelegate.globalManager buildKey:QUE cmdID:0x98];
    if (key != -1) {
        [appDelegate.globalManager sendCustomCommand:key param1:0 param2:0 others:nil];
    }
}


- (void)relayFunction
{
    //高四位表示继电器序号
    //低四位表示继电器状态 1 开启 0断开
   
    NSData *data = [NSData dataWithBytes:&_relay length:sizeof(_relay)];
    int key = [appDelegate.globalManager buildKey:SET cmdID:0x81];
    if (key != -1 && key!= 0) {
        [appDelegate.globalManager sendCustomCommand:key param1:0x66 param2:1 others:data];
        [self cn_startai_queFlash];
        _current ++;
        if (_current == _maxNum) {
            [_timer invalidate];
            _timer = nil;
        }
    }else{
        [self cn_startai_showToastWithTitle:@"未连接蓝牙"];
        [_timer invalidate];
        _timer = nil;
    }
    NSLog(@"--------------------%ld",self.current);
}

- (void)onOffFunction
{
    int key = [appDelegate.globalManager buildKey:SET cmdID:0x81];
    if (key != -1 && key!= 0) {
        [appDelegate.globalManager sendCustomCommand:key param1:0x54 param2:1 others:nil];
        [self cn_startai_queFlash];
        self.current ++;
        if (self.current == self.maxNum) {
            [_timer invalidate];
            _timer = nil;
        }
    }else{
        [self cn_startai_showToastWithTitle:@"未连接蓝牙"];
        [_timer invalidate];
        _timer = nil;
        
    }
    NSLog(@"--------------------%ld",self.current);
}


- (void)managerReady
{
    
}

- (void)modeChanged:(UInt32)mode
{
    
}

-(void)customCommandArrived:(UInt32)cmdKey param1:(UInt32)arg1 param2:(UInt32)arg2 others:(NSData *)data
{

    if (arg1 == 64) {
    
    }else if (arg1 == 128){
        
    }else if (arg1 == 192){

    }
    
    NSString *str = [self toBinarySystemWithDecimalSystem:arg2];
    
    NSLog(@"++++++++++++++%d++++++++++++++++%@",arg1,str);
}


- (void)cn_startai_showToastWithTitle:(NSString *)title
{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    hud.userInteractionEnabled = false;
    hud.mode = MBProgressHUDModeText;
    hud.label.text = title;
    hud.label.numberOfLines = 0;
    [self.view addSubview:hud];
    [hud showAnimated:true];
    [hud hideAnimated:true afterDelay:2.0];
}

- (NSString *)toBinarySystemWithDecimalSystem:(NSInteger)decimal
{
    NSInteger num = decimal;//[decimal intValue];
    NSInteger remainder = 0;      //余数
    NSInteger divisor = 0;        //除数
    
    NSString * prepare = @"";
    
    while (true)
    {
        remainder = num%2;
        divisor = num/2;
        num = divisor;
        prepare = [prepare stringByAppendingFormat:@"%ld",remainder];
        
        if (divisor == 0)
        {
            break;
        }
    }
    
    NSString * result = @"";
    for (NSInteger i = prepare.length - 1; i >= 0; i --)
    {
        result = [result stringByAppendingFormat:@"%@",
                  [prepare substringWithRange:NSMakeRange(i , 1)]];
    }
    return result;
}

@end
