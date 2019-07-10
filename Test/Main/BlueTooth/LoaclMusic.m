//
//  LoaclMusic.m
//  Test
//
//  Created by Mac on 2017/10/28.
//  Copyright © 2017年 QiXing. All rights reserved.
//

#import "LoaclMusic.h"
#import <Bugly/Bugly.h>

@implementation LocalMusicEntry

@end

@interface LoaclMusic ()<AVAudioPlayerDelegate>

@property (nonatomic) MPMediaItem *playItem;
@property (nonatomic, strong)id timeObserver;
@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, strong) AVPlayerItem *playerItem;

@end

@implementation LoaclMusic

-(void)dealloc
{
    //    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //    [self.player endGeneratingPlaybackNotifications];
}

- (instancetype)init
{
    if (self == [super init]) {
        self.player = [[AVPlayer alloc] init];
        self.player.automaticallyWaitsToMinimizeStalling = NO;
        self.songModel = orderModel;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleInterreption:) name:AVAudioSessionInterruptionNotification object:[AVAudioSession sharedInstance]];
        
        [self getData];

//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            [self getData];
//        });
    }
    return self;
}

- (void)getData
{
    
    if (@available(iOS 9.3, *)) {
        MPMediaLibraryAuthorizationStatus authStatus = [MPMediaLibrary authorizationStatus];
        if (authStatus == MPMediaLibraryAuthorizationStatusDenied || authStatus == MPMediaLibraryAuthorizationStatusRestricted) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please go to set up open media library access right." message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                
            });

            return;
        }
    } else {
        // Fallback on earlier versions
    }
    self.songArr = [NSMutableArray array];
    MPMediaQuery *music = [[MPMediaQuery alloc] init];
    MPMediaPropertyPredicate *predicate = [MPMediaPropertyPredicate predicateWithValue:[NSNumber numberWithInteger:MPMediaTypeMusic] forProperty:MPMediaItemPropertyMediaType];
    [music addFilterPredicate:predicate];
    NSArray *items = [music items];
    
    for (MPMediaItem *song in items) {
        LocalMusicEntry *entity = [[LocalMusicEntry alloc] init];
        entity.title = [song valueForProperty:MPMediaItemPropertyTitle];
        entity.songURL = [song valueForProperty:MPMediaItemPropertyAssetURL];
        entity.songArtist = [song valueForProperty:MPMediaItemPropertyArtist];
        entity.albumTitle = [song valueForProperty:MPMediaItemPropertyAlbumTitle];
        entity.total= [[song valueForKey:MPMediaItemPropertyPlaybackDuration] integerValue];
        entity.item = song;
        
        if (entity.songURL != nil) {
            [self.songArr addObject:entity];
        }
        
    }
    
    if (self.songArr.count) {
        if (self.LocalMusicArrHandler) {
            self.LocalMusicArrHandler(self.songArr);
        }
    }
}

- (void)setSongModel:(NSInteger)songModel
{
    _songModel = songModel;
}

- (void)setSongIndex:(NSInteger)songIndex
{
    _songIndex = songIndex;
}

- (void)cn_startai_playAppointSong:(NSInteger)songIndex
{
    self.songIndex = songIndex;
    LocalMusicEntry *entry = [self.songArr objectAtIndex:self.songIndex];
    
    BLYLogError(@"AVPlayerItem songURL - %@",entry.songURL);
    
    [self.playerItem removeObserver:self forKeyPath:@"status"];
    self.playerItem = [[AVPlayerItem alloc] initWithURL:entry.songURL];
    [self.player replaceCurrentItemWithPlayerItem:self.playerItem];
//    [self.playItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    
    self.isPlaying = true;
    if (self.musicStateChangeHandler) {
        self.musicStateChangeHandler();
    }
    [self currentItemAddObserver];
}

- (void)cn_startai_pauseSong
{
    [self.player pause];
    self.isPlaying = false;
    if (self.musicStateChangeHandler) {
        self.musicStateChangeHandler();
    }
}

