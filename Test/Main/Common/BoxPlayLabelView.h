//
//  BoxPlayLabelView.h
//  BluetoothBox
//
//  Created by Mac on 2017/9/18.
//  Copyright © 2017年 Actions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoaclMusic.h"
#import "MusicEntry.h"
#import "MusicModel.h"

@interface BoxPlayLabelView : UIView

@property (nonatomic, strong) MusicEntry *cardMusic;
@property (nonatomic ,copy) MusicMessage *musicMessage;
@property (nonatomic, assign) UInt32 duration;

- (void) scroll;

- (void)start;
- (void)stop;

@end
