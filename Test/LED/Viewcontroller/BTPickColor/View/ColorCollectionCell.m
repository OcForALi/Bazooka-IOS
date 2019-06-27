//
//  ColorCollectionCell.m
//  BluetoothBox
//
//  Created by Mac on 2017/9/21.
//  Copyright © 2017年 Actions. All rights reserved.
//

#import "ColorCollectionCell.h"
#import "UIImage+ColorSelect.h"
#import "UIView+ColorSelect.h"

@interface ColorCollectionCell ()

@property (nonatomic, strong) UIImageView *bgView;
@property (nonatomic, strong) UITapGestureRecognizer *tap;
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPress;
@end

@implementation ColorCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {

        [self addSubview:self.bgView];
//        [self addSubview:self.deleteBtn];
        [self.bgView addGestureRecognizer:self.tap];
        [self.bgView addGestureRecognizer:self.longPress];

    }
    return self;
}

- (UIImageView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIImageView alloc] initWithFrame:self.bounds];
        _bgView.userInteractionEnabled = YES;
    }
    return _bgView;
}

- (UIButton *)deleteBtn
{
    if (!_deleteBtn) {
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteBtn.frame = CGRectMake(self.width-40, 0, 40, 40);
        [_deleteBtn setBackgroundImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
        [_deleteBtn setBackgroundColor:[UIColor redColor]];
        [_deleteBtn addTarget:self action:@selector(cn_startai_deleteColor) forControlEvents:UIControlEventTouchUpInside];
        _deleteBtn.hidden = true;
    }
    return _deleteBtn;
}

- (UITapGestureRecognizer *)tap
{
    if (!_tap) {
        _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        _tap.numberOfTapsRequired = 1;
        _tap.numberOfTouchesRequired = 1;
    }
    return _tap;
}

- (UILongPressGestureRecognizer *)longPress
{
    if (!_longPress) {
        _longPress  = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        _longPress.minimumPressDuration = 0.5;
    }
    return _longPress;
}

- (void)longPress:(UILongPressGestureRecognizer *)longPress
{
    if (longPress.state == UIGestureRecognizerStateEnded) {
//        self.deleteBtn.hidden = false;
        [self cn_startai_deleteColor];
    }
}

- (void)tap:(UITapGestureRecognizer *)tap
{
    UIImageView *view = (UIImageView *)tap.view;
    CGPoint point = [tap locationInView:view];
    NSArray *arr = [view colorAtPixel:point];

    if (_isAddColor) {
        if (self.addColorHandler) {
            self.addColorHandler();
        }
    }else{
        if (self.updateColorHandler) {
            self.updateColorHandler(arr);
        }
    }
}
- (void)cn_startai_deleteColor
{
    if (self.deleteColorHandler) {
        self.deleteColorHandler(_row);
    }
}

- (void)setHexColor:(NSString *)hexColor
{
    self.deleteBtn.hidden = true;
    self.bgView.backgroundColor = [UIColor colorWithHexColorString:hexColor];
    
}

- (void)setRow:(NSInteger)row
{
    _row = row;
}

- (void)setIsAddColor:(BOOL)isAddColor
{
    _isAddColor = isAddColor;
    if (isAddColor) {
        self.bgView.image = [UIImage imageNamed:@"AddColor"];
        self.longPress.enabled = false;
    }else{
        self.bgView.image = nil;
        self.longPress.enabled = true;
    }
}

@end
