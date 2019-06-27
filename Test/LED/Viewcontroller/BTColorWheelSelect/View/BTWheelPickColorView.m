//
//  BTWheelPickColorView.m
//  Test
//
//  Created by Mac on 2017/12/21.
//  Copyright © 2017年 QiXing. All rights reserved.
//

#import "BTWheelPickColorView.h"
#import "MXSCycleScrollView.h"
@interface BTWheelPickColorView ()<UIPickerViewDelegate, UIPickerViewDataSource,MXSCycleScrollViewDelegate,MXSCycleScrollViewDatasource>

@property (nonatomic, strong) UIImageView *backGroundView;
@property (nonatomic, strong) UIPickerView *pickView;
@property (nonatomic, strong) MXSCycleScrollView *rScrollView;
@property (nonatomic, strong) MXSCycleScrollView *gScrollView;
@property (nonatomic, strong) MXSCycleScrollView *bScrollView;
@property (nonatomic, strong) UIImageView *rView;
@property (nonatomic, strong) UIImageView *gView;
@property (nonatomic, strong) UIImageView *bView;

@end

@implementation BTWheelPickColorView

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.pickView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.right.equalTo(self).offset(0);
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
    [self addSubview:self.backGroundView];
    [self addSubview:self.pickView];
    [self addSubview:self.rView];
    [self addSubview:self.gView];
    [self addSubview:self.bView];
//    [self setAfterScrollShowView:self.rScrollView andCurrentPage:1];
//    [self setAfterScrollShowView:self.gScrollView andCurrentPage:1];
//    [self setAfterScrollShowView:self.bScrollView andCurrentPage:1];
//    [self.rScrollView setCurrentSelectPage:255];
//    [self.gScrollView setCurrentSelectPage:255];
//    [self.bScrollView setCurrentSelectPage:255];
//    [self addSubview:self.rScrollView];
//    [self addSubview:self.gScrollView];
//    [self addSubview:self.bScrollView];

    self.backGroundView.top = (10/93.00)*self.height;

    [self.pickView selectRow:511 inComponent:0 animated:false];
    [self.pickView selectRow:511 inComponent:1 animated:false];
    [self.pickView selectRow:511 inComponent:2 animated:false];
}

- (UIImageView *)backGroundView
{
    if (!_backGroundView) {
        _backGroundView = [[UIImageView alloc] initWithFrame:self.bounds];
        _backGroundView.image = [UIImage imageNamed:@"ColorValueBackGround"];
    }
    return _backGroundView;
}

- (UIPickerView *)pickView
{
    if (!_pickView) {
        _pickView = [[UIPickerView alloc] initWithFrame:self.bounds];
        _pickView.showsSelectionIndicator = false;
        _pickView.dataSource = self;
        _pickView.delegate = self;
        _pickView.backgroundColor = [UIColor clearColor];
    }
    return _pickView;
}

- (UIImageView *)rView
{
    if (!_rView) {
        _rView = [[UIImageView alloc] initWithFrame:CGRectMake(((77/494.0)*self.width-27)/2.0,
                                                               (self.height -29)/2.0, 27, 29)];
        _rView.image = [UIImage imageNamed:@"R"];
        _rView.layer.masksToBounds = true;
    }
    return _rView;
}

- (UIImageView *)gView
{
    if (!_gView) {
        _gView = [[UIImageView alloc] initWithFrame:CGRectMake((161/494.0)*self.width+((64/494.0)*self.width-27)/2.0,
                                                               (self.height -29)/2.0, 27, 29)];
        _gView.image = [UIImage imageNamed:@"G"];
        _gView.layer.masksToBounds = true;
    }
    return _gView;
}

- (UIImageView *)bView
{
    if (!_bView) {
        _bView = [[UIImageView alloc] initWithFrame:CGRectMake((310/494.0)*self.width+((66/494.0)*self.width-27)/2.0,
                                                               (self.height -29)/2.0, 27, 29)];
        _bView.image = [UIImage imageNamed:@"B"];
        _bView.layer.masksToBounds = true;
    }
    return _bView;
}

- (MXSCycleScrollView *)rScrollView
{
    if (!_rScrollView) {
        _rScrollView = [[MXSCycleScrollView alloc] initWithFrame:CGRectMake((77/494.0)*self.width, 0, 93, self.height)];
        _rScrollView.delegate = self;
        _rScrollView.datasource = self;
    }
    return _rScrollView;
}

- (MXSCycleScrollView *)gScrollView
{
    if (!_gScrollView) {
        _gScrollView = [[MXSCycleScrollView alloc] initWithFrame:CGRectMake((226/494.0)*self.width, 0, 90, self.height)];
        _gScrollView.datasource = self;
        _gScrollView.delegate = self;
    }
    return _gScrollView;
}

