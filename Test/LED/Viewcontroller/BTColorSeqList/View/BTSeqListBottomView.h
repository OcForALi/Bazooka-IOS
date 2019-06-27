//
//  BTSeqListBottomView.h
//  BTMate
//
//  Created by Mac on 2017/8/21.
//  Copyright © 2017年 QiXing. All rights reserved.
//
//
#import <UIKit/UIKit.h>

@interface BTSeqListBottomView : UIView

@property (nonatomic, copy) void(^BTSeqListSaveHandler)();
@property (nonatomic, copy) void(^GotoSavedSeqListHandler)();

@end
