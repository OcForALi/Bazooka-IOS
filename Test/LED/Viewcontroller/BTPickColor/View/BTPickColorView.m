//
//  BTPickColorView.m
//  Test
//
//  Created by Mac on 2017/12/25.
//  Copyright © 2017年 QiXing. All rights reserved.
//

#import "BTPickColorView.h"
#import "BTWheelPickColorView.h"
#import "UIView+ColorSelect.h"

@interface BTPickColorView ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) BTWheelPickColorView *pickView;
@property (nonatomic, strong) UIImageView *sourceImgView;
@property (nonatomic, strong) UIImageView *yuanxinView;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, strong) UIButton *addBtn;

@end

@implementation BTPickColorView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initContenttView];
    }
    return self;
}

- (void)initContenttView
{
    [self addSubview:self.bgView];
    [self addSubview:self.pickView];
    [self addSubview:self.sourceImgView];
    [self addSubview:self.yuanxinView];
    [self.sourceImgView addGestureRecognizer:self.tapGesture];
    [self addSubview:self.addBtn];
}

- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:self.bounds ];
        _bgView.backgroundColor = [UIColor colorWithHexColorString:@"dddddd" withAlpha:0.7];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideSelf)];
        tap.numberOfTapsRequired = 1;
        [_bgView addGestureRecognizer:tap];
    }
    return _bgView;
}

- (BTWheelPickColorView *)pickView
{
    @weakify(self);
    if (!_pickView) {
        _pickView = [[BTWheelPickColorView alloc] initWithFrame:CGRectMake(40, 40, self.width-80, (self.width-80)*(93/494.0))];
        _pickView.colorHandle = ^(BTWheelRGBEntity *rgb) {
            if (weak_self.getColorValueHandler) {
                weak_self.getColorValueHandler(rgb);
            }
        };
    }
    return _pickView;
}

- (UIImageView *)sourceImgView
{
    if (!_sourceImgView) {
        _sourceImgView = [[UIImageView alloc] initWithFrame:CGRectMake((self.width-(SCREEN_WITDH-80))/2.0, self.pickView.bottom +  33, (SCREEN_WITDH-80), (SCREEN_WITDH-80))];
        _sourceImgView.image = [UIImage imageNamed:@"pickerColorWheel"];
        _sourceImgView.layer.borderWidth = 0;
        _sourceImgView.userInteractionEnabled = true;
        _sourceImgView.layer.masksToBounds = true;
        _sourceImgView.layer.cornerRadius = (SCREEN_WITDH-80)/2.0;
    }
    return _sourceImgView;
}

- (UIImageView *)yuanxinView
{
    if (!_yuanxinView) {
        _yuanxinView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 41, 41)];
        _yuanxinView.image = [UIImage imageNamed:@"yuanxin"];
        _yuanxinView.center = self.sourceImgView.center;
    }
    return _yuanxinView;
}

- (UITapGestureRecognizer *)tapGesture
{
    if(!_tapGesture){
        _tapGesture =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectColorAction:)];
        _tapGesture.numberOfTapsRequired = 1;
        _tapGesture.numberOfTouchesRequired = 1;
    }
    return _tapGesture;
}

- (UIButton *)addBtn
{
    if (!_addBtn) {
        _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _addBtn.frame = CGRectMake((self.width - 82)/2.0, self.height - 67, 82, 57);
        [_addBtn setBackgroundImage:[UIImage imageNamed:@"AddNewColor"] forState:UIControlStateNormal];
        [_addBtn addTarget:self action:@selector(addColor) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addBtn;
}

 - (void)hideSelf
{
    self.hidden = true;
}

//选择颜色
-(void)selectColorAction:(UITapGestureRecognizer *)sender{
    
    CGPoint tempPoint = [sender locationInView:self];
    if ([self point:tempPoint inCircleRect:self.sourceImgView.frame]) {
        [self finishedAction:tempPoint end:true];
        
    }
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = [touches anyObject];
    CGPoint tempPoint = [touch locationInView:self];
    [self finishedAction:tempPoint end:false];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint tempPoint = [touch locationInView:self];
    [self finishedAction:tempPoint end:true];
    
}

- (void)finishedAction:(CGPoint)point end:(BOOL)end
{
    if ([self point:point inCircleRect:CGRectMake(self.sourceImgView.left+20,
                                                  self.sourceImgView.top+20,
                                                  self.sourceImgView.width-40,
                                                  self.sourceImgView.height-40)] ) {
        
        self.yuanxinView.center = point;
        
    }else{
        return;
    }
    
    NSArray *colorArr = [self colorAtPixel:self.yuanxinView.center];
    
    [self.pickView updateColorValueWithRed:[colorArr[0] integerValue]
                                     Green:[colorArr[1] integerValue]
                                      Blue:[colorArr[2] integerValue]];
    
    BTWheelRGBEntity *rgb = [[BTWheelRGBEntity alloc] init];
    rgb.red = [colorArr[0] integerValue];
    rgb.green = [colorArr[1] integerValue];
    rgb.blue = [colorArr[2] integerValue];
    if (self.getColorValueHandler) {
        self.getColorValueHandler(rgb);
    }
    
}

- (BOOL)point:(CGPoint)point inCircleRect:(CGRect)rect {
    CGFloat radius = rect.size.width/2.0;
    CGPoint center = CGPointMake(rect.origin.x + radius, rect.origin.y + radius);
    double dx = fabs(point.x - center.x);
    double dy = fabs(point.y - center.y);
    double dis = hypot(dx, dy);
    return dis <= radius;
}

- (void)addColor
{
    @weakify(self);
    if (self.addColorHandler) {
        self.addColorHandler(weak_self.pickView.rgb);
    }
}




@end
