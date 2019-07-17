//
//  FirmwareUpdateVCViewController.m
//  Test
//
//  Created by Mac on 2018/1/8.
//  Copyright © 2018年 QiXing. All rights reserved.
//

#import "FirmwareUpdateVCViewController.h"
#import "crc.h"
#define CGFloat EachPieceLength = 114

#define SOH = 0x01
#define STX  = 0x02
#define ETO =  0x04
#define ACK  =  0x06
#define NAK  =  0x15
#define C  =  0x43


@interface FirmwareUpdateVCViewController ()<GlobalDelegate>
{
    AppDelegate *appDelegate;
    BOOL canUpdate;         //是否可以更新
    BOOL startUpdate;
    NSInteger totalSize;    //文件切片总片数
    NSInteger reciveCnum;         //记录收到0x43的次数  flag = 1 才表示mcu可以进行升级
    NSInteger errIndex;     //发送0x04次数记录
    BOOL eto;              //发送完文件数据后是否发送过一次eto
    BOOL over;              //文件传输结束
    BOOL redownload;               //是否处于重新下载文件过程
    BOOL firstFrameSuccess;             //重新下载文件时第一帧是否发送
    BOOL lastTime;              //一个文件片最多尝试五次下载，是否属于最后一次
    NSInteger updateSucess;  //升级文件结果
}

@property (nonatomic, strong) UIButton *restartBtn;
@property (nonatomic, strong) UIButton *queryBtn;
@property (nonatomic, strong) UIButton *updateBtn;
@property (nonatomic, assign) NSInteger currentSlice;   //记录当前传输文件记录
@property (nonatomic, strong) NSData *data;             //升级文件
@property (nonatomic, assign) NSInteger recordNum;      //记录当前片重复次数
@property (nonatomic, strong) NSTimer *errTimer;        //发送eto直至mcu可恢复正常升级
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) NSTimer *lastTimer;
@property (nonatomic, strong) UILabel *label;
@end

@implementation FirmwareUpdateVCViewController


- (void)cn_startai_registerAppDelegate:(AppDelegate *)delegate
{
    appDelegate = delegate;
    appDelegate.globalManager = [appDelegate.mMediaManager getGlobalManager:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self cn_startai_initContentView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self cn_startai_showToastWith:@"进入升级界面"];
    appDelegate.globalManager = [appDelegate.mMediaManager getGlobalManager:self];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [appDelegate.globalManager close];
    if (_errTimer) {
        [_errTimer invalidate];
        _errTimer = nil;
    }
    if (_lastTimer) {
        [_lastTimer invalidate];
        _lastTimer = nil;
    }
}

- (void)cn_startai_initContentView
{
    [self.view addSubview:self.queryBtn];
    [self.view addSubview:self.label];
//    [self.view addSubview:self.updateBtn];
    [self.view addSubview:self.restartBtn];
    [self.view addSubview:self.progressView];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"BAZ_G2MNPGRM_V1" ofType:@"bin"];
    self.data = [NSData dataWithContentsOfFile:path];
    totalSize = self.data.length/128;
    if (self.data.length%128) {
        totalSize++;
    }
}


- (UIButton *)queryBtn
{
    if (!_queryBtn) {
        _queryBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _queryBtn.frame = CGRectMake(100, 200, 150, 30);
        _queryBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        [_queryBtn setTitle:@"Query Version" forState:UIControlStateNormal];
        [_queryBtn setTitleColor:[UIColor colorWithHexColorString:@"ffffff"] forState:UIControlStateNormal];
        [_queryBtn addTarget:self action:@selector(cn_startai_queryVersion) forControlEvents:UIControlEventTouchUpInside];
        _queryBtn.selected = false;
    }
    return _queryBtn;
}


