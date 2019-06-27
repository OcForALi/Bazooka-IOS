//
//  LoaclMusic.h
//  Test
//
//  Created by Mac on 2017/10/28.
//  Copyright © 2017年 QiXing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

typedef NS_ENUM(NSInteger,PlayModel){
    orderModel = 1,
    randomModel = 2,
    singleModel = 3,
};

@interface LocalMusicEntry : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSURL *songURL;
@property (nonatomic, copy) NSString *songArtist;
@property (nonatomic, copy) NSString *albumTitle;
@property (nonatomic, assign) NSInteger total;
@property (nonatomic, strong) MPMediaItem *item;
@end

@interface LoaclMusic : NSObject
@property (nonatomic, assign) NSInteger songModel;
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) NSMutableArray *songArr;
@property (nonatomic, assign) NSInteger songIndex;
@property (nonatomic, copy) void (^LocalMusicArrHandler)(NSArray *arr);
@property (nonatomic, copy) void (^musicHandlerEntity)(LocalMusicEntry *music);
@property (nonatomic, copy) void (^musicStateChangeHandler)(void);

- (void)cn_startai_pauseSong;

- (void)getData;

- (void)cn_startai_playAppointSong:(NSInteger)songIndex;

- (void)cn_startai_playSong;

- (void)cn_startai_playLastSong;

- (void)cn_startai_playNextSong;

@end
