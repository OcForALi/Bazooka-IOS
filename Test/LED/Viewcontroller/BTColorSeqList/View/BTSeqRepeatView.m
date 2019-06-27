//
//  BTWheelRepeatView.m
//  Test
//
//  Created by Mac on 2017/12/18.
//  Copyright © 2017年 QiXing. All rights reserved.
//

#import "BTSeqRepeatView.h"

@interface BTSeqRepeatView ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIImageView *backGroundView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *currentLabel;
@property (nonatomic, assign) BOOL isScrolling;

@end

@implementation BTSeqRepeatView

- (void)dealloc
{
    [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
}

- (void)layoutSubviews
{
    [super layoutSubviews];

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
    [self addSubview:self.backGroundView];
    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.currentLabel];
    [self.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];

}

- (UIImageView *)backGroundView
{
    if (!_backGroundView) {
        _backGroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, self.width, 20)];
        _backGroundView.image = [UIImage imageNamed:@"repeatBackGround"];
    }
    return _backGroundView;
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.delegate = self;
        _scrollView.contentSize = CGSizeMake(self.width/5.0 *24, self.height);
        _scrollView.bounces = false;
        _scrollView.showsHorizontalScrollIndicator = false;
    }
    return _scrollView;
}

- (UILabel *)currentLabel
{
    if (!_currentLabel) {
        _currentLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.width/5.0*2.0, 20, self.width/5.0, 20)];
        _currentLabel.backgroundColor = [UIColor clearColor];
        _currentLabel.textColor = [UIColor whiteColor];
        _currentLabel.font = [UIFont systemFontOfSize:11];
    }
    return _currentLabel;
}

- (void)setRepeatView
{
    for (NSInteger i=1; i<25; i++) {
        UILabel *tmL = [self.scrollView viewWithTag:i];
        if (!tmL) {
            tmL = [[UILabel alloc] initWithFrame:CGRectMake((i-1)*self.width/5.0, 20, self.width/5.0, 20)];
        }
        if (i>2 && i<23) {
            tmL.text = [NSString stringWithFormat:@"%ld",i-2];
            tmL.font = [UIFont systemFontOfSize:11];
            tmL.textColor = [UIColor grayColor];
            tmL.tag = i-2;
            tmL.textAlignment = NSTextAlignmentCenter;
            tmL.backgroundColor = [UIColor clearColor];
            if (i-2==_repeat) {
                tmL.textColor = [UIColor whiteColor];
            }
        }

        [_scrollView addSubview:tmL];
    }
    [_scrollView setContentOffset:CGPointMake(self.width/5.0*(_repeat-1), 0)];
    _currentLabel.frame = CGRectMake(self.width/5.0*(_repeat+1), 20, self.width/5.0, 20);
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentOffset"] ) {
        CGPoint offset = [change[NSKeyValueChangeNewKey] CGPointValue];
        
        NSInteger num = offset.x/(self.width/5.0)+1;
        if ((NSInteger)(num+0.5)>num) {
            num = num + 1;
        }
        for (UIView *view in self.scrollView.subviews) {
            if ([view isKindOfClass:[UILabel class]]) {
                ((UILabel *)view).textColor = [UIColor grayColor];
            }
        }

        UILabel *label = [self.scrollView viewWithTag:num];
        if ([label isKindOfClass:[UILabel class]]) {
            label.textColor = [UIColor whiteColor];
            _currentLabel.frame = CGRectMake(offset.x+ self.width/5.0*2, 20, self.width/5.0, 20);
        }

    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self endScroll:scrollView];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self endScroll:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self endScroll:scrollView];
}

- (void)endScroll:(UIScrollView *)scrollView
{
    CGFloat num = scrollView.contentOffset.x/(self.width/5.0)+1;
    if ((NSInteger)(num+0.5)>num) {
        num = num + 1;
    }
    
    for (UIView *view in self.scrollView.subviews) {
        if ([view isKindOfClass:[UILabel class]]) {
            ((UILabel *)view).textColor = [UIColor grayColor];
        }
    }
    
    UILabel *label = [self.scrollView viewWithTag:num];
    label.textColor = [UIColor whiteColor];
    
    _currentLabel.frame = CGRectMake(self.width/5.0*(num+2), 0, self.width/5.0, self.height);
    if (self.BTSeqReapeatHandler) {
        self.BTSeqReapeatHandler(num);
    }
}

- (void)setRepeat:(NSInteger)repeat
{
    _repeat = repeat;
    [self setRepeatView];
}



@end
