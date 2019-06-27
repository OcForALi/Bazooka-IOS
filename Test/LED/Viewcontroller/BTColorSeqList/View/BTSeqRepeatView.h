//
//  BTWheelRepeatView.h
//  Test
//
//  Created by Mac on 2017/12/18.
//  Copyright © 2017年 QiXing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BTSeqRepeatView : UIView

@property (nonatomic, assign) NSInteger repeat;
@property (nonatomic, copy) void(^BTSeqReapeatHandler)(NSInteger repeat);

@end
