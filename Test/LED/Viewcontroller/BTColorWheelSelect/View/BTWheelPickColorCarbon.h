//
//  BTWheelPickColorCarbon.h
//  Test
//
//  Created by Mac on 2019/3/18.
//  Copyright © 2019 QiXing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BTWheelPickColorCarbon : UIView

@property (nonatomic, copy) void (^getColorHanlder)(NSArray *colorArr);

- (void)setReset;

@end

NS_ASSUME_NONNULL_END
