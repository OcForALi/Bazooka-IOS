//
//  BTSeqListCellEntity.h
//  BTMate
//
//  Created by Mac on 2017/8/18.
//  Copyright © 2017年 QiXing. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SeqFlashModel)
{
    GradientModel = 3,
    BreathModel = 4,
    FlashModel = 5
};

@interface BTSeqListCellEntity : NSObject<NSCoding>

@property (nonatomic, assign) NSInteger modelNum;
@property (nonatomic, assign) NSInteger serial;
@property (nonatomic, assign) CGFloat onms;
@property (nonatomic, assign) CGFloat offms;
@property (nonatomic, assign) NSInteger repeat;
@property (nonatomic, assign) CGFloat brigthness;
@property (nonatomic, copy) NSString *hexStr;
@property (nonatomic, copy) NSString *nextHexStr;
@property (nonatomic, assign) BOOL isGradientModel;
@property (nonatomic, copy) NSString *tableName;
@property (nonatomic, assign) BOOL isModelChanged;

@end
