//
//  FMSliderView.m
//  Test
//
//  Created by Mac on 2017/9/26.
//  Copyright © 2017年 QiXing. All rights reserved.
//

#import "FMSliderView.h"

@interface Channel : UIView

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) UILabel *label;


@end

@implementation Channel

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self cn_startai_initContentView];
    }
    return self;
}

- (void)cn_startai_initContentView
{
    UIView *lastView = nil;
    CGFloat height =0.0;
    for (NSInteger i=0; i<105; i++) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor whiteColor];
        [self addSubview:view];
        UILabel *fmLabel;
        height = 20;
        if ((i+1)%5==0) {
            height = 30;
            fmLabel = [[UILabel alloc] init];
            fmLabel.textColor = [UIColor whiteColor];
            fmLabel.font = [UIFont fontWithName:@"Arial" size:11];
            [self addSubview:fmLabel];
            fmLabel.text = [NSString stringWithFormat:@"%ld",87+(i+1)/5];
        }
        
        if (!lastView) {
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(@(4));
                make.top.equalTo(@(self.height/2.0+5+(25-height)/2.0));
                make.width.equalTo(@(2));
                make.height.equalTo(@(height));
            }];
        }else{
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(lastView.mas_right).offset(4);
                make.top.equalTo(@(self.height/2.0+5+(25-height)/2.0));
                make.width.equalTo(@(2));
                make.height.equalTo(@(height));
            }];
        }
        if ((i+1)%5==0) {
            [fmLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(view);
                make.top.equalTo(view.mas_bottom);
                [fmLabel sizeToFit];
            }];
        }

        lastView = view;
    }
    
}

@end

@interface FMSliderView()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) Channel *channelView;
@property (nonatomic, strong) UIImageView *chunView;
@property (nonatomic, strong) UILabel *fmLabel;
@property (nonatomic, strong) UITapGestureRecognizer *tapGes;
@end

@implementation FMSliderView

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(@(0));
    }];
    self.scrollView.contentSize = CGSizeMake(640, self.height);

    [self.fmLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(@(15));
        [self.fmLabel sizeToFit];
    }];
    
    [self.channelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView.mas_left).offset(0);
        //        make.right.equalTo(self.scrollView.mas_right).offset(-30);
        make.width.equalTo(@(self.scrollView.contentSize.width));
        make.top.equalTo(self.fmLabel.mas_bottom).offset(10);
        make.height.equalTo(@(60));
    }];
    
    
    [self.chunView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(100));
        make.top.equalTo(self.fmLabel.mas_bottom);
        make.width.equalTo(@(2));
        make.height.equalTo(@(60));
    }];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self cn_startai_initContentView];
    }
    return self;
}

- (void)cn_startai_initContentView
{
    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.fmLabel];
    [self.scrollView addSubview:self.channelView];
    [self addSubview:self.chunView];
    [self addGestureRecognizer:self.tapGes];
}



- (UITapGestureRecognizer *)tapGes
{
    if (!_tapGes) {
        _tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        _tapGes.numberOfTouchesRequired = 1;
        _tapGes.numberOfTapsRequired = 1;
    }
    return _tapGes;
}


- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.bounces = false;
        _scrollView.showsVerticalScrollIndicator = false;
        _scrollView.showsHorizontalScrollIndicator = false;
        _scrollView.layer.masksToBounds = true;
        _scrollView.delegate = self;
        _scrollView.layer.masksToBounds = true;
    }
    return _scrollView;
}

- (UILabel *)fmLabel
{
    if (!_fmLabel) {
        _fmLabel = [[UILabel alloc] init];
        _fmLabel.textColor = [UIColor whiteColor];
        _fmLabel.font = [UIFont fontWithName:@"Arial" size:14];
        _fmLabel.text = @"FM  93.6 MHz";
    }
    return _fmLabel;
}

- (Channel *)channelView
{
    if (!_channelView) {
        _channelView = [[Channel alloc] init];
    }
    return _channelView;
}

- (UIImageView *)chunView
{
    if (!_chunView) {
        _chunView = [[UIImageView alloc] init];
        _chunView.image = [UIImage imageNamed:@"FMAudioGlide"];
    }
    return _chunView;
}

