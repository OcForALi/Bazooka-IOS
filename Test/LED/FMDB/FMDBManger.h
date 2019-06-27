//
//  FMDBManger.h
//  BluetoothSpeaker
//
//  Created by Mac on 2017/7/27.
//  Copyright © 2017年 QiXing. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "FMDBEntity.h"
#import "BTSeqListCellEntity.h"

@interface FMDBManger : NSObject


+ (FMDBManger *)shareManager;

//

- (BOOL)isExistTableWithTitle:(NSString *)title;

//包含这条数据的话 我们显示取消收藏 没有这条数据的话 我们应该收藏
- (BOOL)isExistsDataWithModel:(BTSeqListCellEntity *)entity;

//收藏 插入一条数据
- (BOOL)insertDataWithModel:(BTSeqListCellEntity *)entity;

//删除数据
- (BOOL)deleteDataWithModel:(BTSeqListCellEntity *)entity;

//更改一条数据
- (BOOL)changeDataWithModel:(BTSeqListCellEntity *)entity newStr:(NSString *)str;

//返回所有数据
- (NSArray *)allDataWithTable:(NSString *)table;

//删除表单
- (BOOL)DeleteTableWithTableName:(NSString *)tableName;

@end