- (UILabel *)label
{
    if (!_label) {
        _label = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WITDH-300)/2.0, 300, 300, 30)];
        _label.text = @"";
        _label.textColor = [UIColor whiteColor];
        _label.textAlignment = NSTextAlignmentCenter;
    }
    return _label;
}
- (UIButton *)updateBtn
{
    if (!_updateBtn) {
        _updateBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _updateBtn.frame = CGRectMake(100, 300, 150, 30);
        _updateBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        [_updateBtn setTitle:@"update" forState:UIControlStateNormal];
        [_updateBtn setTitleColor:[UIColor colorWithHexColorString:@"ffffff"] forState:UIControlStateNormal];
        [_updateBtn addTarget:self action:@selector(cn_startai_updatePrograme) forControlEvents:UIControlEventTouchUpInside];
        _updateBtn.selected = false;
    }
    return _updateBtn;
}

- (UIButton *)restartBtn
{
    if (!_restartBtn) {
        _restartBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _restartBtn.frame = CGRectMake(100, 400, 150, 30);
        _restartBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        [_restartBtn setTitle:@"update FW" forState:UIControlStateNormal];
        [_restartBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_restartBtn addTarget:self action:@selector(cn_startai_restart) forControlEvents:UIControlEventTouchUpInside];
    }
    return _restartBtn;
}


- (UIProgressView *)progressView
{
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(50, NavBarHeight+100, SCREEN_WITDH-100, 30)];
        _progressView.userInteractionEnabled = false;
    }
    return _progressView;
}

#pragma mark 中断传输重新进行
- (void)cn_startai_restart
{
    //中断任务重新开始
    [self cn_startai_showToastWith:@"异常中断重新升级"];
    self.label.text = @"异常中断重新升级";
    redownload = true;
    [self cn_startai_updatePrograme];
    sleep(2.0);
    _errTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(errSendTime) userInfo:nil repeats:true];
    [[NSRunLoop currentRunLoop] addTimer:_errTimer forMode:NSRunLoopCommonModes];
}

- (void)errSendTime
{
    if (errIndex == totalSize) {
        [_errTimer invalidate];
        _errTimer = nil;
        errIndex = 0;
        [self cn_startai_showToastWith:@"出现异常重启音箱设备尝试更新"];
        self.label.text = @"出现异常重启音箱设备尝试更新";
        return ;
    }
    
    uint8_t eto = 0x04;
    NSData *data = [NSData dataWithBytes:&eto length:sizeof(eto)];
    int key = [appDelegate.globalManager buildKey:SET cmdID:0x81];
    if (key!=-1) {
        [appDelegate.globalManager sendCustomCommand:key param1:0xB3 param2:(UInt32)data.length others:data];
        [self performSelector:@selector(cn_startai_query) withObject:nil afterDelay:0.25];
    }
    errIndex ++;
}

#pragma mark 查询当前版本
- (void)cn_startai_queryVersion
{
    //查询版本号
    int key = [appDelegate.globalManager buildKey:QUE cmdID:0x9a];
    if (key != -1) {
        [appDelegate.globalManager sendCustomCommand:key param1:0 param2:0 others:nil];
        [self cn_startai_showToastWith:@"开始查询当前版本"];
        self.label.text = @"开始查询当前版本";
        NSLog(@"------------开始查询当前版本--------------------");
    }
}

#pragma mark 进入升级boot模式
- (void)cn_startai_updatePrograme
{
    if (self.data.length && canUpdate) {
        self.currentSlice = 0;
        int key = [appDelegate.globalManager buildKey:SET cmdID:0x81];
        if (key != -1) {
            updateSucess = 1;
            [[NSUserDefaults standardUserDefaults] setInteger:updateSucess forKey:@"updateSucess"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self cn_startai_showToastWith:@"进入升级模式"];
            self.label.text = @"进入升级模式";
            [appDelegate.globalManager sendCustomCommand:key param1:0xB1 param2:0 others:nil];
        }
        NSLog(@"------------发送开始升级命令--------------------");
        [self performSelector:@selector(cn_startai_query) withObject:nil afterDelay:2];
    }else if(self.data.length && !canUpdate){
        [self cn_startai_showToastWith:@"当前已是最新版本"];
        self.label.text = @"当前已是最新版本";
    }else{
        [self cn_startai_showToastWith:@"暂无可升级资源"];
        self.label.text = @"暂无可升级资源";
    }

}