- (MXSCycleScrollView *)bScrollView
{
    if (!_bScrollView) {
        _bScrollView = [[MXSCycleScrollView alloc] initWithFrame:CGRectMake((226/494.0)*self.width, 0, 93, self.height)];
        _bScrollView.datasource = self;
        _bScrollView.delegate = self;
    }
    return _bScrollView;
}


- (NSInteger)numberOfPages:(MXSCycleScrollView *)scrollView
{
    return 256;
}

- (UIView *)pageAtIndex:(NSInteger)index andScrollView:(MXSCycleScrollView *)scrollView
{
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, scrollView.bounds.size.width, scrollView.bounds.size.height/5)];
    lable.tag = index+1;
    lable.text = [NSString stringWithFormat:@"%ld",index];
    lable.font = [UIFont systemFontOfSize:12];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.backgroundColor = [UIColor clearColor];
    
    return lable;
}

- (void)setAfterScrollShowView:(MXSCycleScrollView*)scrollview  andCurrentPage:(NSInteger)pageNumber
{
    UILabel *oneLabel = [[(UILabel*)[[scrollview subviews] objectAtIndex:0] subviews] objectAtIndex:pageNumber];
    [oneLabel setFont:[UIFont systemFontOfSize:14]];
    [oneLabel setTextColor:RGBA(186.0, 186.0, 186.0, 1.0)];
    UILabel *twoLabel = [[(UILabel*)[[scrollview subviews] objectAtIndex:0] subviews] objectAtIndex:pageNumber+1];
    [twoLabel setFont:[UIFont systemFontOfSize:16]];
    [twoLabel setTextColor:RGBA(113.0, 113.0, 113.0, 1.0)];
    
    UILabel *currentLabel = [[(UILabel*)[[scrollview subviews] objectAtIndex:0] subviews] objectAtIndex:pageNumber+2];
    [currentLabel setFont:[UIFont systemFontOfSize:18]];
    [currentLabel setTextColor:[UIColor whiteColor]];
    
    UILabel *threeLabel = [[(UILabel*)[[scrollview subviews] objectAtIndex:0] subviews] objectAtIndex:pageNumber+3];
    [threeLabel setFont:[UIFont systemFontOfSize:16]];
    [threeLabel setTextColor:RGBA(113.0, 113.0, 113.0, 1.0)];
    UILabel *fourLabel = [[(UILabel*)[[scrollview subviews] objectAtIndex:0] subviews] objectAtIndex:pageNumber+4];
    [fourLabel setFont:[UIFont systemFontOfSize:14]];
    [fourLabel setTextColor:RGBA(186.0, 186.0, 186.0, 1.0)];
}

#pragma mark dataSource delegate
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return self.height;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return self.width/3.0-10;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 50, self.height)];
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor redColor];
    [label sizeToFit];
    if (IS_IPHONE_5_OR_LESS) {
        label.font = [UIFont boldSystemFontOfSize:13];
    }else{
        label.font = [UIFont boldSystemFontOfSize:18];
    }
    label.backgroundColor = [UIColor clearColor];
    NSMutableAttributedString *hintString=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%ld.0",row%256]];
    NSRange range1=[[hintString string]rangeOfString:@".0"];
    [hintString addAttribute:NSForegroundColorAttributeName value:[UIColor clearColor] range:range1];
    label.attributedText = hintString;
    label.textAlignment = NSTextAlignmentRight;

    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    BTWheelRGBEntity *entity = [[BTWheelRGBEntity alloc] init];
    entity.red = [self.pickView selectedRowInComponent:0]%256;
    entity.green = [self.pickView selectedRowInComponent:1]%256;
    entity.blue = [self.pickView selectedRowInComponent:2]%256;
    if (self.colorHandle) {
        self.colorHandle(entity);
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 256*10;
}

- (void)updateColorValueWithRed:(NSInteger)red Green:(NSInteger)green Blue:(NSInteger)blue
{
    [self.pickView selectRow:red+256*4 inComponent:0 animated:true];
    [self.pickView selectRow:green+256*4 inComponent:1 animated:true];
    [self.pickView selectRow:blue+256*4 inComponent:2 animated:true];
    
    [self layoutIfNeeded];
}

- (BTWheelRGBEntity *)rgb
{
    BTWheelRGBEntity *entity = [[BTWheelRGBEntity alloc] init];
    entity.red = [self.pickView selectedRowInComponent:0]%256;
    entity.green = [self.pickView selectedRowInComponent:1]%256;
    entity.blue = [self.pickView selectedRowInComponent:2]%256;
    return entity;
}
@end
