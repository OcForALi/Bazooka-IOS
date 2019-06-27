//
//  BoxPlayerControl.m
//  BluetoothBox
//
//  Created by Mac on 2017/9/18.
//  Copyright © 2017年 Actions. All rights reserved.
//

#import "BoxPlayerControl.h"
#import "BTWheelCustomeSlider.h"

@interface BoxPlayerControl ()

@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong) UIButton *lastSongBtn;
@property (nonatomic, strong) UIButton *nextSongBtn;
@property (nonatomic, strong) UIButton *fmAddBtn;
@property (nonatomic, strong) UIImageView *add;
@property (nonatomic, strong) UIImageView *reduce;
@property (nonatomic, strong) BTWheelCustomeSlider *sliderView;

@end

@implementation BoxPlayerControl

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
    if (!_isFM) {
        CGFloat size =  IS_IPHONE_5_OR_LESS ?  40 : 50;

        [self.nextSongBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self).offset(20);
            make.width.height.equalTo(@(size));
        }];
        
        [self.lastSongBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.nextSongBtn.mas_left).offset(-30);
            make.centerY.equalTo(self.nextSongBtn);
            make.width.height.equalTo(@(size));
        }];
        
        [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nextSongBtn.mas_right).offset(30);
            make.centerY.equalTo(self.nextSongBtn);
            make.width.height.equalTo(@(size));
        }];
        
    }else{
        
//        CGFloat hor = IS_IPHONE_5_OR_LESS ?  10 : 15;
//        CGFloat size = (SCREEN_WITDH - 6*hor- 60)/5.0;
//
        CGFloat hor = IS_IPHONE_5_OR_LESS ?  10 : 15;
        CGFloat size = (SCREEN_WITDH - 7*hor- 60)/6.0;

        [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self).offset(20);
            make.width.height.equalTo(@(size+5));
        }];
        
        [self.lastSongBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(hor);
            make.centerY.equalTo(self.playBtn);
            make.width.height.equalTo(@(size));
        }];

        [self.nextSongBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.lastSongBtn.mas_right).offset(hor);
            make.centerY.equalTo(self.playBtn);
            make.width.height.equalTo(@(size));
        }];
        
        [self.fmAddBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nextSongBtn.mas_right).offset(hor);
            make.centerY.equalTo(self.playBtn);
            make.width.height.equalTo(@(size));
        }];

        [self.playBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.fmAddBtn.mas_right).offset(hor);
            make.top.equalTo(self).offset(20);
            make.width.height.equalTo(@(size+5));
        }];
        
        [self.reduce mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.playBtn.mas_right).offset(hor);
            make.centerY.equalTo(self.playBtn);
            make.width.height.equalTo(@(size));
        }];
        
        [self.add mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.reduce.mas_right).offset(hor);
            make.centerY.equalTo(self.playBtn);
            make.width.height.equalTo(@(size));
        }];

    }
    
    [self.sliderView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.top.equalTo(self.lastSongBtn.mas_bottom).offset(20);
        make.right.equalTo(self.mas_right).offset(-15);
        make.height.equalTo(@(50));
    }];
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.clipsToBounds = YES;
        self.hideLastNext = false;
        [self cn_startai_initContentView];
    }
    return self;
}

- (void)cn_startai_initContentView
{
    [self addSubview:self.playBtn];
    [self addSubview:self.lastSongBtn];
    [self addSubview:self.nextSongBtn];
    [self addSubview:self.fmAddBtn];
    [self addSubview:self.add];
    [self addSubview:self.reduce];
    [self addSubview:self.sliderView];
}

