//
//  BoxPlayerBackGround.m
//  BluetoothBox
//
//  Created by Mac on 2017/9/18.
//  Copyright © 2017年 Actions. All rights reserved.
//

#import "BoxPlayerBackGround.h"

@interface BoxPlayerBackGround ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIImageView *labelBack;

@property (nonatomic, strong) UIImageView *nutOne;
@property (nonatomic, strong) UIImageView *nutTwo;
@property (nonatomic, strong) UIImageView *nutThree;
@property (nonatomic, strong) UIImageView *nutFour;
@property (nonatomic, strong) UIImageView *pageOne;
@property (nonatomic, strong) UIImageView *pageTwo;
@property (nonatomic, strong) UIView *pageBack;

@end

@implementation BoxPlayerBackGround


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.labelBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(@(0));
    }];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(@(0));
    }];
    
    [self.nutOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(6));
        make.top.equalTo(@(5));
        make.width.height.equalTo(@(10));
    }];
    
    [self.nutTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(5);
        make.right.equalTo(self).offset(-6);
        make.width.height.equalTo(@(10));
    }];
    
    [self.nutThree mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-5);
        make.right.equalTo(self).offset(-6);
        make.width.height.equalTo(@(10));
    }];
    
    [self.nutFour mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(6);
        make.bottom.equalTo(self).offset(-5);
        make.width.equalTo(@(10));
    }];
    
    [self.pageBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(@(0));
        make.width.equalTo(@(self.width));
        make.height.equalTo(@(30));
    }];
    
    [self.pageOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset((self.width-14-10)/2.0);
        make.top.equalTo(@(8));
        make.width.height.equalTo(@(8));
    }];
    
    [self.pageTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.pageOne.mas_right).offset(14);
        make.top.equalTo(@(8));
        make.width.height.equalTo(@(8));
    }];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.clipsToBounds = YES;
        [self cn_startai_initContentView];
    }
   return self;
}

- (void)cn_startai_initContentView
{
    [self addSubview:self.labelBack];
    CAGradientLayer *gradientLayer = [[CAGradientLayer alloc] init];
    
    gradientLayer.colors = @[(__bridge id)[UIColor colorWithHexColorString:@"041b24"].CGColor,(__bridge id)[UIColor colorWithHexColorString:@"1d353c"].CGColor];
    gradientLayer.startPoint = CGPointMake(1, 0);
    gradientLayer.endPoint = CGPointMake(1, 1);
    gradientLayer.cornerRadius = 5;
    gradientLayer.frame = CGRectMake(15/320.0*SCREEN_WITDH, self.height*0.12, self.width-2*(15/320.0*SCREEN_WITDH), 100);
    [self.layer addSublayer:gradientLayer];
    [self addSubview:self.scrollView];
    [self addSubview:self.pageBack];
    [self addSubview:self.nutOne];
    [self addSubview:self.nutTwo];
    [self addSubview:self.nutThree];
    [self addSubview:self.nutFour];
    [self.pageBack addSubview:self.pageOne];
    [self.pageBack addSubview:self.pageTwo];
    UISwipeGestureRecognizer *left = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipAction:)];
    left.direction = UISwipeGestureRecognizerDirectionLeft;
    [_scrollView addGestureRecognizer:left];
    UISwipeGestureRecognizer *right = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipAction:)];
    right.direction = UISwipeGestureRecognizerDirectionRight;
    [_scrollView addGestureRecognizer:right];

}

- (UIView *)pageBack
{
    if (!_pageBack) {
        _pageBack = [[UIView alloc] init];
//        _pageBack.backgroundColor = [UIColor clearColor];
        _pageBack.userInteractionEnabled = YES;
        UISwipeGestureRecognizer *left = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipAction:)];
        left.direction = UISwipeGestureRecognizerDirectionLeft;
        [_pageBack addGestureRecognizer:left];
        UISwipeGestureRecognizer *right = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipAction:)];
        right.direction = UISwipeGestureRecognizerDirectionRight;
        [_pageBack addGestureRecognizer:right];
    }
    return _pageBack;
}

