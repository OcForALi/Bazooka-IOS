//
//  QXNavigationController.m
//  BluetoothSpeaker
//
//  Created by Mac on 2017/7/24.
//  Copyright © 2017年 QiXing. All rights reserved.
//

#import "QXNavigationController.h"
#import "AppDelegate.h"
@interface QXNavigationController ()<UIGestureRecognizerDelegate>
{
    AppDelegate *appDelegate;
}
@end

@implementation QXNavigationController

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationBar.translucent = NO;
//    if (appDelegate.player.player.rate == 1) {
//        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
//    }else{
//        [[AVAudioSession sharedInstance] setActive:true error:nil];
//    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    appDelegate = [UIApplication sharedApplication].delegate;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.9999) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (self.navigationController.viewControllers.count>1) {
        return YES;
    }else{
        return NO;
    }
}

@end
