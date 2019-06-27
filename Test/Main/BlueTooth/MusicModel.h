//
//  MusicModel.h
//  Test
//
//  Created by Mac on 2019/5/7.
//  Copyright © 2019 QiXing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MusicMessage : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSURL *songURL;
@property (nonatomic, copy) NSString *songArtist;
@property (nonatomic, copy) NSString *albumTitle;
@property (nonatomic, assign) NSInteger total;
@property (nonatomic, strong) MPMediaItem *item;

@end

@interface MusicModel : NSObject
///歌曲列表
@property (nonatomic, strong) NSMutableArray *songArr;
///正在播放第几首
@property (nonatomic, assign) NSInteger songIndex;
///播放状态
@property (nonatomic ,assign) BOOL isPlay;

- (void)getData;

- (void)musicLast;

- (void)musicNext;

- (void)play;

- (void)pause;

- (void)remoteControlEventHandler;

@end



NS_ASSUME_NONNULL_END
