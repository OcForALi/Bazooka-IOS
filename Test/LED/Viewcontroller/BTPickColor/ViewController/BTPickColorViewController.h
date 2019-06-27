//
//  BTPickColorViewController.h
//  BTMate
//
//  Created by Mac on 2017/8/21.
//  Copyright © 2017年 QiXing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface BTPickColorViewController : UIViewController

@property (nonatomic, copy) NSString *colorHex;
@property (nonatomic, assign) NSInteger row;
@property (nonatomic, copy) void(^BTPickColorReturn)(NSString *color, NSInteger row);

@end