- (void)cn_startai_playSong
{
    if (self.songIndex<self.songArr.count) {
        AVAudioSession *session=[AVAudioSession sharedInstance];
        [session setActive:YES error:nil];
        [session setCategory:AVAudioSessionCategoryPlayback error:nil];
        //允许应用程序接收远程控制
        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
        if (self.player.currentItem ) {
            [self.player play];
        }else{
            LocalMusicEntry *entry = [self.songArr objectAtIndex:self.songIndex];
            
            BLYLogError(@"AVPlayerItem songURL - %@",entry.songURL);
            
            [self.playerItem removeObserver:self forKeyPath:@"status"];
            self.playerItem = [[AVPlayerItem alloc] initWithURL:entry.songURL];
            [self.player replaceCurrentItemWithPlayerItem:self.playerItem];
            [self.player play];
            
        }
        self.isPlaying = true;
        if (self.musicStateChangeHandler) {
            self.musicStateChangeHandler();
        }
        [self currentItemAddObserver];
    }
}

- (void)cn_startai_playLastSong
{
    //    [self.player skipToPreviousItem];
    NSInteger num = 1;
    if (self.songModel == randomModel) {
        num = arc4random()%self.songArr.count;
    }
    self.songIndex = (self.songIndex-num+self.songArr.count)%self.songArr.count;
    if (self.songIndex<self.songArr.count) {
        LocalMusicEntry *entry = [self.songArr objectAtIndex:self.songIndex];
        
        BLYLogError(@"AVPlayerItem songURL - %@",entry.songURL);
        [self.playerItem removeObserver:self forKeyPath:@"status"];
        self.playerItem = [[AVPlayerItem alloc] initWithURL:entry.songURL];
        [self.player replaceCurrentItemWithPlayerItem:self.playerItem];
        if (self.player.rate) {
            self.isPlaying = true;
            [self.player play];
            if (self.musicStateChangeHandler) {
                self.musicStateChangeHandler();
            }
        }
        [self currentItemAddObserver];
    }
}

- (void)cn_startai_playNextSong
{
    NSInteger num = 1;
    if (self.songModel == randomModel) {
        num = arc4random()%self.songArr.count;
    }
    self.songIndex = (self.songIndex + num + self.songArr.count)%self.songArr.count;
    
    NSLog(@"%ld ------ %ld --------- %ld",self.songArr.count,self.songIndex,num);
    
    if (self.songIndex < self.songArr.count) {
        LocalMusicEntry *entry = [self.songArr objectAtIndex:self.songIndex];
        
        BLYLogError(@"AVPlayerItem songURL - %@",entry.songURL);
        
        [self.playerItem removeObserver:self forKeyPath:@"status"];
        self.playerItem = [[AVPlayerItem alloc] initWithURL:entry.songURL];
        [self.player replaceCurrentItemWithPlayerItem:self.playerItem];
        if (self.player.rate) {
            self.isPlaying = true;
            if (self.musicStateChangeHandler) {
                self.musicStateChangeHandler();
            }
        }
//        [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
        [self currentItemAddObserver];
    }
}

//- (void)getMusicEetity:(MPMediaItem *)song
- (void)getMusicEntity:(LocalMusicEntry *)song
{
    //    LocalMusicEntry *entity = [[LocalMusicEntry alloc] init];
    //    entity.title = [song valueForProperty:MPMediaItemPropertyTitle];
    //    entity.songURL = [song valueForProperty:MPMediaItemPropertyAssetURL];
    //    entity.songArtist = [song valueForProperty:MPMediaItemPropertyArtist];
    //    entity.albumTitle = [song valueForProperty:MPMediaItemPropertyAlbumTitle];
    //    entity.total=[[song valueForKey:MPMediaItemPropertyPlaybackDuration] integerValue];
    //    self.musicEntity = entity;
    //    self.musicEntity = song;
    if (song.title.length) {
        if (self.musicHandlerEntity) {
            self.musicHandlerEntity(song);
        }
    }
}

//- (LocalMusicEntry *)musicEntity
//{
//    return _musicEntity;
//}

