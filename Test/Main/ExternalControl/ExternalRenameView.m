//
//  ExternalRenameView.m
//  Test
//
//  Created by Mac on 2017/12/22.
//  Copyright © 2017年 QiXing. All rights reserved.
//

#import "ExternalRenameView.h"

#define ALPHANUM @"ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"

@interface ExternalRenameView ()<UITextFieldDelegate>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextField *nameTextfield;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UIButton *cancleBtn;
@property (nonatomic, strong) UIButton *okBtn;

@end

@implementation ExternalRenameView

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.mas_top).offset(10);
        [self.titleLabel sizeToFit];
    }];
    
    [self.nameTextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(20);
        make.width.equalTo(@(self.width - 60));
        make.height.equalTo(@(40));
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(30);
        make.top.equalTo(self.nameTextfield.mas_bottom).offset(0);
        make.width.equalTo(@(self.width-60));
        make.height.equalTo(@(1));
    }];
    
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(30);
        make.top.equalTo(self.nameTextfield.mas_bottom).offset(15);
        make.width.equalTo(@(self.width - 60));
        [self.descLabel sizeToFit];
    }];
    
    [self.okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self).offset(-15);
        make.width.equalTo(@(40));
        make.height.equalTo(@(30));
    }];
    
    [self.cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-15);
        make.right.equalTo(self.okBtn.mas_left).offset(-10);
        make.width.equalTo(@(80));
        make.height.equalTo(@(30));
    }];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        [self cn_startai_initContentView];
    }
    return self;
}

- (void)cn_startai_initContentView
{
    [self addSubview:self.titleLabel];
    [self addSubview:self.nameTextfield];
    [self addSubview:self.line];
    [self addSubview:self.descLabel];
    [self addSubview:self.cancleBtn];
    [self addSubview:self.okBtn];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    tap.numberOfTapsRequired = 1;
    [self addGestureRecognizer:tap];
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = NSLocalizedString(@"Rename", nil);
        _titleLabel.textColor = [UIColor colorWithHexColorString:@"333333"];
        _titleLabel.font = [UIFont boldSystemFontOfSize:19];
    }
    return _titleLabel;
}

- (UITextField *)nameTextfield
{
    if (!_nameTextfield) {
        _nameTextfield = [[UITextField alloc] init];
        _nameTextfield.textColor = [UIColor colorWithHexColorString:@"666666"];
        _nameTextfield.font = [UIFont systemFontOfSize:17];
        _nameTextfield.placeholder = @"";
        _nameTextfield.keyboardType = UIKeyboardTypeASCIICapable;
        _nameTextfield.delegate = self;
        _nameTextfield.clearButtonMode = UITextFieldViewModeWhileEditing;
        [_nameTextfield addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
    }
    return _nameTextfield;
}

-(UIView *)line
{
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = [UIColor colorWithHexColorString:@"333333"];
    }
    return _line;
}

- (UILabel *)descLabel
{
    if (!_descLabel) {
        _descLabel = [[UILabel alloc] init];
        _descLabel.textColor = [UIColor colorWithHexColorString:@"999999"];
        _descLabel.font = [UIFont systemFontOfSize:12];
        _descLabel.text = NSLocalizedString(@"SwitchRenameTip", nil);
        _descLabel.numberOfLines = 0;
    }
    return _descLabel;
}

- (UIButton *)cancleBtn
{
    if (!_cancleBtn) {
        _cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancleBtn setTitle:@"Cancel" forState:UIControlStateNormal];
        [_cancleBtn setTitleColor:[UIColor colorWithHexColorString:@"333333"] forState:UIControlStateNormal];
//        _cancleBtn.layer.borderColor = [UIColor colorWithHexColorString:@"dddddd"].CGColor;
//        _cancleBtn.layer.borderWidth = 0.5;
        [_cancleBtn addTarget:self action:@selector(cancle:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancleBtn;
}

- (UIButton *)okBtn
{
    if (!_okBtn) {
        _okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_okBtn setTitle:@"Yes" forState:UIControlStateNormal];
        [_okBtn setTitleColor:[UIColor colorWithHexColorString:@"0724FB"] forState:UIControlStateNormal];
//        _okBtn.layer.borderWidth = 0.5;
//        _okBtn.layer.borderColor = [UIColor colorWithHexColorString:@"dddddd"].CGColor;
        [_okBtn addTarget:self action:@selector(sure:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _okBtn;
}

- (void)textChanged:(UITextField *)textField
{
    if (textField.text.length>10 && !_isSeq) {
        self.nameTextfield.text = [textField.text substringToIndex:10];
    }else if (textField.text.length > 8 && _isSeq){
        self.nameTextfield.text = [textField.text substringToIndex:8];
    }
}

- (void)cancle:(UIButton *)btn
{
    if (self.renameHandler) {
        self.renameHandler(-1, @"");
    }
}

- (void)setTitle:(NSString *)title
{
    self.nameTextfield.text = title;
}

- (void)tap
{
    
}
- (void)setIsSeq:(BOOL)isSeq
{
    _isSeq = isSeq;
    self.descLabel.text = NSLocalizedString(@"SeqRenameTip", nil);
}

- (void)sure:(UIButton *)btn
{
    if ([self isIncludeSpecialCharact:self.nameTextfield.text] ||
        (self.nameTextfield.text.length < 2 && _isSeq) ) {
        self.descLabel.textColor = [UIColor redColor];
        return;
    }
    self.descLabel.textColor = [UIColor colorWithHexColorString:@"999999"];
    @weakify(self);
    if (!_isSeq) {
        NSString *img = [NSString stringWithFormat:@"SW%ld",self.serial];
        if (self.nameTextfield.text.length) {
            [[NSUserDefaults standardUserDefaults] setObject:self.nameTextfield.text forKey:img];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    if (self.renameHandler) {
        self.renameHandler(_serial, weak_self.nameTextfield.text);
    }
}

-(BOOL)isIncludeSpecialCharact: (NSString *)str {
    //***需要过滤的特殊字符：~￥#&*<>《》()[]{}【】^@/￡¤￥|§¨「」『』￠￢￣~@#￥&*（）——+|《》$_€。
    NSRange urgentRange = [str rangeOfCharacterFromSet: [NSCharacterSet characterSetWithCharactersInString: @"~￥#&*<>《》()[]{}【】^@/￡¤￥|§¨‘「」『』￠￢￣~@#￥&*（）——+|《》$_€ -:;,。.?!""“”|、+=%"]];
    if (urgentRange.location == NSNotFound)
    {
        return NO;
    }
    return YES;
}

@end
