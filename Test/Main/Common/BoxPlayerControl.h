//
//  BoxPlayerControl.h
//  BluetoothBox
//
//  Created by Mac on 2017/9/18.
//  Copyright © 2017年 Actions. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol BoxPlayControlProctol <NSObject>

@optional

- (void)cn_startai_playSong;
- (void)cn_startai_playLastSong;
- (void)cn_startai_playNextSong;
- (void)cn_startai_voiceChanged:(CGFloat)value;
- (void)cn_startai_voiceChangedEnd:(CGFloat)value;
//点击
- (void)finetuneAdd;
- (void)finetuneReduce;


@end

@interface BoxPlayerControl : UIView

@property (nonatomic, weak) id<BoxPlayControlProctol>delegate;
@property (nonatomic, assign) BOOL isFM;               //是否fm模式 按钮个数不同
@property (nonatomic, strong) UIImage *playImg;         //播放按钮素材
@property (nonatomic, assign) CGFloat volumeValue;      //获取当前音量值
@property (nonatomic, assign) BOOL hideLastNext;       //隐藏上一曲下一曲按钮
@property (nonatomic, assign) CGFloat setVoice;         //改变当前音量条数值
@property (nonatomic, copy) void (^addLoveList)(void);   //添加fm收藏
@end
