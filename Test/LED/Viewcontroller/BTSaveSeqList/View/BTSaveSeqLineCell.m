//
//  BTSaveSeqLineCell.m
//  Test
//
//  Created by Mac on 2017/12/19.
//  Copyright © 2017年 QiXing. All rights reserved.
//

#import "BTSaveSeqLineCell.h"

@interface BTSaveSeqLineCell ()

@property (nonatomic, strong) UIView *line;

@end

@implementation BTSaveSeqLineCell

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.mas_left).offset(40);
        make.right.equalTo(self.mas_right).offset(-40);
        make.height.equalTo(@(1));
    }];
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
    [self addSubview:self.line];
}

- (UIView *)line
{
    if (!_line) {
        _line = [[UIView alloc] initWithFrame:CGRectZero];
        _line.backgroundColor = [UIColor colorWithHexColorString:@"333333"];
    }
    return _line;
}

- (void)setLineColor:(NSString *)lineColor
{
    self.line.backgroundColor = [UIColor colorWithHexColorString:lineColor];
}

@end
