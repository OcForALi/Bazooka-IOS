//
//  FMDBManger.m
//  BluetoothSpeaker
//
//  Created by Mac on 2017/7/27.
//  Copyright © 2017年 QiXing. All rights reserved.
//

#import "FMDBManger.h"
#import "FMDB.h"
#import <objc/runtime.h>// 导入运行时文件

#define mainThread(block) dispatch_async(dispatch_get_main_queue(), block)

@implementation FMDBManger
{
    //操作数据库的对象
    FMDatabase *_fmdb;
}

+ (FMDBManger *)shareManager
{
    static FMDBManger *_dB = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_dB == nil) {
            _dB = [[FMDBManger alloc] init];
        }
    });
    return _dB;
}

- (id)init
{
    
    self = [super init];
    if (self) {
        //fmdb对象 他的实例化 需要一个路径
        //[NSBundle mainBundle]
        //user/Documents/photoshops/....
        //当使用 NSHomeDirectory() 你得到了3个文件夹（路径 你所在的地方有三个文件夹）
        //NSHomeDirectory() -> NSString
//        NSString *path = [NSHomeDirectory() stringByAppendingString:@"/Documents/appa.db"];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentDitrctory = [paths objectAtIndex:0];
        NSString *dbPath = [documentDitrctory stringByAppendingPathComponent:@"ColorDataBase.db"];
        NSLog(@"打印数据库路径:%@",dbPath);
        _fmdb = [[FMDatabase alloc] initWithPath:dbPath];
        
        
    }
    return self;
}

#pragma mark - 数据库操作


- (BOOL)isExistTableWithTitle:(NSString *)title
{
    if ([_fmdb open]) {
        NSLog(@"打开数据库成功");
        //我们打开数据库之后 需要创建表格
        /*
         create table if not exists app(id varchar(32),name varchar(128),pic varchar(1024))
         */
        NSString *sql = [NSString stringWithFormat:@"create table if not exists '%@'(serial text,hexStr text,onms text,offms text,brigthness text,repeat text,tableName text);", title ];
        BOOL isSuccess = [_fmdb executeUpdate:sql];
        if (isSuccess) {
            NSLog(@"建表成功或已存在");
            return YES;
        }else{
            NSLog(@"建表失败:%@",_fmdb.lastErrorMessage);
            return NO;
        }
        
    }else{
        NSLog(@"数据库打开失败");
        return NO;
    }
}

//这个表格里面是否包含这个数据
//查询
- (BOOL)isExistsDataWithModel:(BTSeqListCellEntity *)entity
{
    /*
     select applicationid from app where applicationid = ?
     */
//    NSString *sql = @"select serial from app where serial = ?";
    
//    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ ORDER BY serial DESC",entity.tableName];    // 按照ID号降序排列,如果只有order by默认是升序的 等同于ASC
    //_fmdb
    //这个方法是查询
    
//    NSString *sql = [NSString stringWithFormat:@"select serial from %@ where serial = %@",entity.tableName,entity.serial];
    
    NSString *sql = [NSString stringWithFormat:@"select * from %@", entity.tableName];
    
    FMResultSet *set = [_fmdb executeQuery:sql];
    
    //[set next] 如果你查询到了 这个方法会返回一个真值
    
    while ([set next]) {
//        NSString *str = [set stringForColumn:@"serial"];
//        if ([entity.serial isEqualToString:[set stringForColumn:@"serial"]]) {
//            
//            return YES;
//        }
        if (entity.serial == [set intForColumn:@"serial"]) {
            return YES;
        }
    }
    return NO;
//    return [set next];
}

//插入
- (BOOL)insertDataWithModel:(BTSeqListCellEntity *)entity
{
    /*
     insert into app (applicationId,name,iconUrl) values (?,?,?)
     */
    
    NSString *sql = [NSString stringWithFormat:@"insert into %@(serial,hexStr,onms,offms,brigthness,repeat,tableName) values (?,?,?,?,?,?,?)",entity.tableName ];
    BOOL isSuccess = [_fmdb executeUpdate:sql,@(entity.serial),entity.hexStr,
                      @(entity.onms),@(entity.offms),@(entity.brigthness),@(entity.repeat),entity.tableName];
    
    if (isSuccess) {
        NSLog(@"插入成功");
    }else{
        NSLog(@"插入失败:%@",_fmdb.lastErrorMessage);
    }
    return isSuccess;
}


- (BOOL)deleteDataWithModel:(BTSeqListCellEntity *)entity
{
    NSString *sql = [NSString stringWithFormat:@"delete from %@ where serial = ?",entity.tableName ];
    BOOL isSuccess = [_fmdb executeUpdate:sql,@(entity.serial)];
    if (isSuccess) {
        NSLog(@"删除成功");
    }else{
        NSLog(@"删除失败%@",_fmdb.lastErrorMessage);
    }
    return isSuccess;
}

//修改
- (BOOL)changeDataWithModel:(BTSeqListCellEntity *)entity newStr:(NSString *)str
{

//    BOOL exist = [self isExistsDataWithModel:entity];
    NSArray *arr = @[@"serial",@"hexStr",@"onms",@"offms",@"brigthness",@"repeat",@"tableName"];
    NSArray *changeArr = @[@(entity.serial),entity.hexStr,@(entity.onms),@(entity.offms),@(entity.brigthness),@(entity.repeat),entity.tableName];
    
        for (NSInteger i=0; i<arr.count; i++) {
            NSString *sql = [NSString stringWithFormat:@"update %@ set %@ = ? where serial = ?",
                                        entity.tableName ,arr[i]];
            BOOL isSuccess = [_fmdb executeUpdate:sql,changeArr[i],@(entity.serial)];
            if (isSuccess) {
                NSLog(@"修改成功");
            }else{
                NSLog(@"修改失败:%@",_fmdb.lastErrorMessage);
            }
        }
    
    return YES;
}

- (NSArray *)allDataWithTable:(NSString *)table
{
    NSString *sql = [NSString stringWithFormat:@"select * from %@", table];
    FMResultSet *set = [_fmdb executeQuery:sql];
    //装数据模型
    NSMutableArray *array = [NSMutableArray array];
    while ([set next]) {
        BTSeqListCellEntity *entity = [[BTSeqListCellEntity alloc] init];
        entity.serial = [set intForColumn:@"serial"];
        entity.hexStr = [set stringForColumn:@"hexStr"];
        entity.onms = [set intForColumn:@"onms"];
        entity.offms = [set intForColumn:@"offms"];
        entity.brigthness = [set intForColumn:@"brigthness"];
        entity.repeat = [set intForColumn:@"repeat"];
        [array addObject:entity];
//        NSDictionary *dic = @{
//                              @"serial":[set stringForColumn:@"serial"],
//                              @"red":[set stringForColumn:@"red"],
//                              @"green":[set stringForColumn:@"green"],
//                              @"blue":[set stringForColumn:@"blue"],
//                              @"on":[set stringForColumn:@"onms"],
//                              @"off":[set stringForColumn:@"offms"],
//                              @"brigthness":[set stringForColumn:@"brigthness"],
//                              @"repeat":[set stringForColumn:@"repeat"]};
//        [array addObject:dic];
    }
    
    
    
    return array;
}

/*
 删除
 delete from app where applicationId = ?
 
 更新一条数据
 update app set name = ? where name = ?
 
 
 查找整张表
 select * from app
 
 */



@end
