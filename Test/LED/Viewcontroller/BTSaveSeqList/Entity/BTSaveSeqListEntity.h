//
//  BTSaveSeqListEntity.h
//  BTMate
//
//  Created by Mac on 2017/8/23.
//  Copyright © 2017年 QiXing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTSaveSeqListEntity : NSObject

@property (nonatomic, assign) NSInteger serial;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *date;
@property (nonatomic, copy) NSString *createData;
@end
