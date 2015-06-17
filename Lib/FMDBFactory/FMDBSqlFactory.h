//
//  FMDBSqlFactory.h
//  chaozhou
//

//

#import <Foundation/Foundation.h>

@interface FMDBSqlFactory : NSObject

/*
 查询数据基础方法
 
 tableName  : 表格名称
 selPars    : 需要查询的属性名称的数组
 conditions : 需要查询的条件字典 属性名称为key 值为obj(若需要查询多个值用IN关键字时，obj为NSArray)
 orderBy    : 排序字段参数（若排序字段为nil，则不进行排序）, 按照参数顺序作为排序的优先顺序，先排序数组中0位置的参数
 数组内容为NSDictionary,带有两个参数 nsstring order_name 排序的属性名称, nsnumber(bool) order_is_asc 排序是否递增排序
 range      : 截取指定序号的数据
 */
+ (NSString *)getSelectTableSQLWithTable:(NSString *)tableName selectParameters:(NSArray *)selPars conditions:(NSDictionary *)conditions orderBy:(NSArray *)orderBy limit:(NSRange)range;
+ (NSString *)getSelectTableSQLWithTable:(NSString *)tableName selectParameters:(NSArray *)selPars conditions:(NSDictionary *)conditions groupBy:(NSString *)groupBy orderBy:(NSArray *)orderBy limit:(NSRange)range;


// 插入行的通用方法，参数为：表格名称、参数名称、参数值、参数名称、参数值
+ (NSString *)getInsertTableSQLWithTableName:(NSString *)tableName parameters:(NSDictionary *)parameters;

// 更新表格的通用方法，参数为：更新表名称，修改后的参数名称为KEY参数值为obj的字典，需要修改的条件字典 参数名称为key 参数值为obj
+ (NSString *)getUpdateTableSQLWithTableName:(NSString *)tableName parameters:(NSDictionary *)parameters conditions:(NSDictionary *)conditions;

// 删除数据通用方法
// tableName  : 需要执行删除指令的对应表名称
// conditions : 需要查询的条件字典 属性名称为key 值为obj(若需要查询多个值用IN关键字时，obj为NSArray)
+ (NSString *)getDeleteDataSQLWithTableName:(NSString *)tableName conditions:(NSDictionary *)conditions;

@end
