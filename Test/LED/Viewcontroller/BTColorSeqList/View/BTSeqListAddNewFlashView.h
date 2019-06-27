//
//  BTSeqListAddNewFlashView.h
//  Test
//
//  Created by Mac on 2017/9/22.
//  Copyright © 2017年 QiXing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTSeqListCellEntity.h"

@interface BTSeqListAddNewFlashView : UIView

@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, copy) void(^cancleOrAddFlash)(BTSeqListCellEntity *tEntity);

@end
