//
//  BTSaveSeqListCell.h
//  BTMate
//
//  Created by Mac on 2017/8/22.
//  Copyright © 2017年 QiXing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTSaveSeqListEntity.h"

@interface BTSaveSeqListCell : UITableViewCell

@property (nonatomic, strong) BTSaveSeqListEntity *tEntity;

@property (nonatomic, assign) NSInteger lineIndex;     //发送闪法的截止线所在位置
@property (nonatomic, copy) NSString *titleColor;
@property (nonatomic, copy) void (^BTSaveSeqListCellDownHandler)(NSInteger row);
@property (nonatomic, copy) void (^BTSaveSeqListCellUpHandler)(NSInteger row);
@property (nonatomic, copy) void (^BTSaveSeqListCellDeleteHandler)(NSInteger row);
@property (nonatomic, copy) void (^BTSaveSeqListCellChangeHandler)(NSString *title, NSInteger row);
@end
