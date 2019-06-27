//
//  FMDBEntity.h
//  BluetoothSpeaker
//
//  Created by Mac on 2017/7/27.
//  Copyright © 2017年 QiXing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMDBEntity : NSObject

@property (nonatomic, copy) NSString *seqName;
//@property (nonatomic, copy) NSString *keys;
@property (nonatomic, copy) NSString *serial;
@property (nonatomic, copy) NSString *red;
@property (nonatomic, copy) NSString *green;
@property (nonatomic, copy) NSString *blue;
@property (nonatomic, copy) NSString *onms;
@property (nonatomic, copy) NSString *offms;
@property (nonatomic, copy) NSString *brigthness;
@property (nonatomic, copy) NSString *repeat;

@property (nonatomic, copy) NSString *tableName;

@end
