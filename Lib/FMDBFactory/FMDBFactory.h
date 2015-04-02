//
//  FMDBFactory.h
//  chaozhou
//
//  Created by 悦讯科技  on 13-7-12.
//  Copyright (c) 2013年 悦讯科技 . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SynthesizeSingleton.h"
@class FMDBTool;

@protocol FMDBFactoryDeleagte <NSObject>

// 获取对应数据库创建语句
+ (NSString *)getCreateTableSQL;

// 获取对应数据库表名称
+ (NSString *)getTableName;

// 获取主键名称数组
+ (NSArray *)getPrimaryKey;

// 获取完整属性名称和属性值的键值对
- (NSDictionary *)getKeyAndObj;

// 对数据进行填充
- (void)setDic:(NSDictionary *)dic;

@optional

// SELECT操作时排除的字段
+ (NSArray *)removeFromSelect;

// UPDATE操作时排除的字段名称
+ (NSArray *)removeFromUpdateKey;

@end


@interface FMDBFactory : NSObject {
    FMDBTool *m_FMDBTool;
}

SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(FMDBFactory);

#pragma mark - 初始化方法
// 初始化方法
- (BOOL)setDBName:(NSString *)dbName;

#pragma mark - 关闭数据库

- (void)close;

- (void)removeDB:(NSString *)dbName;

#pragma mark - 创建数据库表方法
// 根据实现了FMDBFactoryDeleagte的class创建数据库
- (void)createTableWithClass:(Class)_class;

// 根据sql语句创建数据库表
- (void)createTableWithSQL:(NSString *)sql tableName:(NSString *)tableName;

#pragma mark - 简单封装后的方法

#pragma mark select

/*
 tableName  : 表格名称
 selPars    : 需要查询的属性名称的数组
 conditions : 需要查询的条件字典 属性名称为key 值为obj(若需要查询多个值用IN关键字时，obj为NSArray)
 orderBy    : 排序字段参数（若排序字段为nil，则不进行排序）, 按照参数顺序作为排序的优先顺序，先排序数组中0位置的参数
 数组内容为NSDictionary,带有两个参数 nsstring order_name 排序的属性名称, nsnumber(bool) order_is_asc 排序是否递增排序
 range      : 截取指定序号的数据
 */
- (NSArray *)selectTableWithTable:(NSString *)tableName selectParameters:(NSArray *)selPars conditions:(NSDictionary *)conditions;
- (NSArray *)selectTableWithTable:(NSString *)tableName selectParameters:(NSArray *)selPars conditions:(NSDictionary *)conditions orderBy:(NSArray *)orderBy;
- (NSArray *)selectTableWithTable:(NSString *)tableName selectParameters:(NSArray *)selPars conditions:(NSDictionary *)conditions orderBy:(NSArray *)orderBy limit:(NSRange)range;
- (NSArray *)selectTableWithTable:(NSString *)tableName selectParameters:(NSArray *)selPars conditions:(NSDictionary *)conditions groupBy:(NSString *)groupBy orderBy:(NSArray *)orderBy  limit:(NSRange)range;

#pragma mark insert

// 插入行，参数为：表格名称、参数名称、参数值、参数名称、参数值
- (BOOL)insertTableWithTableName:(NSString *)tableName parameters:(NSDictionary *)parameters;

#pragma mark update

// 更新表格，参数为：更新表名称，修改后的参数名称为KEY参数值为obj的字典，需要修改的条件字典 参数名称为key 参数值为obj
- (BOOL)updateTableWithTableName:(NSString *)tableName parameters:(NSDictionary *)parameters conditions:(NSDictionary *)conditions;

#pragma mark delete

// 删除数据
// tableName  : 需要执行删除指令的对应表名称
// conditions : 需要查询的条件字典 属性名称为key 值为obj(若需要查询多个值用IN关键字时，obj为NSArray)
- (BOOL)deleteDataWithTableName:(NSString *)tableName conditions:(NSDictionary *)conditions;

