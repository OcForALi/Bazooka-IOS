
//
//  AppDelegate.m
//  Test
//
//  Created by Mac on 2017/9/21.
//  Copyright © 2017年 QiXing. All rights reserved.
//

#import "AppDelegate.h"
#import "IQKeyboardManager.h"
#import "MainViewController.h"
#import "BootPageViewController.h"
#import "BluzDevice.h"
#import <Bugly/Bugly.h>


@interface AppDelegate ()

@property (nonatomic, assign) UIBackgroundTaskIdentifier bgTaskId;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
//    [Bugly startWithAppId:@"bf632e76e2"];
    
    BuglyConfig * config = [[BuglyConfig alloc] init];
    // 设置自定义日志上报的级别，默认不上报自定义日志
    config.reportLogLevel = BuglyLogLevelWarn;
    
    [Bugly startWithAppId:@"bf632e76e2" config:config];
    
    MainViewController *viewController = [[MainViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewController];
    nav.navigationBar.translucent = NO;
    nav.navigationBar.hidden = YES;
   
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen]bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    
    BootPageViewController *vc = [[BootPageViewController alloc] init];
    vc.view.frame = [[UIScreen mainScreen] bounds];
    
    [self.window addSubview:vc.view];
    [self.window bringSubviewToFront:vc.view];
    
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
//    [[AVAudioSession sharedInstance] setActive:true error:nil];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    [self musicNotice];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {

    //开启后台处理多媒体事件
//    if (self.player.player.rate == 1) {
//        _bgTaskId = [self backgroundPlayerID:_bgTaskId];
//    }else{
//        [self requestBackground:application];
//    }
}

