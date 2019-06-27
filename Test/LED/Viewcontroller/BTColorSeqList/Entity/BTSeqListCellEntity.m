//
//  BTSeqListCellEntity.m
//  BTMate
//
//  Created by Mac on 2017/8/18.
//  Copyright © 2017年 QiXing. All rights reserved.
//

#import "BTSeqListCellEntity.h"

@implementation BTSeqListCellEntity

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInteger:self.modelNum forKey:@"modelNum"];
    [aCoder encodeInteger:self.serial forKey:@"serial"];
    [aCoder encodeObject:self.hexStr forKey:@"hexStr"];
    [aCoder encodeFloat:self.onms forKey:@"onms"];
    [aCoder encodeFloat:self.offms forKey:@"offms"];
    [aCoder encodeInteger:self.repeat forKey:@"repeat"];
    [aCoder encodeFloat:self.brigthness forKey:@"brigthness"];
    [aCoder encodeObject:self.tableName forKey:@"tableName"];
    [aCoder encodeObject:self.nextHexStr forKey:@"nextHexStr"];
    [aCoder encodeBool:self.isGradientModel forKey:@"isGradientModel"];
    [aCoder encodeBool:self.isModelChanged forKey:@"isModelChanged"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.modelNum = [aDecoder decodeIntegerForKey:@"modelNum"];
        self.serial = [aDecoder decodeIntegerForKey:@"serial"];
        self.hexStr = [aDecoder decodeObjectForKey:@"hexStr"];
        self.onms = [aDecoder decodeFloatForKey:@"onms"];
        self.offms = [aDecoder decodeFloatForKey:@"offms"];
        self.repeat = [aDecoder decodeIntegerForKey:@"repeat"];
        self.brigthness = [aDecoder decodeFloatForKey:@"brigthness"];
        self.tableName = [aDecoder decodeObjectForKey:@"tableName"];
        self.nextHexStr = [aDecoder decodeObjectForKey:@"nextHexStr"];
        self.isGradientModel = [aDecoder decodeBoolForKey:@"isGradientModel"];
        self.isModelChanged = [aDecoder decodeBoolForKey:@"isModelChanged"];
    }
    return self;
}

@end