#pragma mark 发送第一帧带文件信息
- (void)cn_startai_sendFirstFrame
{
    int key = [appDelegate.globalManager buildKey:SET cmdID:0X81];
    uint8_t err = 0x04;
    NSData *name = [@"project.bin" dataUsingEncoding:NSUTF8StringEncoding];
    uint16_t len = self.data.length;
    NSMutableData *mudata = [NSMutableData data];
    
    uint8_t first = 0x01;
    uint8_t serial = 0x00;
    uint8_t ucode = 0xff - serial;
    [mudata appendBytes:&first length:sizeof(first)];
    [mudata appendBytes:&serial length:sizeof(serial)];
    [mudata appendBytes:&ucode length:sizeof(ucode)];
    [mudata appendData:name];
    [mudata appendBytes:&len length:sizeof(len)];
    
    NSMutableData *muda1 = [NSMutableData data];
    [muda1 appendData:name];
    [muda1 appendBytes:&len length:sizeof(len)];
    for (NSInteger i=0; i<128-name.length-2; i++) {
        uint8_t ze = 0x00;
        [mudata appendBytes:&ze length:sizeof(ze)];
        [muda1 appendBytes:&ze length:sizeof(ze)];
    }
    
    const uint8_t *byte = (const uint8_t *)muda1.bytes;
    uint16_t length = (uint16_t)muda1.length;
    uint16_t res =  gen_crc16(byte, length);
    NSData *val = [NSData dataWithBytes:&res length:sizeof(res)];
    NSData *da1 = [val subdataWithRange:NSMakeRange(0, 1)];
    NSData *da2 = [val subdataWithRange:NSMakeRange(1, 1)];
    [mudata appendData:da2];
    [mudata appendData:da1];
    
//     NSData *data = [self.data subdataWithRange:NSMakeRange(0, 128)];
    if (key != -1) {
        [appDelegate.globalManager sendCustomCommand:key param1:0xB3 param2:(UInt32)mudata.length others:mudata];
        NSLog(@"-------------第一帧数据包带文件名-+++++++++++++++++++++++++%@",mudata);
//        [self cn_startai_query];
        [self performSelector:@selector(cn_startai_query) withObject:nil afterDelay:2];
    }
    
}

#pragma mark 发送bin数据
- (void)cn_startai_sendBin
{
    if (!self.data.length) {
        [self cn_startai_showToastWith:@"资源文件不存在"];
        self.label.text = @"资源文件不存在";
        return;
    }else if (self.currentSlice >= totalSize){
        return;
    }

    NSData *data;
    uint8_t first = 0x01;
    uint8_t serial = self.currentSlice+1;
    if (self.currentSlice > 255) {
        serial = self.currentSlice %256;
    }
    uint8_t ucode = 0xff - serial;
    
    if (self.currentSlice*128+128 > self.data.length) {
        NSData *datax = [self.data subdataWithRange:NSMakeRange(self.currentSlice*128, self.data.length-self.currentSlice*128)];
        NSMutableData *mudata = [NSMutableData data];
        [mudata appendData:datax];
        for (NSInteger i=0; i<128-(self.data.length-self.currentSlice*128-data.length); i++) {
            uint8_t a = 0x1A;
            NSData *da = [NSData dataWithBytes:&a length:sizeof(a)];
            [mudata appendData:da];
        }
        data = [NSData dataWithData:mudata];
        NSLog(@"最后一帧------%ld",self.currentSlice *128);
    }else{
        data = [self.data subdataWithRange:NSMakeRange(self.currentSlice*128, 128)];
    }
    const uint8_t *byte = (const uint8_t *)data.bytes;
    uint16_t length = (uint16_t)data.length;
    uint16_t res =  gen_crc16(byte, length);
    NSMutableData *muData = [NSMutableData data];
    [muData appendBytes:&first length:sizeof(first)];
    [muData appendBytes:&serial length:sizeof(serial)];
    [muData appendBytes:&ucode length:sizeof(ucode)];
    [muData appendData:data];
    NSData *val = [NSData dataWithBytes:&res length:sizeof(res)];
    NSData *da1 = [val subdataWithRange:NSMakeRange(0, 1)];
    NSData *da2 = [val subdataWithRange:NSMakeRange(1, 1)];
    [muData appendData:da2];
    [muData appendData:da1];
    int key = [appDelegate.globalManager buildKey:SET cmdID:0x81];
    if (key != -1) {
        [appDelegate.globalManager sendCustomCommand:key param1:0xB3 param2:(UInt32)muData.length others:muData];
        self.progressView.progress = self.currentSlice/(float)totalSize;
        NSLog(@"-------------第几帧数据包---%ld+++++++++++++++++++++++++%@",self.currentSlice,muData);
//        [self cn_startai_query];
        [self performSelector:@selector(cn_startai_query) withObject:nil afterDelay:0.5];
    }
}