- (UIButton *)playBtn
{
    if (!_playBtn) {
        _playBtn = ({
            UIButton *tmpV = [UIButton buttonWithType:UIButtonTypeCustom];
            [tmpV setBackgroundImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
            tmpV.layer.cornerRadius = 16;
            [tmpV addTarget:self action:@selector(cn_startai_playSong) forControlEvents:UIControlEventTouchUpInside];
            
            tmpV;
        });
    }
    return _playBtn;
}

- (UIButton *)lastSongBtn
{
    if (!_lastSongBtn) {
        _lastSongBtn = ({
            UIButton *tmpV = [UIButton buttonWithType:UIButtonTypeCustom];
            [tmpV setBackgroundImage:[UIImage imageNamed:@"lastSong"] forState:UIControlStateNormal];
//            [tmpV setBackgroundColor:[UIColor redColor]];
            [tmpV addTarget:self action:@selector(cn_startai_playLastSong) forControlEvents:UIControlEventTouchUpInside];

            
            tmpV;
        });
    }
    return _lastSongBtn;
}

- (UIButton *)nextSongBtn
{
    if (!_nextSongBtn) {
        _nextSongBtn = ({
            UIButton *tmpV = [UIButton buttonWithType:UIButtonTypeCustom];
            [tmpV setBackgroundImage:[UIImage imageNamed:@"nextSong"] forState:UIControlStateNormal];
//            [tmpV setBackgroundColor:[UIColor redColor]];
            [tmpV addTarget:self action:@selector(cn_startai_playNextSong) forControlEvents:UIControlEventTouchUpInside];

            
            tmpV;
        });
    }
    return _nextSongBtn;
}

- (UIButton *)fmAddBtn
{
    if (!_fmAddBtn) {
        _fmAddBtn =  ({
            UIButton *tmpV = [UIButton buttonWithType:UIButtonTypeCustom];
            [tmpV setBackgroundImage:[UIImage imageNamed:@"FMAdd"] forState:UIControlStateNormal];
            //            [tmpV setBackgroundColor:[UIColor redColor]];
            [tmpV addTarget:self action:@selector(cn_startai_fmAdd) forControlEvents:UIControlEventTouchUpInside];
            
            
            tmpV;
        });
    }
    return _fmAddBtn;
}

- (UIImageView *)add
{
    if (!_add) {
        _add = [[UIImageView alloc] init];
        _add.image = [UIImage imageNamed:@"FineTuneAdd"];
        _add.userInteractionEnabled = YES;

        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cn_startai_tapAdd)];
        tapGes.numberOfTapsRequired = 1;
        [_add addGestureRecognizer:tapGes];
        
    }
    return _add;
}

- (UIImageView *)reduce
{
    if (!_reduce) {
        _reduce = [[UIImageView alloc] init];
        _reduce.image = [UIImage imageNamed:@"FineTuneReduce"];
        _reduce.userInteractionEnabled = YES;

        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cn_startai_tapReduce)];
        tapGes.numberOfTapsRequired = 1;
        [_reduce addGestureRecognizer:tapGes];
    }
    return _reduce;
}

- (BTWheelCustomeSlider *)sliderView
{
    @weakify(self);
    if (!_sliderView) {
        _sliderView = [[BTWheelCustomeSlider alloc] init];
        _sliderView.lineHeght = (28/468.0)*(self.width-30-50);
        _sliderView.thumbH = 35;
        _sliderView.thumbW = 35;
        _sliderView.minimumValue = 0;
        _sliderView.maximumValue = 31;
        _sliderView.thumbImage = [UIImage imageNamed:@"voice"];
        _sliderView.show = YES;
        _sliderView.value = 0.3;
        _sliderView.progressImage = [UIImage imageNamed:@"voiceSlider"];

        _sliderView.BTWheelCustomeSliderValue = ^(CGFloat value) {
            if ([weak_self.delegate respondsToSelector:@selector(cn_startai_voiceChanged:)]) {
                [weak_self.delegate cn_startai_voiceChanged:value];
            }
        };
        _sliderView.BTWheelCustomeSliderEndValue = ^(CGFloat value) {
            if ([weak_self.delegate respondsToSelector:@selector(cn_startai_voiceChangedEnd:)]) {
                [weak_self.delegate cn_startai_voiceChangedEnd:value];
            }
        };
    }
    return _sliderView;
}

- (CGFloat)volumeValue
{
    return self.sliderView.KValue;
}

- (void)setHideLastNext:(BOOL)hideLastNext
{
    _hideLastNext = hideLastNext;
    if (hideLastNext) {
        self.lastSongBtn.hidden = true;
        self.nextSongBtn.hidden  = true;
        [self.playBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self).offset(15);
            make.width.height.equalTo(@(60));
        }];
    }else{
        self.lastSongBtn.hidden = false;
        self.nextSongBtn.hidden  = false;
    }
}

- (void)setSetVoice:(CGFloat)setVoice
{
    _sliderView.value = setVoice;
}

#pragma mark event + BoxPlayControlProctol

- (void)cn_startai_playSong
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(cn_startai_playSong)]) {
        [self.delegate cn_startai_playSong];
    }
}

- (void)cn_startai_playLastSong
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(cn_startai_playLastSong)]) {
        [self.delegate cn_startai_playLastSong];
    }
}

- (void)cn_startai_playNextSong
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(cn_startai_playNextSong)]) {
        [self.delegate cn_startai_playNextSong];
    }
}


- (void)cn_startai_fmAdd
{
    if (self.addLoveList) {
        self.addLoveList();
    }
}

- (void)cn_startai_tapAdd
{
    if ([self.delegate respondsToSelector:@selector(finetuneAdd)]) {
        [self.delegate finetuneAdd];
    }
}

- (void)cn_startai_tapReduce
{
    if ([self.delegate respondsToSelector:@selector(finetuneReduce)]) {
        [self.delegate finetuneReduce];
    }
}

- (void)setPlayImg:(UIImage *)playImg
{
    [self.playBtn setBackgroundImage:playImg forState:UIControlStateNormal];
}

@end