- (UIImageView *)labelBack
{
    if (!_labelBack) {
        _labelBack = [[UIImageView alloc] init];
//        _labelBack.image = [UIImage imageNamed:@"playBack"];
        _labelBack.backgroundColor = [UIColor colorWithHexColorString:@"152a30"];
        _labelBack.contentMode = UIViewContentModeScaleAspectFill;
        _labelBack.layer.cornerRadius = 5;
        _labelBack.layer.borderWidth = 0.5;
        _labelBack.layer.borderColor = [UIColor colorWithHexColorString:@"080707"].CGColor;
    }
    return _labelBack;
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.bounces = NO;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (UIImageView *)nutOne
{
    if (!_nutOne) {
        _nutOne = ({
            UIImageView *tmpV = [[UIImageView alloc] init];
            tmpV.layer.cornerRadius = 5;
            tmpV.image = [UIImage imageNamed:@"nut"];
            
            tmpV;
        });
    }
    return _nutOne;
}

- (UIImageView *)nutTwo
{
    if (!_nutTwo) {
        _nutTwo = ({
            UIImageView *tmpV = [[UIImageView alloc] init];
            tmpV.layer.cornerRadius = 5;
            tmpV.image = [UIImage imageNamed:@"nut"];
            
            tmpV;
        });
    }
    return _nutTwo;
}

- (UIImageView *)nutThree
{
    if (!_nutThree) {
        _nutThree = ({
            UIImageView *tmpV = [[UIImageView alloc] init];
            tmpV.layer.cornerRadius = 5;
            tmpV.image = [UIImage imageNamed:@"nut"];
            
            tmpV;
        });
    }
    return _nutThree;
}

- (UIImageView *)nutFour
{
    if (!_nutFour) {
        _nutFour = ({
            UIImageView *tmpV = [[UIImageView alloc] init];
            tmpV.layer.cornerRadius = 5;
            tmpV.image = [UIImage imageNamed:@"nut"];
            
            tmpV;
        });
    }
    return _nutFour;
}


- (UIImageView *)pageOne
{
    if (!_pageOne) {
        _pageOne = ({
            UIImageView *tmpV = [[UIImageView alloc] init];
            tmpV.layer.cornerRadius = 5;
            tmpV.image = [UIImage imageNamed:@"PagingPointSelected"];
            
            tmpV;
        });
    }
    return _pageOne;
}

- (UIImageView *)pageTwo
{
    if (!_pageTwo) {
        _pageTwo = ({
            UIImageView *tmpV = [[UIImageView alloc] init];
            tmpV.layer.cornerRadius = 5;
            tmpV.image = [UIImage imageNamed:@"PagingPointNormal"];
            
            tmpV;
        });
    }
    return _pageTwo;
}

- (void)setHidePage:(BOOL)hidePage
{
    self.pageOne.hidden = hidePage;
    self.pageTwo.hidden = hidePage;
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    CGPoint point = self.scrollView.contentOffset;
    if (point.x>1) {
        self.pageOne.image = [UIImage imageNamed:@"PagingPointNormal"];
        self.pageTwo.image = [UIImage imageNamed:@"PagingPointSelected"];
    }else{
        self.pageOne.image = [UIImage imageNamed:@"PagingPointSelected"];
        self.pageTwo.image = [UIImage imageNamed:@"PagingPointNormal"];
    }
}

- (void)setPoint:(CGPoint *)point{
    
    if (point->x>1) {
        self.pageOne.image = [UIImage imageNamed:@"PagingPointNormal"];
        self.pageTwo.image = [UIImage imageNamed:@"PagingPointSelected"];
    }else{
        self.pageOne.image = [UIImage imageNamed:@"PagingPointSelected"];
        self.pageTwo.image = [UIImage imageNamed:@"PagingPointNormal"];
    }
    
}

- (void)swipAction:(UISwipeGestureRecognizer *)swip
{
    if (swip.direction == UISwipeGestureRecognizerDirectionLeft && self.scrollView.contentSize.width > self.width) {
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.width, 0) animated:YES];
    }else if (swip.direction == UISwipeGestureRecognizerDirectionRight && self.scrollView.contentOffset.x>1){
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}

@end