#pragma mark 查询bin数据送达情况
- (void)cn_startai_query
{
    int key = [appDelegate.globalManager buildKey:QUE cmdID:0x99];
    if (key != -1) {
        [appDelegate.globalManager sendCustomCommand:key param1:0 param2:0 others:nil];
    }
}

#pragma mark 升级bin文件结束
- (void)updateOver
{
    int key = [appDelegate.globalManager buildKey:SET cmdID:0x81];
    if (key != -1) {
        [appDelegate.globalManager sendCustomCommand:0xB2 param1:0 param2:0 others:nil];
        [self cn_startai_showToastWith:@"升级结束"];
        self.label.text = @"升级结束";
    }
}

#pragma mark eto
- (void)cn_startai_eto
{
    uint8_t eto = 0x04;
    NSData *data = [NSData dataWithBytes:&eto length:sizeof(eto)];
    int key = [appDelegate.globalManager buildKey:SET cmdID:0x81];
    if (key!=-1) {
        [appDelegate.globalManager sendCustomCommand:key param1:0xB3 param2:1 others:data];
    }
    [self performSelector:@selector(cn_startai_query) withObject:nil afterDelay:2];
}

#pragma mark 升级结束帧
- (void)cn_startai_lastdata
{
    int key = [appDelegate.globalManager buildKey:SET cmdID:0X81];

    NSMutableData *mudata = [NSMutableData data];
    
    NSData *data;
    uint8_t first = 0x01;
    uint8_t serial = 0x00;
    uint8_t ucode = 0xff - serial;
    [mudata appendBytes:&first length:sizeof(first)];
    [mudata appendBytes:&serial length:sizeof(serial)];
    [mudata appendBytes:&ucode length:sizeof(ucode)];
    NSMutableData *muda1 = [NSMutableData data];

    for (NSInteger i=0; i<128; i++) {
        uint8_t ze = 0x00;
        [mudata appendBytes:&ze length:sizeof(ze)];
        [muda1 appendBytes:&ze length:sizeof(ze)];
    }
    const uint8_t *byte = (const uint8_t *)muda1.bytes;
    uint16_t length = (uint16_t)muda1.length;
    uint16_t res =  gen_crc16(byte, length);
    NSData *val = [NSData dataWithBytes:&res length:sizeof(res)];
    NSData *da1 = [val subdataWithRange:NSMakeRange(0, 1)];
    NSData *da2 = [val subdataWithRange:NSMakeRange(1, 1)];
    [mudata appendData:da2];
    [mudata appendData:da1];
    
    if (key != -1) {
        [appDelegate.globalManager sendCustomCommand:key param1:0xB3 param2:(UInt32)mudata.length others:mudata];
        NSLog(@"-------------最后一帧结束-+++++++++++++++++++++++++%@",mudata);
        //        [self cn_startai_query];
        [self performSelector:@selector(cn_startai_query) withObject:nil afterDelay:2];
    }
}

#pragma mark --------------------------------------GlobalDelegate

