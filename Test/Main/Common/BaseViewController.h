//
//  BaseViewController.h
//  BluetoothBox
//
//  Created by Mac on 2017/9/14.
//  Copyright © 2017年 Actions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController
@property (nonatomic, strong) UIImageView *signView;
@property (nonatomic, strong) UIImageView *navBg;
@property (nonatomic, strong) UIImageView *backGroundView;
@property (nonatomic, strong) UIImageView *logoView;
@property (nonatomic, strong) UIImage *leftImg;
@property (nonatomic, strong) UIImage *rightImg;
@property (nonatomic, strong) UIImage *logo;
@property (nonatomic, strong) UISlider *volumeSlider;

- (void)leftAction;

- (void)rightAction;

- (void)cn_startai_showToastWithTitle:(NSString *)title;

//- (UIWindow *)lastWindow;
@end
