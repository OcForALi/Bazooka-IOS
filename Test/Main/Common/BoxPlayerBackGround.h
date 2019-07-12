//
//  BoxPlayerBackGround.h
//  BluetoothBox
//
//  Created by Mac on 2017/9/18.
//  Copyright © 2017年 Actions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BoxPlayerBackGround : UIView

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, assign) BOOL hidePage;

- (void)setPoint:(CGPoint *)point;

@end
