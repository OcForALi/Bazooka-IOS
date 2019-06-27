//
//  BoxMuteView.m
//  BluetoothBox
//
//  Created by Mac on 2017/9/18.
//  Copyright © 2017年 Actions. All rights reserved.
//

#import "BoxMuteView.h"

@interface BoxMuteView ()

@property (nonatomic, strong) UIImageView *state;

@end

@implementation BoxMuteView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.clipsToBounds = YES;
        [self cn_startai_initContentView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
}

- (void)cn_startai_initContentView
{
    [self addSubview:self.state];
}

- (UIImageView *)state
{
    if (!_state) {
        _state = [[UIImageView alloc] init];
    }
    return _state;
}

- (void)setIsPlay:(BOOL)isPlay
{
    _isPlay = isPlay;
    if (!isPlay) {
        self.state.image = [UIImage imageNamed:@"mute"];
        [self.state mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.equalTo(self);
            make.width.equalTo(@(43.5));
            make.height.equalTo(@(16.5));
        }];
    }else{
        self.state.image = [UIImage imageNamed:@"playing"];
        [self.state mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.equalTo(self);
            make.width.equalTo(@(61.5));
            make.height.equalTo(@(17));
        }];
    }
}

@end
