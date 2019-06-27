//
//  BTSaveSeqListBottom.m
//  BluetoothBox
//
//  Created by Mac on 2017/9/20.
//  Copyright © 2017年 Actions. All rights reserved.
//

#import "BTSaveSeqListBottom.h"

@interface BTSaveSeqListBottom ()

@property (nonatomic, strong) UIButton *transmissionBtn;
@property (nonatomic, strong) UIButton *updateBtn;  //进入音箱固件升级界面 商店版隐藏
@property (nonatomic, strong) UIButton *resetBtn;

@end

@implementation BTSaveSeqListBottom

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.transmissionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(30);
        make.centerY.equalTo(self);
        make.width.equalTo(@(60));
        make.height.equalTo(@(35));
    }];
    
//    [self.updateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self);
//        make.centerY.equalTo(self);
//        make.width.equalTo(@(100));
//        make.height.equalTo(@(35));
//    }];
    
    [self.resetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-20);
        make.centerY.equalTo(self);
        make.width.equalTo(@(60));
        make.height.equalTo(@(35));
    }];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithHexColorString:@"EE842D"];
        [self cn_startai_initContentView];
    }
    return self;
}

- (void)cn_startai_initContentView
{
    [self addSubview:self.transmissionBtn];
//    [self addSubview:self.updateBtn];
    [self addSubview:self.resetBtn];
}

- (UIButton *)transmissionBtn
{
    if (!_transmissionBtn) {
        _transmissionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_transmissionBtn setBackgroundImage:[UIImage imageNamed:@"sync"] forState:UIControlStateNormal];
        [_transmissionBtn setTitle:@"Sync." forState:UIControlStateNormal];
        [_transmissionBtn setTitleEdgeInsets:UIEdgeInsetsMake(-5, -5, 0, 0) ];
        _transmissionBtn.titleLabel.font = [UIFont fontWithName:@"Arial" size:12];
        [_transmissionBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_transmissionBtn addTarget:self action:@selector(transmissionAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _transmissionBtn;
}

- (UIButton *)updateBtn
{
    if (!_updateBtn) {
        _updateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_updateBtn setTitle:@"Update" forState:UIControlStateNormal];
//        [_transmissionBtn setTitleEdgeInsets:UIEdgeInsetsMake(-5, -5, 0, 0) ];
        _updateBtn.titleLabel.font = [UIFont fontWithName:@"Arial" size:12];
        [_updateBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_updateBtn addTarget:self action:@selector(update) forControlEvents:UIControlEventTouchUpInside];
    }
    return _updateBtn;
}

- (UIButton *)resetBtn
{
    if (!_resetBtn) {
        _resetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_resetBtn setBackgroundImage:[UIImage imageNamed:@"reset"] forState:UIControlStateNormal];
        _resetBtn.titleLabel.font = [UIFont fontWithName:@"Arial" size:12];
        [_resetBtn setTitle:@"Reset" forState:UIControlStateNormal];
        [_resetBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_resetBtn setTitleEdgeInsets:UIEdgeInsetsMake(-5, -5, 0, 0) ];
        [_resetBtn addTarget:self action:@selector(resetAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _resetBtn;
}

- (void)update
{
    if (self.updateHandler) {
        self.updateHandler();
    }
}

- (void)transmissionAction
{
    if (self.transHandler) {
        self.transHandler();
    }
}

- (void)resetAction
{
    if (self.restHandler) {
        self.restHandler();
    }
}

@end