#pragma mark 收到自定义命令回调，处理返回信息
- (void)customCommandArrived:(UInt32)cmdKey param1:(UInt32)arg1 param2:(UInt32)arg2 others:(NSData *)data
{
    NSLog(@"回调结果=======================%@",data);
    NSData *checkByte = [data subdataWithRange:NSMakeRange(0, 1)];
    uint8_t ss = 0x43;
    NSData *CData = [NSData dataWithBytes:&ss length:sizeof(ss)];
    uint8_t ack = 0x06;
    NSData *ackData = [NSData dataWithBytes:&ack length:sizeof(ack)];
    uint8_t nak = 0x15;
    NSData *nakData = [NSData dataWithBytes:&nak length:sizeof(nak)];
    uint8_t zer0 = 0x00;
    NSData *zeroData = [NSData dataWithBytes:&zer0 length:sizeof(zer0)];
    
    if (over) {
        //已经完成升级不做处理了
        [self updateOver];
        [self.navigationController popViewControllerAnimated:true];
        return;
    }
    
    if (cmdKey == [appDelegate.globalManager buildKey:ANS cmdID:0x9a]) {
        //查询MCU版本
        canUpdate = true;
        [self cn_startai_showToastWith:[NSString stringWithFormat:@"当前版本:%u",(unsigned int)arg1]];
        self.label.text = [NSString stringWithFormat:@"当前版本:%u",(unsigned int)arg1];
    }
    
    if (!(cmdKey == [appDelegate.globalManager buildKey:ANS cmdID:0x99])) {
        return;
    }
    
    if (lastTime  && ![ackData isEqualToData:checkByte]) {
        //如果一片文件重复五次传输仍拿不到ACK则当任务失败处理
        [self cn_startai_showToastWith:@"升级失败"];
        self.label.text = @"升级失败";
        lastTime = false;
        return;
    }
    if (redownload) {
        //处于重新下载升级
        if ([checkByte isEqualToData:CData]) {
            //在发送eto后收到0x43进行
            errIndex = 0;
            [_errTimer invalidate];
            _errTimer = nil;
            redownload = false;
            [self cn_startai_showToastWith:@"mcu已经准备好了"];
            self.label.text = @"mcu已经准备好了,开始接受升级数据";
            reciveCnum = 1;
            [self performSelector:@selector(cn_startai_sendFirstFrame) withObject:nil afterDelay:2.0];
            //重连第一帧发送
            firstFrameSuccess = YES;
        }
        return;
    }
    if ([zeroData isEqualToData:checkByte] && firstFrameSuccess) {
        //当重新连接时发送eto收到0x43发送第一帧过去返回结果是00再发第一帧
        [self cn_startai_sendFirstFrame];
        return;
    }
    
    if (![nakData isEqualToData:checkByte] && eto) {
        //发送eto没有收到nak就一直发送
        [self cn_startai_eto];
        return;
    }
    
    if ([CData isEqualToData:checkByte] && firstFrameSuccess) {
        //第一帧发送成功了
        firstFrameSuccess = false;
        reciveCnum = 1;
    }
    
    if ([checkByte isEqualToData:CData]) {
        reciveCnum++;
        //收到第一个0x43是对升级命令的回复 然后可以发送第一帧 第二个0x43c可以发送升级包
        if (reciveCnum<2) {
            [self cn_startai_sendFirstFrame];
        }else{
            if (self.currentSlice<totalSize) {
                [self cn_startai_sendBin];
                self.currentSlice++;
            }
        }
        return;
    }
    
    if (reciveCnum == 0) {
        // 没有进入升级模式
        return;
    }
    
    if ([zeroData isEqualToData:checkByte]) {
        if (self.recordNum >= 5) {
            //在某段传输过程中发送五次以上视为失败
            self.currentSlice = 0;
            self.recordNum = 0;
            [self cn_startai_showToastWith:@"升级失败"];
            self.label.text = @"升级失败";
            return;
        }
        if (self.currentSlice>0) {
            self.currentSlice--;
        }
        sleep(2.0);
        self.recordNum ++;
        if (self.recordNum == 5 && self.currentSlice < totalSize-1) {
            //第五次失败尝试发送下一片 测试过程中出现老是收到0x00 但是发送下一片又恢复正常了，其实mcu是有收到的
            self.currentSlice ++;
            lastTime = true;
        }
        [self cn_startai_sendBin];
        self.currentSlice++;
        return;
    }else if ([nakData isEqualToData:checkByte]){
        if (eto) {
            //发完一次eto过去收到nak再发一次eto过去，延时4s发送结束帧
            [self cn_startai_eto];
            [self performSelector:@selector(cn_startai_lastdata) withObject:nil afterDelay:4];
            updateSucess = 2;
            over = true;
            eto = false;
            self.recordNum = 0;
            [[NSUserDefaults standardUserDefaults] setInteger:updateSucess forKey:@"updateSucess"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }else if (self.recordNum >= 5) {
            self.currentSlice = 0;
            self.recordNum = 0;
            [self cn_startai_showToastWith:@"升级失败"];
            self.label.text = @"升级失败";
        }else if (self.recordNum<5) {
            //重复发送上一片未成功的数据包
            if (self.currentSlice>0) {
                self.currentSlice--;
            }
            sleep(2.0);
            self.recordNum ++;
            if (self.recordNum == 5 && self.currentSlice < totalSize-1) {
                //第五次尝试发送下一帧数据包
                self.currentSlice ++;
                lastTime = true;
            }
            [self cn_startai_sendBin];
            self.currentSlice++;
        }
        return;
    }else if ([ackData isEqualToData:checkByte]){
        if (self.currentSlice >= totalSize) {
            if (eto) {
                return;
            }
            //文件发送结束发一次eto过去
            [self cn_startai_eto];
            [self cn_startai_showToastWith:@"正在校验中"];
            self.label.text = @"正在校验中";
            _lastTimer = [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(updateFail) userInfo:nil repeats:false];
            [[NSRunLoop currentRunLoop] addTimer:_lastTimer forMode:NSRunLoopCommonModes];
            eto = true;
        }else{
            [self cn_startai_sendBin];
        }
        self.currentSlice ++;
        self.recordNum = 0;
    }
}

- (void)updateFail
{
    [_lastTimer invalidate];
    _lastTimer = nil;
    [self updateOver];
    [self cn_startai_showToastWith:@"升级失败"];
    self.label.text = @"升级失败";
}

- (void)leftAction
{
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"updateSucess"]==1 &&appDelegate.isConnected) {
        return;
    }
    [self.navigationController popViewControllerAnimated:true];

}

