//
//  BoxSongIntroduceView.m
//  BluetoothBox
//
//  Created by Mac on 2017/9/18.
//  Copyright © 2017年 Actions. All rights reserved.
//

#import "BoxSongIntroduceView.h"
typedef NS_ENUM(NSUInteger, ModelType){
    BluetoothType = 0,
    USBType,
    FMType
};
//static const CGFloat leftLabelWidth = 70;
static const CGFloat leftLabelHorzital = 20;
//static const CGFloat twoLabelHorzital = 15;
//static const CGFloat twoLabelVertical = 5;
//static const CGFloat leftScrollviewHorzital = 18;

@interface BoxSongIntroduceView ()<UIScrollViewDelegate>
{
    CGFloat leftScrollviewHorzital;
    AppDelegate *appDelegate;
}

@property (nonatomic, strong) UIImageView *labelBack;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *sliderView;
@property (nonatomic ,assign) ModelType modelType;

@end

@implementation BoxSongIntroduceView

- (void)layoutSubviews
{
    [super layoutSubviews];

}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        leftScrollviewHorzital = 15/320.0*SCREEN_WITDH;
        self.clipsToBounds = YES;
        [self cn_startai_initContentView];
        
    }
    return self;
}

- (void)cn_startai_initContentView
{

    CAGradientLayer *gradientLayer = [[CAGradientLayer alloc] init];
    
    gradientLayer.colors = @[(__bridge id)[UIColor colorWithHexColorString:@"041b24"].CGColor,(__bridge id)[UIColor colorWithHexColorString:@"1d353c"].CGColor];
    
    gradientLayer.startPoint = CGPointMake(1, 0);
    
    gradientLayer.endPoint = CGPointMake(1, 1);
    gradientLayer.cornerRadius = 5;
    
    gradientLayer.frame = CGRectMake(leftScrollviewHorzital, self.height*0.12, self.width-2*leftScrollviewHorzital, self.height*0.8);
    
    [self.layer addSublayer:gradientLayer];
    [self addSubview:self.scrollView];
   
    self.scrollView.contentSize = CGSizeMake(self.width - 2*leftLabelHorzital, self.height);
}

- (UIImageView *)labelBack
{
    if (!_labelBack) {
        _labelBack = [[UIImageView alloc] initWithFrame:CGRectMake(20, 40, self.width-40, self.height-60)];
        _labelBack.image = [UIImage imageNamed:@"playBack"];
        _labelBack.contentMode = UIViewContentModeScaleAspectFill;
        _labelBack.layer.cornerRadius = 5;
        _labelBack.layer.borderColor = [UIColor clearColor].CGColor;
        _labelBack.layer.borderWidth = 0;
    }
    return _labelBack;
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(leftScrollviewHorzital, self.height*0.12, self.width-2*leftScrollviewHorzital, self.height*0.8)];
        _scrollView.delegate = self;
        _scrollView.layer.masksToBounds = true;
        _scrollView.showsHorizontalScrollIndicator = false;
        _scrollView.showsVerticalScrollIndicator = false;
        _scrollView.bounces = NO;
        _scrollView.layer.cornerRadius = 5;
        _scrollView.layer.borderWidth = 0;
        _scrollView.layer.borderColor = [UIColor colorWithHexColorString:@"152a30"].CGColor;
        
    }
    return _scrollView;
}

- (UIImageView *)sliderView
{
    if (!_sliderView) {
        _sliderView = [[UIImageView alloc] initWithFrame:CGRectMake(self.scrollView.width-5,0, 4, (self.scrollView.height/self.scrollView.contentSize.height)*self.scrollView.height)];
        _sliderView.layer.cornerRadius = 2;
        _sliderView.backgroundColor = [UIColor colorWithHexColorString:@"485B62"];
    }
    return _sliderView;
}

- (void)setMusicEntity:(LocalMusicEntry *)musicEntity
{
    
    if (!musicEntity) {
        return;
    }

}

- (void)setCardMusic:(MusicEntry *)cardMusic
{
    
}

- (void)setCardList:(NSMutableArray *)cardList
{
    
    self.modelType = USBType;
    
    for (UIView *view in self.scrollView.subviews) {
        [view removeFromSuperview];
    }
    _cardList = cardList;
    for (NSInteger i=0; i<cardList.count; i++) {
        MusicEntry *entity = cardList[i];
        NSString *title = entity.artist == nil? @"Unknown" : entity.artist;
        NSString *subTitle = entity.name == nil? @"Unknown" : entity.name;
        MusicEntry *entity2 = [cardList lastObject];
        [self addSonViewWithTitle:title subTitle:subTitle tag:i index:i max:entity2.index];

    }
     [self.scrollView addSubview:self.sliderView];
    
    self.scrollView.contentSize = CGSizeMake(self.width - 2*leftLabelHorzital, 40*cardList.count);
    
}

