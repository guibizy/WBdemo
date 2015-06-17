//
//  FMDBTool.h
//  chaozhou
//
//

#import <Foundation/Foundation.h>

#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "SynthesizeSingleton.h"

// 数据库线程安全的封装类
@interface FMDBTool : NSObject{
    FMDatabaseQueue *queue;
}

// 数据库名称,用于初始化数据库和开启数据库时使用
@property (nonatomic, copy) NSString *m_dbName;

SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(FMDBTool);

- (void)close;

- (void)removeDB:(NSString *)dbName;

#pragma mark - 直接操作数据库方法

#pragma mark 基本操作方法
- (BOOL)executeUpdate:(NSString *)sql withArgumentsInArray:(NSArray *)array db:(FMDatabase *)db;

- (NSArray *)executeQuery:(NSString *)sql withArgumentsInArray:(NSArray *)array db:(FMDatabase *)db;

#pragma mark 基本操作方法封装成批量

// sqlArray 为sql数组   dicArray key为对应sql的count值  obj为array的参数
- (BOOL)executeUpdateArray:(NSArray *)sqlArray withArgumentsInDicArray:(NSDictionary *)dicArray db:(FMDatabase *)db;

#pragma mark 普通操作方法
// 查询操作 返回NSArray的字典，每个字典代表一行
- (NSArray *)inTransactionExecuteQuery:(NSString *)sql ArgumentsInArray:(NSArray *)array;

// 更新操作 返回bool，表示操作是否成功，并且若操作失败显示提示信息
- (BOOL)inTransactionExecuteUpdate:(NSString *)sql withArgumentsInArray:(NSArray *)array;

- (void)inTransaction:(void (^)(FMDatabase *db, BOOL *rollback))block;

#pragma mark 批量操作方法

// 批量操作：插入、删除、添加 ，使用事务方式大幅度减少操作时间
// sqlArray(NSString):保存操作的数据库语句 ， array(NSArray):保存对应数据库操作语句的条件参数数组
- (BOOL)inTransactionExecuteUpdates:(NSArray *)sqlArray withArgumentsInArray:(NSArray *)array;

@end