- (void)currentItemRemoveObserver {
    
    if (!self.player.currentItem) {
        return;
    }
    
    [self.player.currentItem removeObserver:self  forKeyPath:@"status"];
    [self.player.currentItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    //    [self.player removeTimeObserver:self.timeObserver];
}

- (void)currentItemAddObserver {
    
    if (!self.player.currentItem) {
        return;
    }
    
    //监控状态属性，注意AVPlayer也有一个status属性，通过监控它的status也可以获得播放状态
//    [self.player.currentItem addObserver:self forKeyPath:@"status" options:(NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew) context:nil];
    [self.playItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    //监控缓冲加载情况属性
//    [self.player.currentItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
    

    //监控时间进度
    //    @weakify(self);
    //    self.timeObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
    ////        @strongify(self);
    //        // 在这里将监听到的播放进度代理出去，对进度条进行设置
    //
    //    }];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerItemStatus status = [change[@"new"] integerValue];
        switch (status) {
            case AVPlayerItemStatusReadyToPlay:
            {
                
                [self.player play];
                
                if (self.songIndex<self.songArr.count) {
                    [self getMusicEntity:self.songArr[self.songIndex]];
                }
                
                [self configNowPlayingCenter];
                
                //监控播放完成通知
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
                
            }
                break;
            case AVPlayerItemStatusFailed:
            {
                NSLog(@"加载失败");
            }
                break;
            case AVPlayerItemStatusUnknown:
            {
                NSLog(@"未知资源");
            }
                break;
            default:
                break;
        }
        if (self.musicStateChangeHandler) {
            self.musicStateChangeHandler();
        }
    } else if([keyPath isEqualToString:@"loadedTimeRanges"]){
        //        NSArray *array=playerItem.loadedTimeRanges;
        //        //本次缓冲时间范围
        //        CMTimeRange timeRange = [array.firstObject CMTimeRangeValue];
        //        float startSeconds = CMTimeGetSeconds(timeRange.start);
        //        float durationSeconds = CMTimeGetSeconds(timeRange.duration);
        //        //缓冲总长度
        //        NSTimeInterval totalBuffer = startSeconds + durationSeconds;
        //        NSLog(@"共缓冲：%.2f",totalBuffer);
        
    } else if ([keyPath isEqualToString:@"rate"]) {
        // rate=1:播放，rate!=1:非播放
        //        float rate = self.player.rate;
        if (self.musicStateChangeHandler) {
            self.musicStateChangeHandler();
        }
    } else if ([keyPath isEqualToString:@"currentItem"]) {
        NSLog(@"新的currentItem");
        if (self.musicStateChangeHandler) {
            self.musicStateChangeHandler();
        }
    }
}

- (void)playbackFinished:(NSNotification *)notifi {
    NSLog(@"播放完成");
    NSInteger num = 1;
    if (self.songModel == orderModel ) {
        NSLog(@"");
    }else if (self.songModel == randomModel) {
        num = arc4random()%self.songArr.count;
    }else{
        num = 0;
    }
    self.songIndex = (self.songIndex+num+self.songArr.count)%self.songArr.count;
    if (self.songIndex<self.songArr.count) {
        LocalMusicEntry *entry = [self.songArr objectAtIndex:self.songIndex];
        
        BLYLogError(@"AVPlayerItem songURL - %@",entry.songURL);
        [self.playerItem removeObserver:self forKeyPath:@"status"];
        self.playerItem = [[AVPlayerItem alloc] initWithURL:entry.songURL];
        [self.player replaceCurrentItemWithPlayerItem:self.playerItem];
        [self.player play];
        [self currentItemAddObserver];
        [self configNowPlayingCenter];
    }else{
        NSLog(@"........");
    }
}

- (void)handleInterreption:(NSNotification *)noti
{
    if (self.isPlaying) {
        NSDictionary *info = noti.userInfo;
        AVAudioSessionInterruptionType type =[info[AVAudioSessionInterruptionTypeKey] integerValue];
        if (type == AVAudioSessionInterruptionTypeBegan) {
            //停止播放
            [self.player pause];
            self.isPlaying = false;
            if (self.musicStateChangeHandler) {
                self.musicStateChangeHandler();
            }
            
        }else {
            //如果中断结束会附带一个KEY值，表明是否应该恢复音频
            AVAudioSessionInterruptionOptions options =[info[AVAudioSessionInterruptionOptionKey] integerValue];
            if (options == AVAudioSessionInterruptionOptionShouldResume) {
                //恢复播放
                [self.player play];
                self.isPlaying = true;
            }
            
        }
    }
    if (self.musicStateChangeHandler) {
        self.musicStateChangeHandler();
    }
}

- (void)configNowPlayingCenter {
    
    NSLog(@"锁屏设置");
    // BASE_INFO_FUN(@"配置NowPlayingCenter");
    LocalMusicEntry *entry = self.songArr[self.songIndex];
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

@end
