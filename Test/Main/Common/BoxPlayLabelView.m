//
//  BoxPlayLabelView.m
//  BluetoothBox
//
//  Created by Mac on 2017/9/18.
//  Copyright © 2017年 Actions. All rights reserved.
//

#import "BoxPlayLabelView.h"
#import "AutoScrollLabel.h"

@interface BoxPlayLabelView ()
@property (nonatomic, strong) UIImageView *labelBack;
@property (nonatomic, strong) UILabel *albumLabel;
@property (nonatomic, strong) UIImageView *line;
@property (nonatomic, strong) UIView *songNameView;
@property (nonatomic, strong) AutoScrollLabel *songNameLabel;
@property (nonatomic, strong) UILabel *durationLabel;

@end

@implementation BoxPlayLabelView

- (void)layoutSubviews
{
    [super layoutSubviews];

    [self.albumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(20));
        make.top.equalTo(@(10));
        [self.albumLabel sizeToFit];
    }];
    
    [self.durationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-10);
        make.right.equalTo(self).offset(-20);
        [self.durationLabel sizeToFit];
    }];
    
    [self.songNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@20);
//        make.left.right.equalTo(@0);
        make.bottom.equalTo(self.mas_bottom).offset(-7);
        make.width.equalTo(@(self.width -80));
        make.height.equalTo(@(25));
//        [self.songNameLabel sizeToFit];
    }];
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame: frame]) {
        self.clipsToBounds = YES;
        [self cn_startai_initContentView];
    }
    return self;
}

- (void)cn_startai_initContentView
{
    [self addSubview:self.labelBack];
    [self addSubview:self.albumLabel];
    [self addSubview:self.songNameLabel];
    [self addSubview:self.durationLabel];

}

- (UIImageView *)labelBack
{
    if (!_labelBack) {
        _labelBack = [[UIImageView alloc] init];
        _labelBack.image = [UIImage imageNamed:@"playBack"];
        _labelBack.contentMode = UIViewContentModeScaleAspectFill;

    }
    return _labelBack;
}

- (UILabel *)albumLabel
{
    if (!_albumLabel) {
        _albumLabel = ({
            UILabel *tmpV = [[UILabel alloc] init];
            tmpV.textColor = [UIColor whiteColor];
            tmpV.font = [UIFont fontWithName:@"Impact" size:14];
            tmpV.textAlignment = NSTextAlignmentLeft;
            
            tmpV;
        });
    }
    return _albumLabel;
}

- (AutoScrollLabel *)songNameLabel
{
    if (!_songNameLabel) {
        _songNameLabel = ({
            AutoScrollLabel *tmpV = [[AutoScrollLabel alloc] initWithFrame:CGRectMake(0, self.height-35, self.width-120, 25)];
            tmpV.textColor = [UIColor whiteColor];
            
            tmpV;
        });
    }
    return _songNameLabel;
}

- (UILabel *)durationLabel
{
    if (!_durationLabel) {
        _durationLabel = ({
            UILabel *tmpV = [[UILabel alloc] init];
            tmpV.textColor = [UIColor whiteColor];
            tmpV.font = [UIFont fontWithName:@"Arial" size:14];
            tmpV.textAlignment = NSTextAlignmentRight;
            
            tmpV;
        });
    }
    return _durationLabel;
}

- (void)setMusicMessage:(MusicMessage *)musicMessage
{
    self.songNameLabel.text = musicMessage.title;
    self.albumLabel.text = musicMessage.songArtist;
    self.durationLabel.text = [NSString stringWithFormat:@"%ld:%ld",(musicMessage.total/60),(musicMessage.total%60)];
}

- (void)setCardMusic:(MusicEntry *)cardMusic
{
    if (![cardMusic.title isEqualToString:self.songNameLabel.text]) {
        self.songNameLabel.text = cardMusic.title;
    }
    self.albumLabel.text = cardMusic.artist;
}

- (void)setDuration:(UInt32)duration
{
    NSInteger dur = duration /1000;
    self.durationLabel.text = [NSString stringWithFormat:@"%ld:%ld",(dur/60),(dur%60)];
}

- (void)start
{
    [self.songNameLabel start];
}

- (void)stop
{
    [self.songNameLabel stop];
}

- (void)scroll
{
    
}

@end
