//
//  BTSaveSeqListCell.m
//  BTMate
//
//  Created by Mac on 2017/8/22.
//  Copyright © 2017年 QiXing. All rights reserved.
//

#import "BTSaveSeqListCell.h"
#import "UIFont+Adjust.h"

@interface BTSaveSeqListCell ()

@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, strong) UILabel *serialLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *upwardImg;
@property (nonatomic, strong) UIButton *downImg;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UIView *line;

@end

@implementation BTSaveSeqListCell


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.serialLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(20);
        make.centerY.equalTo(self);
        make.width.equalTo(@((SCREEN_WITDH-60)/5.0-20));
        make.height.equalTo(@(30));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.serialLabel.mas_right).offset(0);
        make.centerY.equalTo(self);
        make.width.equalTo(@((SCREEN_WITDH-60)/5.0));
        make.height.equalTo(@(30));
    }];
    [self.upwardImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right).offset(0);
        make.centerY.equalTo(self);
        make.width.equalTo(@((SCREEN_WITDH-60)/5.0));
        make.height.equalTo(@(20));
    }];
    [self.downImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.upwardImg.mas_right).offset(0);
        make.centerY.equalTo(self);
        make.width.equalTo(@((SCREEN_WITDH-60)/5.0));
        make.height.equalTo(@(20));
    }];
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.downImg.mas_right).offset(0);
        make.centerY.equalTo(self);
        make.width.equalTo(@((SCREEN_WITDH-60)/5.0+10));
        make.height.equalTo(@(20));
    }];
    
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.dateLabel.mas_right).offset(0);
        make.centerY.equalTo(self);
        make.width.height.equalTo(@(40));
    }];
    
//    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.top.equalTo(self).offset(0);
//        make.height.equalTo(@(1));
//    }];
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self cn_startai_initContentView];
    }
    return self;
}

- (void)cn_startai_initContentView
{
    [self addSubview:self.deleteBtn];
    [self addSubview:self.serialLabel];
    [self addSubview:self.titleLabel];
    [self addSubview:self.upwardImg];
    [self addSubview:self.downImg];
    [self addSubview:self.dateLabel];
//    [self addSubview:self.line];
}

- (UIButton *)deleteBtn
{
    if (!_deleteBtn) {
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteBtn setBackgroundImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
        [_deleteBtn addTarget:self action:@selector(deleteList) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteBtn;
}

- (UILabel *)serialLabel
{
    if (!_serialLabel) {
        _serialLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _serialLabel.text = @"#";
        _serialLabel.textColor = [UIColor colorWithHexColorString:@"333333"];
        _serialLabel.textAlignment = NSTextAlignmentLeft;
        _serialLabel.font = [UIFont systemFontOfSize:11];
        
    }
    return _serialLabel;
}
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.text = @"TITLE";
        _titleLabel.textColor = [UIColor colorWithHexColorString:@"333333"];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont fontWithName:@"Arial" fontSize:11];
        _titleLabel.userInteractionEnabled = true;
        
        UITapGestureRecognizer *longPress  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeSeq:)];
        longPress.numberOfTapsRequired = 1;

        [_titleLabel addGestureRecognizer:longPress];

    }
    return _titleLabel;
}

- (UIButton *)upwardImg
{
    if (!_upwardImg) {
        _upwardImg = [UIButton buttonWithType:UIButtonTypeCustom];
        [_upwardImg setImage:[UIImage imageNamed:@"up"] forState:UIControlStateNormal];
//        [_upwardImg setImage:[UIImage imageNamed:@"upHigh"] forState:UIControlStateHighlighted];
        [_upwardImg addTarget:self action:@selector(upupup) forControlEvents:UIControlEventTouchUpInside];
    }
    return _upwardImg;
}

- (UIButton *)downImg
{
    if (!_downImg) {
        _downImg = [UIButton buttonWithType:UIButtonTypeCustom];
        [_downImg setImage:[UIImage imageNamed:@"down"] forState:UIControlStateNormal];
//        [_downImg setImage:[UIImage imageNamed:@"downhigh"] forState:UIControlStateHighlighted];
        [_downImg addTarget:self action:@selector(downdown) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _downImg;
}

- (UILabel *)dateLabel
{
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _dateLabel.text = @"DATE";
        _dateLabel.textColor = [UIColor colorWithHexColorString:@"333333"];
        _dateLabel.textAlignment = NSTextAlignmentCenter;
        _dateLabel.font = [UIFont fontWithName:@"Arial" size:11];
    }
    return _dateLabel;
}

- (UIView *)line
{
    if (!_line) {
        _line = [[UIView alloc] initWithFrame:CGRectZero];
        _line.backgroundColor = [UIColor colorWithHexColorString:@"333333"];
        _line.hidden = true;
    }
    return _line;
}

- (void)upupup
{
    NSInteger row = [[self.serialLabel.text substringToIndex:self.serialLabel.text.length-1] integerValue];
    row = row -1;
    if (row >= self.lineIndex) {
        row = row + 1;
    }
    if (self.BTSaveSeqListCellUpHandler) {
        self.BTSaveSeqListCellUpHandler((row));
    }
}

- (void)downdown
{
    NSInteger row = [[self.serialLabel.text substringToIndex:self.serialLabel.text.length-1] integerValue];
    row = row - 1;
    if (row >= self.lineIndex) {
        row = row + 1;
    }
    if (self.BTSaveSeqListCellDownHandler) {
        self.BTSaveSeqListCellDownHandler(row);
    }
}

- (void)deleteList
{
    NSInteger row = [[self.serialLabel.text substringToIndex:self.serialLabel.text.length-1] integerValue];
    row = row-1;
    if (row >= self.lineIndex) {
        row = row + 1;
    }
    if (self.BTSaveSeqListCellDeleteHandler) {
        self.BTSaveSeqListCellDeleteHandler(row);
    }
}

- (void)changeSeq:(UITapGestureRecognizer *)longPress
{
    NSInteger row = [[self.serialLabel.text substringToIndex:self.serialLabel.text.length-1] integerValue];
    row = row-1;
    if (row >= self.lineIndex) {
        row = row + 1;
    }
    @weakify(self);
    if (self.BTSaveSeqListCellChangeHandler) {
        self.BTSaveSeqListCellChangeHandler(weak_self.titleLabel.text,row);
    }
}

- (void)setTEntity:(BTSaveSeqListEntity *)tEntity
{
    self.serialLabel.text = [NSString stringWithFormat:@"%ld.",tEntity.serial+1];
    self.titleLabel.text = tEntity.title;
    self.dateLabel.text = tEntity.date;
    self.titleLabel.textColor = [UIColor colorWithHexColorString:@"333333"];
    if ([tEntity.title isEqualToString:@"DOME"]) {
        self.deleteBtn.hidden = true;
        self.upwardImg.hidden = true;
        self.downImg.hidden = true;
//        self.titleLabel.userInteractionEnabled = false;
    }else{
        self.deleteBtn.hidden = false;
        self.upwardImg.hidden = false;
        self.downImg.hidden = false;
        self.titleLabel.userInteractionEnabled = true;
    }
//    if (tEntity.serial == 15) {
//        self.line.hidden = false;
//    }else{
//        self.line.hidden = true;
//    }
}

- (void)setTitleColor:(NSString *)titleColor
{
    self.titleLabel.textColor = [UIColor redColor];
}

@end