- (void)setMusicList:(NSMutableArray *)musicList
{
    
    self.modelType = BluetoothType;
    
    for (UIView *view in self.scrollView.subviews) {
        [view removeFromSuperview];
    }
    _musicList = musicList;
    for (NSInteger i=0; i<musicList.count; i++) {
        MusicMessage *entity = musicList[i];
        [self addSonViewWithTitle:entity.songArtist subTitle:entity.title tag:i index:i max:musicList.count];
//        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 40*i, (self.width-leftScrollviewHorzital*2)/2.0-leftScrollviewHorzital, 30)];
//        titleLabel.text = entity.songArtist;
//        titleLabel.font = [UIFont systemFontOfSize:17];
//        titleLabel.textColor = [UIColor whiteColor];
//        [self.scrollView addSubview:titleLabel];
//
//        UILabel *fmlabel = [[UILabel alloc] initWithFrame:CGRectMake((self.width-leftScrollviewHorzital*2)/2.0+leftScrollviewHorzital, 40*i, (self.width-leftScrollviewHorzital*2)/2.0-leftScrollviewHorzital-10, 30)];
//        fmlabel.text = entity.title;
//        fmlabel.font = [UIFont systemFontOfSize:17];
//        fmlabel.textColor = [UIColor whiteColor];
//        [self.scrollView addSubview:fmlabel];
//        if (i==musicList.count-1) {
//            self.scrollView.contentSize = CGSizeMake(self.width-leftScrollviewHorzital*2, fmlabel.bottom+20);
//        }
//
//        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        btn.frame = CGRectMake(15, 40*i, self.width-30, 40);
//        [btn setBackgroundColor:[UIColor clearColor]];
//        btn.tag = 100+i;
//        [btn addTarget:self action:@selector(tapSelectedIndex:) forControlEvents:UIControlEventTouchUpInside];
//        [self.scrollView addSubview:btn];
    }
     [self.scrollView addSubview:self.sliderView];
    
    self.scrollView.contentSize = CGSizeMake(self.width - 2*leftLabelHorzital, 40*musicList.count);
    
}

- (void)setChannalList:(NSMutableArray *)channalList
{
    
    self.modelType = FMType;
    
    for (UIView *view in self.scrollView.subviews) {
        [view removeFromSuperview];
    }
    _channalList = channalList;
    for (NSInteger i=0; i<channalList.count; i++) {
        RadioEntry *entity = channalList[i];
//        NSString *title = entity.name.length?entity.name : [NSString stringWithFormat:@"ST.%ld",i];
//        NSString *subTitle = entity.name.length?entity.name : [NSString stringWithFormat:@"ST.%ld",i];
//        [self addSonViewWithTitle:title subTitle:subTitle tag:i index:i max:channalList.count];
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(30, 40*i+10, 25, 25)];
        [button setBackgroundImage:[UIImage imageNamed:@"FMReuce"] forState:UIControlStateNormal];
        button.layer.masksToBounds = false;
        button.tag = 1000+i;
        [button addTarget:self action:@selector(deleteChannel:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:button];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 40*i+10, (self.width-leftScrollviewHorzital*2)/2.0-leftScrollviewHorzital, 30)];
        titleLabel.text = entity.name.length?entity.name : [NSString stringWithFormat:@"ST.%ld",i+1];
        titleLabel.font = [UIFont systemFontOfSize:17];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.tag = 10000 + i;
        [self.scrollView addSubview:titleLabel];
        
        UILabel *fmlabel = [[UILabel alloc] initWithFrame:CGRectMake((self.width-leftScrollviewHorzital*2)/2.0+leftScrollviewHorzital, 40*i+10, (self.width-leftScrollviewHorzital*2)/2.0-leftScrollviewHorzital, 30)];
        fmlabel.text = [NSString stringWithFormat:@"FM  %.1f", entity.channel/1000.0 ];
        fmlabel.font = [UIFont systemFontOfSize:17];
        fmlabel.textColor = [UIColor whiteColor];
        fmlabel.tag = 100000 + i;
        [self.scrollView addSubview:fmlabel];
        if (i==channalList.count-1) {
            self.scrollView.contentSize = CGSizeMake(self.width-leftScrollviewHorzital*2, fmlabel.bottom+20);
        }

        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(80, 40*i+10, self.width-100, 40);
        [btn setBackgroundColor:[UIColor clearColor]];
        btn.tag = 100+i;
        [btn addTarget:self action:@selector(tapSelectedIndex:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:btn];
    }
     [self.scrollView addSubview:self.sliderView];
    
}

