//
//  MusicModel.m
//  Test
//
//  Created by Mac on 2019/5/7.
//  Copyright © 2019 QiXing. All rights reserved.
//

#import "MusicModel.h"
#import <MediaPlayer/MediaPlayer.h>
#import <MediaPlayer/MPRemoteCommandCenter.h>
#import <MediaPlayer/MPRemoteCommand.h>

@implementation MusicMessage

@end

@interface MusicModel ()

{
    AppDelegate *appDelegate;
}

@end

@implementation MusicModel

- (instancetype)init
{
    
    if (self == [super init]) {
        
        [self getData];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(EndPlay:) name:@"EndPlay" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NoSongs:) name:@"NoSongs" object:nil];
        
    }
    
    return self;
}

- (void)getData
{
    
    self.songArr = [NSMutableArray array];
    
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

    MPMediaQuery *music = [MPMediaQuery songsQuery];
    MPMediaPropertyPredicate *predicate = [MPMediaPropertyPredicate predicateWithValue:[NSNumber numberWithInteger:MPMediaTypeMusic] forProperty:MPMediaItemPropertyMediaType];
    [music addFilterPredicate:predicate];
    
    for (MPMediaItem *song in music.items) {
        
        MusicMessage *entity = [[MusicMessage alloc] init];
        entity.title = [song valueForProperty:MPMediaItemPropertyTitle];
        entity.songURL = [song valueForProperty:MPMediaItemPropertyAssetURL];
        entity.songArtist = [song valueForProperty:MPMediaItemPropertyArtist];
        entity.albumTitle = [song valueForProperty:MPMediaItemPropertyAlbumTitle];
        entity.total= [[song valueForKey:MPMediaItemPropertyPlaybackDuration] integerValue];
        entity.item = song;
        [self.songArr addObject:entity];
        
    }
    
}

- (void)setSongIndex:(NSInteger)songIndex
{
    _songIndex = songIndex;
}

- (void)musicLast{
    
    if (self.songIndex == 0) {
        
        self.songIndex = self.songArr.count - 1;
        
        MusicMessage *musicMessage = self.songArr[self.songIndex];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"musicNext" object:musicMessage];
        
    }else{
        
        self.songIndex--;
        
        MusicMessage *musicMessage = self.songArr[self.songIndex];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"musicNext" object:musicMessage];
        
    }
    
}

- (void)musicNext{
    
    if (self.songIndex == self.songArr.count-1) {

        self.songIndex = 0;
        
        MusicMessage *musicMessage = self.songArr[self.songIndex];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"musicNext" object:musicMessage];
        
    }else{
        
        self.songIndex++;
        
        MusicMessage *musicMessage = self.songArr[self.songIndex];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"musicNext" object:musicMessage];
        
    }
    
}

- (void)play{
    
    self.isPlay = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"musicStart" object:[NSString stringWithFormat:@""]];
    
}

-(void)pause{
    
    self.isPlay = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"musicSuspended" object:[NSString stringWithFormat:@""]];
    
}

-(void)EndPlay:(NSNotification *)sender{
    
    //    self.playControl.playImg = [UIImage imageNamed:@"play"];
    
    [self musicNext];
    
}

-(void)NoSongs:(NSNotification *)sender{
    
    self.songIndex = 0;
    
    if (self.songArr.count != 0) {
        
        MusicMessage *musicMessage = self.songArr[appDelegate.musicModel.songIndex];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"musicNext" object:musicMessage];
        
    }
    
}

- (void)remoteControlEventHandler
{
    // 直接使用sharedCommandCenter来获取MPRemoteCommandCenter的shared实例
    MPRemoteCommandCenter *commandCenter = [MPRemoteCommandCenter sharedCommandCenter];
    
    MPRemoteCommand *pauseCommand = [commandCenter pauseCommand];
    [pauseCommand setEnabled:YES];
    [pauseCommand addTarget:self action:@selector(pauseAction:)];
    
    MPRemoteCommand *playCommand = [commandCenter playCommand];
    [playCommand setEnabled:YES];
    [playCommand addTarget:self action:@selector(playAction:)];
    
    MPRemoteCommand *nextCommand = [commandCenter nextTrackCommand];
    [nextCommand setEnabled:YES];
    [nextCommand addTarget:self action:@selector(nextTrackAction:)];
    
    MPRemoteCommand *previousCommand = [commandCenter previousTrackCommand];
    [previousCommand setEnabled:YES];
    [previousCommand addTarget:self action:@selector(previousTrackAction:)];
    
    // 启用播放命令 (锁屏界面和上拉快捷功能菜单处的播放按钮触发的命令)
    
//    commandCenter.playCommand.enabled = YES;
//
//    // 为播放命令添加响应事件, 在点击后触发
//    [commandCenter.playCommand addTarget:self action:@selector(playAction:)];
//
//    // 播放, 暂停, 上下曲的命令默认都是启用状态, 即enabled默认为YES
//    // 为暂停, 上一曲, 下一曲分别添加对应的响应事件
//    [commandCenter.pauseCommand addTarget:self action:@selector(pauseAction:)];
//    [commandCenter.previousTrackCommand addTarget:self action:@selector(previousTrackAction:)];
//    [commandCenter.nextTrackCommand addTarget:self action:@selector(nextTrackAction:)];
//
    // 启用耳机的播放/暂停命令 (耳机上的播放按钮触发的命令)
//    commandCenter.togglePlayPauseCommand.enabled = YES;
    // 为耳机的按钮操作添加相关的响应事件
//    [commandCenter.togglePlayPauseCommand addTarget:self action:@selector(playOrPauseAction:)];
}

-(void)playAction:(id)obj{
    [self play];
}
-(void)pauseAction:(id)obj{
    [self pause];
}
-(void)nextTrackAction:(id)obj{
    [self musicNext];
}
-(void)previousTrackAction:(id)obj{
    [self musicLast];
}
-(void)playOrPauseAction:(id)obj{
//    if ([[HYPlayerTool sharePlayerTool] isPlaying]) {
//        [[HYPlayerTool sharePlayerTool] pause];
//    }else{
//        [[HYPlayerTool sharePlayerTool] play];
//    }
}

@end