- (UIBackgroundTaskIdentifier)backgroundPlayerID:(UIBackgroundTaskIdentifier)backTaskId
{
    //设置并激活音频会话类别
    AVAudioSession *session=[AVAudioSession sharedInstance];
    [session setActive:YES error:nil];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    //允许应用程序接收远程控制
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    //设置后台任务ID
    UIBackgroundTaskIdentifier newTaskId=UIBackgroundTaskInvalid;
    newTaskId=[[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
    if(newTaskId!=UIBackgroundTaskInvalid && backTaskId!=UIBackgroundTaskInvalid)
    {
        [[UIApplication sharedApplication] endBackgroundTask:backTaskId];
    }
    return newTaskId;
}

- (void)requestBackground:(UIApplication *)application
{
    self.bgTaskId = [application beginBackgroundTaskWithExpirationHandler:^{
        [self endBackgroundTask:application];
    }];
    
    NSTimeInterval backgroundTimeRemaining =[[UIApplication sharedApplication] backgroundTimeRemaining];
    if (backgroundTimeRemaining == DBL_MAX){
        NSLog(@"Background Time Remaining = Undetermined");
    } else {
        NSLog(@"Background Time Remaining = %.02f Seconds", backgroundTimeRemaining);
    }
}

- (void) endBackgroundTask:(UIApplication *)application
{
    
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    dispatch_async(mainQueue, ^(void) {
        [[UIApplication sharedApplication] endBackgroundTask:self.bgTaskId];
        // 销毁后台任务标识符
        self.bgTaskId = UIBackgroundTaskInvalid;
    });
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
//    [self.playItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    
    NSLog(@"进入后台");
    [self endBackgroundTask:application];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
//    if (self.bgTaskID != UIBackgroundTaskInvalid) {

    NSLog(@"进入前台");

    [application endBackgroundTask:self.bgTaskId];
    self.bgTaskId = UIBackgroundTaskInvalid;
//    }
    
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
//    if (self.player.player.rate == 1) {
//        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
//    }else{
//        [[AVAudioSession sharedInstance] setActive:true error:nil];
//    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [self saveContext];
}

//实现一下backgroundPlayerID:这个方法:
+(UIBackgroundTaskIdentifier)backgroundPlayerID:(UIBackgroundTaskIdentifier)backTaskId
{
    //设置并激活音频会话类别
    AVAudioSession *session=[AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [session setActive:YES error:nil];
    //允许应用程序接收远程控制
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    //设置后台任务ID
    UIBackgroundTaskIdentifier newTaskId=UIBackgroundTaskInvalid;
    newTaskId=[[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
    if(newTaskId!=UIBackgroundTaskInvalid&&backTaskId!=UIBackgroundTaskInvalid)
    {
        [[UIApplication sharedApplication] endBackgroundTask:backTaskId];
    }
    return newTaskId;
    
}

-(void)remoteControlReceivedWithEvent:(UIEvent *)event
{
    //if it is a remote control event handle it correctly
    if (event.type == UIEventTypeRemoteControl) {
        if (event.subtype == UIEventSubtypeRemoteControlPlay ) {
            [[NSNotificationCenter defaultCenter] postNotificationName:PlayControl object:nil userInfo:@{@"status":@"play"}];
        }else if (event.subtype == UIEventSubtypeRemoteControlPause){
            [[NSNotificationCenter defaultCenter] postNotificationName:PlayControl object:nil userInfo:@{@"status":@"pause"}];
        } else if (event.subtype == UIEventSubtypeRemoteControlNextTrack){
            [[NSNotificationCenter defaultCenter] postNotificationName:PlayControl object:nil userInfo:@{@"status":@"next"}];
        }else if (event.subtype == UIEventSubtypeRemoteControlPreviousTrack){
            [[NSNotificationCenter defaultCenter] postNotificationName:PlayControl object:nil userInfo:@{@"status":@"previous"}];
        } else if (event.subtype == UIEventSubtypeRemoteControlBeginSeekingForward) {
            
        }else if (event.subtype == UIEventSubtypeRemoteControlEndSeekingForward) {
            
        } else if (event.subtype == UIEventSubtypeRemoteControlBeginSeekingBackward){
            
        } else if (event.subtype == UIEventSubtypeRemoteControlEndSeekingBackward) {
        }
    }
}


#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"Test"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

-(void)musicNotice{
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    [audioSession setActive:YES error:nil];
    
    [[AVAudioSession sharedInstance]setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionAllowBluetooth error:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(start:) name:@"musicStart" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(suspended:) name:@"musicSuspended" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(next:) name:@"musicNext" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(next:) name:@"musicLast" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioSessionInterruptionNotification:) name:AVAudioSessionInterruptionNotification object:nil];
    
    // 注册计时`
    self.count = 0;
    self.player = [[AVPlayer alloc]init];
    self.musicModel = [[MusicModel alloc] init];
    self.musicModel.isPlay = NO;
    
    [self.musicModel remoteControlEventHandler];
    
}

-(void)start:(NSNotification *)sender{
    
    self.musicModel.isPlay = YES;
    
    if (self.playItem == nil) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NoSongs" object:[NSString stringWithFormat:@""]];
    }else{
        [self.player play];
    }

}

-(void)suspended:(NSNotification *)sender{
    
     self.musicModel.isPlay = NO;
    
    [self.player pause];
}

-(void)next:(NSNotification *)sender{
    
    MusicMessage *musicMessage = sender.object;
    
    [self.playItem removeObserver:self forKeyPath:@"status"];
    
    self.playItem = [[AVPlayerItem alloc] initWithURL:musicMessage.songURL];
    
    [self.player replaceCurrentItemWithPlayerItem:self.playItem];
    
    [self.playItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    
    [self.player play];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReadyPlay" object:nil];
    
}

#pragma mark -- 添加观察者方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    
    //判断链接状态
    if ([keyPath isEqualToString:@"status"]) {
        if (self.playItem.status == AVPlayerItemStatusFailed) {
            NSLog(@"连接失败");
        }else if (self.playItem.status == AVPlayerItemStatusUnknown){
            NSLog(@"未知的错误");
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NoSongs" object:[NSString stringWithFormat:@""]];
        }else{
            NSLog(@"准备播放");
            
            self.AllTime = CMTimeGetSeconds(self.playItem.duration);
            
            [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timeAction) userInfo:nil repeats:YES];
            
            [self addNSNotificationForPlayMusicFinish];
            
            [self configNowPlayingCenter];
            
        }
    }
}

#pragma mark 来电中断
- (void)audioSessionInterruptionNotification:(NSNotification *)notification{
    
    int type = [notification.userInfo[AVAudioSessionInterruptionOptionKey] intValue];
    
    switch (type) {
        case AVAudioSessionInterruptionTypeBegan:
            [[NSNotificationCenter defaultCenter] postNotificationName:@"musicStart" object:[NSString stringWithFormat:@""]];
            if (self.model == 0) {
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"musicStart" object:[NSString stringWithFormat:@""]];
            }else if (self.model == 2) {
                [self.usbSpeakerManager play];
            }else if (self.model == 3) {
                [self.musicManager play];
            }else if (self.model == 4) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"RegistrationMode" object:[NSString stringWithFormat:@"%ld",self.model]];
            }
            
            break;
        
        case AVAudioSessionInterruptionTypeEnded:
            [[NSNotificationCenter defaultCenter] postNotificationName:@"musicSuspended" object:[NSString stringWithFormat:@""]];
            if (self.model == 0) {
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"musicSuspended" object:[NSString stringWithFormat:@""]];
            }else if (self.model == 2) {
                [self.usbSpeakerManager pause];
            }else if (self.model == 3) {
                [self.musicManager pause];
            }else if (self.model == 4) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"RegistrationMode" object:[NSString stringWithFormat:@"%@", [NSString stringWithFormat:@"%ld",self.model]]];
            }
            
            break;
        
        default:
            break;
    }
    
}