- (void)addSonViewWithTitle:(NSString *)title
                   subTitle:(NSString *)subTitle
                        tag:(NSInteger)tag
                      index:(NSInteger)index
                        max:(NSInteger)max
{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 40*index, (self.width-leftScrollviewHorzital*2)/2.0-leftScrollviewHorzital, 30)];
    titleLabel.text = title;
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.tag = 10000 + tag;
    [self.scrollView addSubview:titleLabel];
    
    UILabel *subLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.width-leftScrollviewHorzital*2)/2.0, 40*index, (self.width-leftScrollviewHorzital*2)/2.0-leftScrollviewHorzital, 30)];
    subLabel.text = subTitle;
    subLabel.font = [UIFont systemFontOfSize:17];
    subLabel.textColor = [UIColor whiteColor];
    subLabel.tag = 100000 + tag;
    [self.scrollView addSubview:subLabel];
    if (tag==max) {
        self.scrollView.contentSize = CGSizeMake(self.width-leftScrollviewHorzital*2, subLabel.bottom+20);
    }
    
    if (appDelegate.musicModel.songIndex == index) {
        titleLabel.textColor = RGB(252, 38, 115);
        subLabel.textColor = RGB(252, 38, 115);
    }else{
        titleLabel.textColor = [UIColor whiteColor];
        subLabel.textColor = [UIColor whiteColor];
    }
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(15, 40*index, self.width-30, 40);
    [btn setBackgroundColor:[UIColor clearColor]];
    btn.tag = 100+tag;
    [btn addTarget:self action:@selector(tapSelectedIndex:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:btn];
}

-(void)setSongInteger:(NSInteger)songInteger{
    
    _songInteger = songInteger;
    
    [self color:songInteger];
    
}

- (void)tapSelectedIndex:(UIButton *)btn
{
    
    if (self.modelType == USBType) {
        
    }else{
        [self color:btn.tag - 100];
    }
    
    if (self.tapSelectedHandler) {
        self.tapSelectedHandler(btn.tag - 100);
    }
    
}

-(void)color:(NSInteger ) integer{
    
    NSLog(@"点击了第几个 %ld",integer);
    
    for (int i = 0; i < self.musicList.count; i++) {
        
        UILabel *titleLabel = [self viewWithTag:i + 10000];
        UILabel *subLabel = [self viewWithTag:i + 100000];
        
        if (i == integer) {
            
            titleLabel.textColor = RGB(252, 38, 115);
            subLabel.textColor = RGB(252, 38, 115);
            
        }else{
            
            titleLabel.textColor = [UIColor whiteColor];
            subLabel.textColor = [UIColor whiteColor];
            
        }
        
    }
    
    for (int i = 0; i < self.channalList.count; i++) {
        
        UILabel *titleLabel = [self viewWithTag:i + 10000];
        UILabel *subLabel = [self viewWithTag:i + 100000];
        
        if (i == integer) {
            
            titleLabel.textColor = RGB(252, 38, 115);
            subLabel.textColor = RGB(252, 38, 115);
            
        }else{
            
            titleLabel.textColor = [UIColor whiteColor];
            subLabel.textColor = [UIColor whiteColor];
            
        }
        
    }
    
    for (int i = 0; i < self.cardList.count; i++) {
        
        UILabel *titleLabel = [self viewWithTag:i + 10000];
        UILabel *subLabel = [self viewWithTag:i + 100000];
        
        if (i == integer) {
            
            titleLabel.textColor = RGB(252, 38, 115);
            subLabel.textColor = RGB(252, 38, 115);
            
        }else{
            
            titleLabel.textColor = [UIColor whiteColor];
            subLabel.textColor = [UIColor whiteColor];
            
        }
        
    }
    
}

- (void)deleteChannel:(UIButton *)btn
{
    if (self.deleteFMChannelHandler) {
        self.deleteFMChannelHandler(btn.tag-1000);
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [UIView animateWithDuration:0.25 animations:^{
        
        CGPoint offset = scrollView.contentOffset;
        CGRect frame=self.sliderView.frame;
        if (offset.y==0) {
            frame.origin.y= offset.y;
        }else{
        frame.origin.y= offset.y + (offset.y+scrollView.height)/self.scrollView.contentSize.height*(scrollView.height - self.sliderView.height);
        }
        self.sliderView.frame = frame;
    }];
}

- (void)setReset{
    
    for (int i = 0; i < self.musicList.count; i++) {
        
        UILabel *titleLabel = [self viewWithTag:i + 10000];
        UILabel *subLabel = [self viewWithTag:i + 100000];
            
        titleLabel.textColor = [UIColor whiteColor];
        subLabel.textColor = [UIColor whiteColor];
        
    }
    
    for (int i = 0; i < self.channalList.count; i++) {
        
        UILabel *titleLabel = [self viewWithTag:i + 10000];
        UILabel *subLabel = [self viewWithTag:i + 100000];
    
        titleLabel.textColor = [UIColor whiteColor];
        subLabel.textColor = [UIColor whiteColor];

    }
    
    for (int i = 0; i < self.cardList.count; i++) {
        
        UILabel *titleLabel = [self viewWithTag:i + 10000];
        UILabel *subLabel = [self viewWithTag:i + 100000];

        titleLabel.textColor = [UIColor whiteColor];
        subLabel.textColor = [UIColor whiteColor];
        
    }
    
}

@end
