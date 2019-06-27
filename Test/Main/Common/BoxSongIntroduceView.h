//
//  BoxSongIntroduceView.h
//  BluetoothBox
//
//  Created by Mac on 2017/9/18.
//  Copyright © 2017年 Actions. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "LoaclMusic.h"
//#import "MusicEntry.h"
#import "MusicModel.h"
@interface BoxSongIntroduceView : UIScrollView

//@property (nonatomic, strong) LocalMusicEntry *musicEntity;
@property (nonatomic, strong) MusicMessage *cardMusic;
@property (nonatomic, assign) BOOL isFM;
@property (nonatomic, assign) BOOL isBluetooth;
@property (nonatomic, strong) NSMutableArray *musicList;
@property (nonatomic, strong) NSMutableArray *channalList;
@property (nonatomic, strong) NSMutableArray *cardList;
@property (nonatomic, assign) NSInteger songInteger;
@property (nonatomic, copy) void(^tapSelectedHandler)(NSInteger row);
@property (nonatomic, copy) void(^deleteFMChannelHandler)(NSInteger row);

- (void)setReset;

@end
