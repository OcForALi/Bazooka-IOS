////
////  BTSeqListBottomView.m
////  BTMate
////
////  Created by Mac on 2017/8/21.
////  Copyright © 2017年 QiXing. All rights reserved.
////
//
#import "BTSeqListBottomView.h"

static const CGFloat kLeftHorzontal = 15;
static const CGFloat kVertical = 15;

@interface BTSeqListBottomView ()

@property (nonatomic, strong) UIButton *saveBtn;
@property (nonatomic, strong) UIButton *seqBtn;
@end

@implementation BTSeqListBottomView

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(24);
        make.centerY.equalTo(self);
        make.width.equalTo(@(60));
        make.height.equalTo(@(35));
    }];
    
    [self.seqBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-30);
        make.centerY.equalTo(self);
        make.width.equalTo(@(60));
        make.height.equalTo(@(35));
    }];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithHexColorString:@"8C8C8C"];
        [self cn_startai_initContentView];
    }
    return self;
}

- (void)cn_startai_initContentView
{

    [self addSubview:self.saveBtn];
    [self addSubview:self.seqBtn];
}

- (UIButton *)saveBtn
{
    if (!_saveBtn) {
        _saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_saveBtn setBackgroundImage:[UIImage imageNamed:@"save"] forState:UIControlStateNormal];
        [_saveBtn setTitle:@"Save" forState:UIControlStateNormal];
        [_saveBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_saveBtn setTitleEdgeInsets:UIEdgeInsetsMake(-5, -5, 0, 0) ];
        _saveBtn.titleLabel.font = [UIFont fontWithName:@"Arial" size:12];

        [_saveBtn addTarget:self action:@selector(saveAsNewSeq) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveBtn;
}

- (UIButton *)seqBtn
{
    if (!_seqBtn) {
        _seqBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_seqBtn setBackgroundImage:[UIImage imageNamed:@"list"] forState:UIControlStateNormal];
        [_seqBtn setTitle:@"List" forState:UIControlStateNormal];
        [_seqBtn setTitleEdgeInsets:UIEdgeInsetsMake(-5, -5, 0, 0) ];
        [_seqBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _seqBtn.titleLabel.font = [UIFont fontWithName:@"Arial" size:12];
        [_seqBtn addTarget:self action:@selector(goToSeqList) forControlEvents:UIControlEventTouchUpInside];
    }
    return _seqBtn;
}

- (void)goToSeqList
{
    if (self.GotoSavedSeqListHandler) {
        self.GotoSavedSeqListHandler();
    }
}

- (void)saveAsNewSeq
{
    if (self.BTSeqListSaveHandler) {
        self.BTSeqListSaveHandler();
    }
}


@end
