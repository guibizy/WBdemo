//
//  FMDBTool.m
//  chaozhou
//
//  Created by 悦讯科技  on 13-8-1.
//  Copyright (c) 2013年 悦讯科技 . All rights reserved.
//

#import "FMDBTool.h"

#import "Define.h"

SYNTHESIZE_SINGLETON_FOR_CLASS_PROTOTYPE(FMDBTool);

@implementation FMDBTool
@synthesize m_dbName;

SYNTHESIZE_SINGLETON_FOR_CLASS(FMDBTool);

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma mark - 数据库开关

- (BOOL)openDataBase {
    
    BOOL flog = YES;
    
    @synchronized(self) {
        
        if (queue == nil) {
            //paths： ios下Document路径，Document为ios中可读写的文件夹
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentDirectory = [paths objectAtIndex:0];
            NSString *dbPath = [documentDirectory stringByAppendingPathComponent:[self.m_dbName stringByAppendingString:@".db"]];
            
            //创建数据库实例 db  这里说明下:如果路径中不存在"Test.db"的文件,sqlite会自动创建"Test.db"
            queue = [[FMDatabaseQueue alloc]initWithPath:dbPath];
            if (queue) {
                flog = YES;
            } else {
                ERRORLog(@"Could not open db.");
                flog = NO;
            }
        } else {
            // 计数器+1
            flog = YES;
        }
    }
    
    return flog;
}

- (void)close {
    @synchronized(self) {
        if (queue) {
            [queue close];
            [queue release];
            queue = nil;
            
            [m_dbName release];
            m_dbName = nil;
        }
    }
}

- (void)removeDB:(NSString *)dbName {
    @synchronized(self) {
        [self close];
        
        //paths： ios下Document路径，Document为ios中可读写的文件夹
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentDirectory = [paths objectAtIndex:0];
        NSString *dbPath = [documentDirectory stringByAppendingPathComponent:[dbName stringByAppendingString:@".db"]];
        
        NSFileManager *fm = [NSFileManager defaultManager];
        [fm removeItemAtPath:dbPath error:nil];
    }
}

- (void)setM_dbName:(NSString *)dbName {
    if (dbName == nil || [dbName isEqualToString:@""]) {
        ERRORLog(@"db name is nil");
        return;
    }
    
    if (self.m_dbName !=nil && [dbName isEqualToString:self.m_dbName]) {
        return;
    }
    if (queue) {
        [queue close];
        queue = nil;
    }
    [m_dbName release];
    m_dbName = [dbName copy];
    [self openDataBase];
}

#pragma mark - 直接操作数据库方法

#pragma mark 基本操作方法

- (BOOL)executeUpdate:(NSString *)sql withArgumentsInArray:(NSArray *)array db:(FMDatabase *)db {
    return [self showErrorMessage:[db executeUpdate:sql withArgumentsInArray:array] db:db sql:array];
}

- (NSArray *)executeQuery:(NSString *)sql withArgumentsInArray:(NSArray *)array db:(FMDatabase *)db {
    if (sql == nil) {
        ERRORLog(@"sql is nil");
        return [NSMutableArray array];
    }
    
    NSMutableArray *arr = [NSMutableArray array];
    FMResultSet *fm = [db executeQuery:sql withArgumentsInArray:array];
    
    if ([db hadError]) {
        [self showErrorMessage:NO db:db sql:array];
        return arr;
    }
    
    while ([fm next]) {
        [arr addObject:[fm resultDictionary]];
    }
    [fm close];
    return arr;
}

#pragma mark 基本操作方法封装成批量

// sqlArray 为sql数组   dicArray key为对应sql的count值  obj为array的参数
- (BOOL)executeUpdateArray:(NSArray *)sqlArray withArgumentsInDicArray:(NSDictionary *)dicArray db:(FMDatabase *)db {
    BOOL isSuccess = YES;
    for (int count = 0; count<sqlArray.count; count++) {
        isSuccess &= [self showErrorMessage:[db executeUpdate:sqlArray[count] withArgumentsInArray:dicArray[@(count)]] db:db sql:sqlArray[count]];
    }
    return isSuccess;
}

#pragma mark 普通操作方法
- (NSArray *)inTransactionExecuteQuery:(NSString *)sql ArgumentsInArray:(NSArray *)array {
    __block NSArray *arr = [NSArray array];
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        arr = [self executeQuery:sql withArgumentsInArray:array db:db];
    }];
    return arr;
}

- (BOOL)inTransactionExecuteUpdate:(NSString *)sql withArgumentsInArray:(NSArray *)array {
    __block BOOL isSuccess = YES;
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        isSuccess &= [self executeUpdate:sql withArgumentsInArray:array db:db];
    }];
    return isSuccess;
}

- (void)inTransaction:(void (^)(FMDatabase *db, BOOL *rollback))block {
    [queue inTransaction:block];
}

#pragma mark 批量操作方法

// 批量操作：插入、删除、添加 ，使用事务方式大幅度减少操作时间
// sqlArray(NSString):保存操作的数据库语句 ， array(NSArray):保存对应数据库操作语句的条件参数数组
- (BOOL)inTransactionExecuteUpdates:(NSArray *)sqlArray withArgumentsInArray:(NSArray *)array {
    
    // 参数array 可以去除
    
    if (array!=nil && sqlArray.count != array.count) {
        ERRORLog(@"executeUpdates 参数数量不一致！");
        return NO;
    }
    __block BOOL isSuccess = YES;
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        isSuccess &= [self executeUpdateArray:sqlArray withArgumentsInDicArray:nil db:db];
    }];
    return isSuccess;
}

#pragma mark -

- (BOOL)showErrorMessage:(BOOL)isSuccess db:(FMDatabase *)db sql:(id)sql {
    if (!isSuccess) {
        if ([sql isKindOfClass:[NSString class]] || [sql isKindOfClass:[NSMutableString class]]) {
            ERRORLog(@"error sql:%@",sql);
        } else if ([sql isKindOfClass:[NSArray class]] || [sql isKindOfClass:[NSMutableArray class]]) {
            for (NSString *str in sql) {
                ERRORLog(@"error sql:%@",str);
            }
        }
        ERRORLog(@"database error : %@",[db lastErrorMessage]);
    }
    return isSuccess;
}

@end
