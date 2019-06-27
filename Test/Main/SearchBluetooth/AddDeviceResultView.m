//
//  AddDeviceResultView.m
//  Test
//
//  Created by Mac on 2017/12/20.
//  Copyright © 2017年 QiXing. All rights reserved.
//

#import "AddDeviceResultView.h"

@interface AddDeviceResultView ()

@property (nonatomic, strong) UIImageView *tipView;
@property (nonatomic, strong) UILabel *tipLabel;

@end

@implementation AddDeviceResultView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        [self cn_startai_initContentView];
    }
    return self;
}

- (void) cn_startai_initContentView
{
    self.backgroundColor = [UIColor colorWithHexColorString:@"333333"];
    [self addSubview:self.tipView];
    [self addSubview:self.tipLabel];
}

- (UIImageView *)tipView
{
    if (!_tipView) {
        _tipView = [[UIImageView alloc] initWithFrame:CGRectMake(60, 40, 40, 40)];
    }
    return _tipView;
}

- (UILabel *)tipLabel
{
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, self.width, 50)];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.textColor = [UIColor whiteColor];
        _tipLabel.numberOfLines = 0;
    }
    return _tipLabel;
}

- (void)setResult:(NSInteger)result
{
    if (result == 0) {
        _tipView.image = [UIImage imageNamed:@"ConncectSuccess"];
        _tipLabel.text = NSLocalizedString(@"AddSpeakerSuccess", nil);
    }else if (result == 1){
        _tipView.image = [UIImage imageNamed:@"ConnectedFail"];
        _tipLabel.text = NSLocalizedString(@"AddSpeakerFail", nil);
    }else{
        _tipView.image = [UIImage imageNamed:@"ConnectedFail"];
        _tipLabel.text = NSLocalizedString(@"SearchTimeout", nil);
    }
}

@end