- (void)setFmValue:(CGFloat)fmValue
{
    if (fmValue > 87.4 && fmValue < 108.1) {
        NSLog(@"-------------fmValue------------%.1f",fmValue);
        self.chunView.left += fmValue - self.getValue;
        CGFloat offset = self.scrollView.contentOffset.x + (fmValue - self.getValue )*6.0*5;
        self.scrollView.contentOffset = CGPointMake(offset, 0);
        [self.scrollView setContentOffset:CGPointMake(offset, 0)];
        self.fmLabel.text = [NSString stringWithFormat:@"FM  %.1f MHz",fmValue];
    }
}


- (CGFloat)getValue
{
    CGPoint tempPoint = self.scrollView.contentOffset;
    NSString * off = [NSString stringWithFormat:@"%.1f", 87+(tempPoint.x+self.chunView.left)/6.0*0.2 ];
    self.fmLabel.text = [NSString stringWithFormat:@"FM  %@ MHz",off];    
  
    return  [off floatValue];
}

- (void)tapAction:(UITapGestureRecognizer *)tapGes
{
    
    CGFloat chunLeft = self.chunView.left;
    
    CGPoint tempPoint = [tapGes locationInView:tapGes.view];
    self.chunView.left = tempPoint.x;

    NSString * off = [NSString stringWithFormat:@"%.1f", 87 + (self.scrollView.contentOffset.x+self.chunView.left)/6.0 * 0.2 ];
    
    if ([off floatValue] < 108 && [off floatValue] > 87.5) {
        
    }else{
        self.chunView.left = chunLeft;
        off = [NSString stringWithFormat:@"%.1f", 87 + (self.scrollView.contentOffset.x+self.chunView.left)/6.0 * 0.2 ];
        if (tempPoint.x < 16) {
            off = @"87.5";
            self.chunView.left = 16;
        }else if (tempPoint.x > 280){
            off = @"108";
            self.chunView.left = 280;
        }
    }
    
    self.fmLabel.text = [NSString stringWithFormat:@"FM  %@ MHz",off];
//    UInt32 value = (UInt32)([off floatValue] *1000);
    if (self.fmValueHandler) {
        self.fmValueHandler([off floatValue]);
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    CGPoint tempPoint = scrollView.contentOffset;
    NSString * off = [NSString stringWithFormat:@"%.1f", 87+(self.scrollView.contentOffset.x+self.chunView.left)/6.0*.2 ];
    if ([off floatValue] < 108.1 && [off floatValue] > 87.4) {
        
    }else if ([off floatValue] > 108){
        self.chunView.left = self.chunView.left - 14;
        off = [NSString stringWithFormat:@"%.1f", 87 + (self.scrollView.contentOffset.x+self.chunView.left)/6.0 * 0.2 ];
    }else if ([off floatValue] < 87.5){
        self.chunView.left = self.chunView.left + 14;
        off = [NSString stringWithFormat:@"%.1f", 87 + (self.scrollView.contentOffset.x+self.chunView.left)/6.0 * 0.2 ];
    }
    
    self.fmLabel.text = [NSString stringWithFormat:@"FM  %@ MHz",off];
//    UInt32 value = (UInt32)([off floatValue] *1000);
    if (self.fmValueHandler) {
        self.fmValueHandler([off floatValue]);
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView; 
{
    CGPoint tempPoint = scrollView.contentOffset;
    NSString * off = [NSString stringWithFormat:@"%.1f", 87+(tempPoint.x+self.chunView.left)/6.0*0.2 ];
    self.fmLabel.text = [NSString stringWithFormat:@"FM  %@ MHz",off];
//    UInt32 value = (UInt32)([off floatValue] *1000);
    if (self.fmValueHandler) {
        self.fmValueHandler([off floatValue]);
    }
}

- (UIImage *)makeImageWithView:(UIView *)view
{
    CGSize s = view.bounds.size;
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了，关键就是第三个参数。
    UIGraphicsBeginImageContextWithOptions(s, NO, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
