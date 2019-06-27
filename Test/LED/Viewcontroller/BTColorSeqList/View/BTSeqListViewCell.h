//
//  BTSeqListViewCell.h
//  BTMate
//
//  Created by Mac on 2017/8/18.
//  Copyright © 2017年 QiXing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTSeqListCellEntity.h"

typedef void(^BTSeqListCellCopyHandler)(NSInteger row);

@interface BTSeqListViewCell : UITableViewCell

@property (nonatomic, assign) BOOL canClickFirstColor;
@property (nonatomic, copy) NSString *seqTitle;
@property (nonatomic, assign) BOOL isGradientModel;
@property (nonatomic, assign) BOOL hideDelte;
@property (nonatomic, copy) void(^BTSeqListSerialDeleteHandler)(NSInteger row);
@property (nonatomic, copy) void(^BTPickColorHandler)(NSInteger row);
@property (nonatomic, copy) void(^BTPickNextColorHandler)(NSInteger row);
@property (nonatomic, copy) void(^BTSeqListViewCellChangeEntity)(BTSeqListCellEntity *entity);
@property (nonatomic, copy) BTSeqListCellCopyHandler copyHandler;
@property (nonatomic, copy) void(^CancleEditingHandler)();

- (void)setValueForBTSeqListViewCell:(BTSeqListCellEntity *)tEntity;


@end
