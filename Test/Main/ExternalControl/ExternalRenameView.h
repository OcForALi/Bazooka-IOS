//
//  ExternalRenameView.h
//  Test
//
//  Created by Mac on 2017/12/22.
//  Copyright © 2017年 QiXing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExternalRenameView : UIView

@property (nonatomic ,assign) BOOL isSeq;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) NSInteger serial;
@property (nonatomic, copy) void(^renameHandler)(NSInteger serail, NSString *name);

@end
