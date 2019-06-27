//
//  BTSeqListSerialView.h
//  BTMate
//
//  Created by Mac on 2017/8/18.
//  Copyright © 2017年 QiXing. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BTSeqListSerialCopyHandler)(NSInteger row);
typedef void(^BTSeqListSerialDeleteHandler)(NSInteger row);

@interface BTSeqListSerialView : UIView

@property (nonatomic, copy) BTSeqListSerialCopyHandler copyHandler;
@property (nonatomic, copy) BTSeqListSerialDeleteHandler deleteHandler;
@property (nonatomic, assign) BOOL hideDelte;

- (void)setValueWithSerial:(NSInteger)serial;

@end
