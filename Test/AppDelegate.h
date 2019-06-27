//
//  AppDelegate.h
//  Test
//
//  Created by Mac on 2017/9/21.
//  Copyright © 2017年 QiXing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "BluzManager.h"
#import "LoaclMusic.h"
#import "MusicModel.h"

typedef NS_ENUM(NSInteger,QXConnectType){
    BAZ_None = 1,
    BAZ_G2 = 2,
    BAZ_G2_FM = 3,
};
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) BluzDevice *mBluzConnector;
@property (strong, nonatomic) BluzManager *mMediaManager;
@property (strong, nonatomic) id<GlobalManager> globalManager;
@property (strong, nonatomic) id<MusicManager> musicManager;
@property (strong, nonatomic) id<RadioManager> radioManager;
@property (strong, nonatomic) id<USBSpeakerManager> usbSpeakerManager;
@property (strong, nonatomic) id<AuxManager> auxManager;
//@property (strong, nonatomic) LoaclMusic *player;
@property (nonatomic ,strong) MusicModel *musicModel;
@property (assign, nonatomic) BOOL isConnected;
@property (nonatomic, assign) BOOL canUseUSB;
@property (nonatomic, assign) QXConnectType conncetType;
@property (nonatomic, assign) CGFloat currentVoice;
@property (nonatomic, assign) NSInteger maxVoice;
@property (nonatomic, assign) NSInteger model;
@property (strong, nonatomic) UIWindow *window;
///播放器相关
@property(nonatomic,strong) AVPlayer *player;//播放器
@property(nonatomic,strong) AVPlayerItem *playItem;
@property(nonatomic,assign) float AllTime;
@property(nonatomic,assign) int minute;
@property(nonatomic,assign) int second;
@property(strong, nonatomic)NSTimer *mTimer;
// 注册计时
@property (nonatomic ,assign) NSInteger count;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

