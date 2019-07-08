//
//  PopView.h
//  Test
//
//  Created by Mac on 2017/10/13.
//  Copyright © 2017年 QiXing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopView : UIView


@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *leftImg;
@property (nonatomic, copy) NSString *rightImg;
@property (nonatomic, copy) NSString *leftText;
@property (nonatomic, copy) NSString *rightText;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic ,assign) NSInteger single;

@property (nonatomic, copy) void(^leftHandler)();
@property (nonatomic, copy) void(^rightHandler)();

@end