#pragma mark 准备就绪
- (void)managerReady
{
    
}

#pragma mark 音箱功能模式变化
-(void)modeChanged:(UInt32)mode
{
    appDelegate.model = mode;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ModeChanged" object:[NSString stringWithFormat:@"%d",mode]];
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
    appDelegate.currentVoice = current;
    appDelegate.maxVoice = max;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"speakerVolumeChange" object:nil];
}

#pragma mark 音箱外置卡插拔状态变化
-(void)hotplugCardChanged:(BOOL)visibility
{
}


#pragma mark 音箱外置U盘插拔状态变化
-(void)hotplugUhostChanged:(BOOL)visibility
{

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

#define PLOY 0X1021

uint16_t gen_crc16(unsigned char *data, uint16_t size) {
    uint16_t crc = 0;
    uint8_t i;
    for (; size > 0; size--) {
        crc = crc ^ (*data++ <<8);
        for (i = 0; i < 8; i++) {
            if (crc & 0X8000) {
                crc = (crc << 1) ^ PLOY;
            }else {
                crc <<= 1;
            }
        }
        crc &= 0XFFFF;
    }
    return crc;
}

unsigned short CRC16_XMODEM(unsigned char *puchMsg, unsigned short usDataLen) {
    unsigned short wCRCin = 0x0000;
    unsigned short wCPoly = 0x1021;
    unsigned char wChar = 0;
    
    while (usDataLen--)
    {
        wChar = *(puchMsg++);
        wCRCin ^= (wChar << 8);
        for(int i = 0;i < 8;i++)
        {
            if(wCRCin & 0x8000)
                wCRCin = (wCRCin << 1) ^ wCPoly;
            else
                wCRCin = wCRCin << 1;
        }
    }
    return (wCRCin) ;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (void)cn_startai_showToastWith:(NSString *)title
{
    return;
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    hud.userInteractionEnabled = false;
    hud.mode = MBProgressHUDModeText;
    hud.label.text = title;
    hud.label.numberOfLines = 0;
//    [[self lastWindow] addSubview:hud];
    [self.view addSubview:hud];
    [hud showAnimated:true];
    [hud hideAnimated:true afterDelay:2.0];
}

@end
