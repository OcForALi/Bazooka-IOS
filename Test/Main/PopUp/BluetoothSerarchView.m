//
//  BluetoothSerarchView.m
//  Test
//
//  Created by Mac on 2017/11/2.
//  Copyright © 2017年 QiXing. All rights reserved.
//

#import "BluetoothSerarchView.h"

@interface BluetoothSerarchView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *cancleBtn;
@property (nonatomic, strong) UIButton *selectedBtn;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger index;

@end

@implementation BluetoothSerarchView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self cn_startai_initContentView];
        self.userInteractionEnabled = true;
        self.index = -1;
    }
    return self;
}

- (void)cn_startai_initContentView
{
//    [self addSubview:self.cancleBtn];
    [self addSubview:self.titleLabel];
//    [self addSubview:self.selectedBtn];
//    [self addSubview:self.line];
    [self addSubview:self.tableView];
}

-(UIButton *)cancleBtn
{
    if (!_cancleBtn) {
        _cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancleBtn.frame = CGRectMake(0, 0, 80, 40);
        [_cancleBtn setBackgroundColor:[UIColor whiteColor]];
        [_cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _cancleBtn.titleLabel.font = [UIFont systemFontOfSize:19];
        [_cancleBtn addTarget:self action:@selector(cancle) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancleBtn;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, 40)];
        _titleLabel.backgroundColor = [UIColor colorWithHexColorString:@"141010" withAlpha:0.7];
        _titleLabel.text = @"Select Your Speaker";
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:22];
        _titleLabel.layer.cornerRadius = 5;
    }
    return _titleLabel;
}

-(UIButton *)selectedBtn
{
    if (!_selectedBtn) {
        _selectedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectedBtn.backgroundColor = [UIColor whiteColor];
        _selectedBtn.frame = CGRectMake(self.titleLabel.right, 0, 80, 40);
        [_selectedBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_selectedBtn setTitle:@"确定" forState:UIControlStateNormal];
        _selectedBtn.titleLabel.font = [UIFont systemFontOfSize:19];
        [_selectedBtn addTarget:self action:@selector(selected) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectedBtn;
}


- (UIView *)line
{
    if (!_line) {
        _line = [[UIView alloc] initWithFrame:CGRectMake(0, 40, self.width, 1)];
        _line.backgroundColor = [UIColor colorWithHexColorString:@"dddddd" withAlpha:1];
    }
    return _line;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, self.width, self.height-40) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.bounces = false;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor colorWithHexColorString:@"141010" withAlpha:0.7];
    }
    return _tableView;
}


- (void)setDataArr:(NSMutableArray *)dataArr
{
    _dataArr = dataArr;
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIImageView *imgView = [cell viewWithTag:indexPath.row+10];
    imgView.image = [UIImage imageNamed:@"Connected"];
    
    self.index = indexPath.row;
    
    if (self.BluetoothSelectedPeripheral) {
        self.BluetoothSelectedPeripheral(_index);
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifiy = @"identify";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifiy];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifiy];
    }
    NSMutableDictionary *dic = self.dataArr[indexPath.row];
    cell.backgroundColor = [UIColor colorWithHexColorString:@"141010" withAlpha:0.7];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIImageView *imgView = [cell viewWithTag:indexPath.row+10];
    if (!imgView) {
     imgView  = [[UIImageView alloc] initWithFrame:CGRectMake(30, 10, 18, 25)];
     [cell addSubview:imgView];
    }
    
    imgView.image = [UIImage imageNamed:@"NotConnected"];
    imgView.tag = indexPath.row+10;
    
    UILabel *label = [cell viewWithTag:indexPath.row+1000];
    if (!label) {
        label = [[UILabel alloc] initWithFrame:CGRectMake(imgView.right+70, 10, 150, 30)];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.font = [UIFont systemFontOfSize:17];
//        [cell addSubview:label];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"                   %@",[dic objectForKey:@"name"]];
    
    CBPeripheral *per = [dic objectForKey:@"peripheral"];
    if ([self isPeripheralConnected:per]) {
        cell.imageView.image = [UIImage imageNamed:@"Connected"];
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}



-(BOOL)isPeripheralConnected:(CBPeripheral*)peripheral {
    if (peripheral == nil) {
        return NO;
    }
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        return peripheral.state == CBPeripheralStateConnected;
    } else {
#ifndef __IPHONE_7_0
        return peripheral.isConnected;
#endif
    }
    
    return NO;
}

- (void)cancle
{
    if (self.BluetoothSelectedPeripheral) {
        self.BluetoothSelectedPeripheral(-1);
    }
}

- (void)selected
{
    if (self.BluetoothSelectedPeripheral) {
        self.BluetoothSelectedPeripheral(_index);
    }
}

@end