- (void)timeAction{
    
    [self showStartTime];
    
}

#pragma mark -- 展示当前播放时间
- (void)showStartTime{
    
    int currentTime = CMTimeGetSeconds(_player.currentItem.currentTime);
    self.minute = currentTime / 60;
    self.second = currentTime%60;
    [self showAllTimeLabel];
    
}

#pragma mark -- 设置总时长
- (void)showAllTimeLabel{
    
    self.AllTime = CMTimeGetSeconds(_player.currentItem.asset.duration);
    
}

#pragma mark - NSNotification
-(void)addNSNotificationForPlayMusicFinish
{
    //给AVPlayerItem添加播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:_player.currentItem];
}

-(void)playFinished:(NSNotification*)notification
{
    
    NSLog(@"播放完成");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"EndPlay" object:[NSString stringWithFormat:@""]];
    
}

// 计时
-(void)countAction{
    
    if (self.count == 60) {
        
        [_mTimer invalidate];
        
        self.count = 0;
    }
    
}

- (void)configNowPlayingCenter {
    
    NSLog(@"锁屏设置");
    // BASE_INFO_FUN(@"配置NowPlayingCenter");
    MusicMessage *entry = self.musicModel.songArr[self.musicModel.songIndex];
    NSMutableDictionary * info = [NSMutableDictionary dictionary];
    //音乐的标题
    if (entry.title) {
        [info setObject:entry.title forKey:MPMediaItemPropertyTitle];
    }
    //音乐的艺术家
    //    NSString *author= [[self.playlistArr[self.currentNum] valueForKey:@"songinfo"] valueForKey:@"author"];
    if (entry.songArtist) {
        [info setObject:entry.songArtist forKey:MPMediaItemPropertyArtist];
    }
    //音乐的播放时间
    if (self.player.currentItem) {
        [info setObject:@(self.player.currentTime.value) forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
    }
    //音乐的播放速度
    [info setObject:@(1) forKey:MPNowPlayingInfoPropertyPlaybackRate];
    //音乐的总时间
    if (entry.total) {
        [info setObject:@(entry.total) forKey:MPMediaItemPropertyPlaybackDuration];
    }
    //音乐的封面
    //    MPMediaItemArtwork * artwork = [[MPMediaItemArtwork alloc] initWithImage:[UIImage imageNamed:@"0.jpg"]];
    MPMediaItemArtwork * artwork = [entry.item valueForProperty:MPMediaItemPropertyArtwork];
    if (artwork) {
        [info setObject:artwork forKey:MPMediaItemPropertyArtwork];
    }
    //完成设置
    [[MPNowPlayingInfoCenter defaultCenter]setNowPlayingInfo:info];
}

- (void)centralOff{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedString(@"BluetoothRemind", nil) preferredStyle:UIAlertControllerStyleAlert];
    
//    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"good", nil) style:UIAlertActionStyleDefault handler:nil];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"good", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ReturnMain" object:[NSString stringWithFormat:@""]];
        
    }];
    
//    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"setUp", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//
//        NSData *data1 = [NSData dataWithBytes:(unsigned char []){0x50, 0x65, 0x73, 0x72, 0x6F, 0x3D, 0x49, 0x49} length:8];
//        NSData *data2 = [NSData dataWithBytes:(unsigned char []){0x72, 0x66, 0x3A, 0x6F, 0x74, 0x57, 0x46} length:7];
//        NSMutableString *openString = [[NSMutableString alloc] initWithData:data2 encoding:NSASCIIStringEncoding];
//        for (int i = 0; i < data1.length; i++) {
//
//            NSString *tempString = [[NSString alloc] initWithData:data1 encoding:NSASCIIStringEncoding];
//            tempString = [tempString substringWithRange:NSMakeRange(i, 1)];
//            [openString insertString:tempString atIndex:i * 2];
//        }
//        [openString insertString:@"App-" atIndex:0];
//
//        NSURL *url = [NSURL URLWithString:openString];
//        if ([[UIApplication sharedApplication] canOpenURL:url]) {
//
//            if (@available(iOS 10.0, *)) {
//                [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
//            }
//            else [[UIApplication sharedApplication] openURL:url];
//        }
//
//    }];
    
//    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    
    [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
    
}

@end