#pragma mark - 封装后的方法

#pragma mark select

// 根据data查询并填充data
- (id)selectData:(id<FMDBFactoryDeleagte>)data conditions:(NSDictionary *)conditions;

// 根据data查询并填充data，利用data内部带有的主键值
- (id)selectData:(id<FMDBFactoryDeleagte>)data;

/*
 _class  : 需要查询的数据类型
 conditions : 需要查询的条件字典 属性名称为key 值为obj(若需要查询多个值用IN关键字时，obj为NSArray)
 orderBy    : 排序字段参数（若排序字段为nil，则不进行排序）, 按照参数顺序作为排序的优先顺序，先排序数组中0位置的参数
              数组内容为NSDictionary,带有两个参数 nsstring order_name 排序的属性名称, nsnumber(bool) order_is_asc 排序是否递增排序
 range      : 截取指定序号的数据
 */
- (NSArray *)selectDataArrayWithClass:(Class)_class conditions:(NSDictionary *)conditions;
- (NSArray *)selectDataArrayWithClass:(Class)_class conditions:(NSDictionary *)conditions orderBy:(NSArray *)orderBy;
- (NSArray *)selectDataArrayWithClass:(Class)_class conditions:(NSDictionary *)conditions orderBy:(NSArray *)orderBy limit:(NSRange)range;
- (NSArray *)selectDataArrayWithClass:(Class)_class conditions:(NSDictionary *)conditions  groupBy:(NSString *)groupBy orderBy:(NSArray *)orderBy limit:(NSRange)range;

#pragma mark insert
// 把data插入数据库
- (BOOL)insertData:(id<FMDBFactoryDeleagte>)data;

// 把data数组批量插入数据库
- (BOOL)insertDataArray:(NSArray *)array;

#pragma mark update
// 根据data的主键作为条件跟新数据库
- (BOOL)updateData:(id<FMDBFactoryDeleagte>)data;

// 根据data批量操作数据库
- (BOOL)updateDataArray:(NSArray *)array;

#pragma mark delete
// 根据提供的data的主键值删除对应数据库数据
- (BOOL)deleteData:(id<FMDBFactoryDeleagte>)data;

// 批量删除data数据
- (BOOL)deleteDataArray:(NSArray *)array;

// 删除表的所有数据
- (BOOL)deleteTable:(NSString *)tableName;

#pragma mark - 再次封装后的高级方法
// 对数据库进行添加操作，若数据库内已经有该字段则进行update ，若没有该字段则进行insert
- (BOOL)inputData:(id<FMDBFactoryDeleagte>)data;

// 对数据库进行批量添加操作，若数据库内已经有对应主键的数据，则进行update，若没有则进行insert
- (BOOL)inputDataArray:(NSArray *)array;

#pragma mark - 查询是否存在
// 判断对应条件的字段是否存在
- (BOOL)selectIsHaveWithTable:(NSString *)tableName key:(NSString *)key conditions:(NSDictionary *)conditions;

// 判断data对应条件在数据库中是否已经存在
- (BOOL)selectDataIsHaveForKey:(id<FMDBFactoryDeleagte>)data conditions:(NSDictionary *)conditions;

// 判断data对应主键在数据库中是否已经存在
- (BOOL)selectDataIsHaveForKey:(id<FMDBFactoryDeleagte>)data;

#pragma mark 查询数量方法
// 根据表名称查询对应表当前数据库数据总数,允许有查询条件
- (int)selectCountWithTableName:(NSString *)tableName;
- (int)selectCountWithTableName:(NSString *)tableName conditions:(NSDictionary *)conditions;


#pragma mark - 数据库版本相关

// 获取当前数据库版本  默认为0
- (int)getUserVersion;

// 设置当前数据库版本
- (BOOL)setUserVersion:(int)version;

@end
