//
//  BaseNavView.h
//  BluetoothBox
//
//  Created by Mac on 2017/9/21.
//  Copyright © 2017年 Actions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseNavView : UIView

@property (nonatomic, strong) UIImage *leftImg;
@property (nonatomic, strong) UIImage *rightImg;
@property (nonatomic, strong) UIImage *logo;

@property (nonatomic, assign) BOOL hideLine;

@property (nonatomic, copy)void(^leftHandler)();
@property (nonatomic, copy)void(^rightHandler)();

@end
