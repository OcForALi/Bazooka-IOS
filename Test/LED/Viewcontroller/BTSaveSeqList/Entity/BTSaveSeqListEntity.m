//
//  BTSaveSeqListEntity.m
//  BTMate
//
//  Created by Mac on 2017/8/23.
//  Copyright © 2017年 QiXing. All rights reserved.
//

#import "BTSaveSeqListEntity.h"

@implementation BTSaveSeqListEntity

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInteger:self.serial forKey:@"serial"];
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.date forKey:@"date"];
    [aCoder encodeObject:self.createData forKey:@"createData"];
}


- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.title = [aDecoder decodeObjectForKey:@"title"];
        self.serial = [aDecoder decodeIntegerForKey:@"serial"];
        self.date = [aDecoder decodeObjectForKey:@"date"];
        self.createData = [aDecoder decodeObjectForKey:@"createData"];
    }
    return self;
}
@end
