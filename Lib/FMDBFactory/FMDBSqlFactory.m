//
//  FMDBSqlFactory.m
//  chaozhou
//

//

#import "FMDBSqlFactory.h"

#import "Define.h"

@implementation FMDBSqlFactory

#pragma mark - 数据库操作通用方法

#pragma mark select
/*
 查询数据基础方法
 
 tableName  : 表格名称
 selPars    : 需要查询的属性名称的数组
 conditions : 需要查询的条件字典 属性名称为key 值为obj(若需要查询多个值用IN关键字时，obj为NSArray)
 orderBy    : 排序字段参数（若排序字段为nil，则不进行排序）, 按照参数顺序作为排序的优先顺序，先排序数组中0位置的参数
              数组内容为NSDictionary,带有两个参数 nsstring order_name 排序的属性名称, nsnumber(bool) order_is_asc 排序是否递增排序
 range      : 截取指定序号的数据
 */
+ (NSString *)getSelectTableSQLWithTable:(NSString *)tableName selectParameters:(NSArray *)selPars conditions:(NSDictionary *)conditions orderBy:(NSArray *)orderBy limit:(NSRange)range {
    
    if (tableName == nil || selPars == nil) {
        DMLog(@"getSelectTableSQLWithTable selectParameters parameters: is null");
        return nil;
    }
    
    if ([tableName isEqualToString:@""]) {
        DMLog(@"getSelectTableSQLWithTable selectParameters parameters: name is \"\" ");
        return nil;
    }
    
    if (selPars.count == 0) {
        DMLog(@"getSelectTableSQLWithTable selectParameters parameters: count == 0");
        return nil;
    }
    
    // 目标
    NSMutableString *par = [NSMutableString string];
    for (NSString *selPar in selPars) {
        [par appendFormat:@"%@, ",selPar];
    }
    [par deleteCharactersInRange:NSMakeRange(par.length-2, 2)];
    
    
    // 条件
    NSString *con = [self getConWithConditions:conditions];
    
    // 排序顺序
    NSMutableString *order = [NSMutableString string];
    if (orderBy != nil && orderBy.count != 0) {
        [order appendString:@"ORDER BY "];
        
        int count = 0;
        while (count != orderBy.count) {
            NSDictionary *dic = [orderBy objectAtIndex:count];
            [order appendFormat:@"%@ ",[dic objectForKey:@"order_name"]];
            if ([[dic objectForKey:@"order_is_asc"]boolValue]) {
                [order appendString:@"ASC "];
            } else {
                [order appendString:@"DESC "];
            }
            [order appendString:@", "];
            count++;
        }
        [order deleteCharactersInRange:NSMakeRange(order.length-2, 2)];
    }
    
    // 截取指定序号数据
    NSString *limit = @"";
    if (range.length != 0) {
        limit = [NSString stringWithFormat:@" LIMIT %ld,%ld ",(long)range.location,(long)range.length];
    }
    
    NSString *sql = [NSString stringWithFormat:@"SELECT %@ FROM %@ %@ %@ %@",par,tableName,con,order,limit];
    
    return sql;
}

+ (NSString *)getSelectTableSQLWithTable:(NSString *)tableName selectParameters:(NSArray *)selPars conditions:(NSDictionary *)conditions groupBy:(NSString *)groupBy orderBy:(NSArray *)orderBy limit:(NSRange)range {
    
    if (tableName == nil || selPars == nil) {
        DMLog(@"getSelectTableSQLWithTable selectParameters parameters: is null");
        return nil;
    }
    
    if ([tableName isEqualToString:@""]) {
        DMLog(@"getSelectTableSQLWithTable selectParameters parameters: name is \"\" ");
        return nil;
    }
    
    if (selPars.count == 0) {
        DMLog(@"getSelectTableSQLWithTable selectParameters parameters: count == 0");
        return nil;
    }
    
    // 目标
    NSMutableString *par = [NSMutableString string];
    for (NSString *selPar in selPars) {
        [par appendFormat:@"%@, ",selPar];
    }
    [par deleteCharactersInRange:NSMakeRange(par.length-2, 2)];
    
    
    // 条件
    NSString *con = [self getConWithConditions:conditions];
    
    // 分组
    NSString *group = groupBy;
    
    
    // 排序顺序
    NSMutableString *order = [NSMutableString string];
    if (orderBy != nil && orderBy.count != 0) {
        [order appendString:@"ORDER BY "];
        
        int count = 0;
        while (count != orderBy.count) {
            NSDictionary *dic = [orderBy objectAtIndex:count];
            [order appendFormat:@"%@ ",[dic objectForKey:@"order_name"]];
            if ([[dic objectForKey:@"order_is_asc"]boolValue]) {
                [order appendString:@"ASC "];
            } else {
                [order appendString:@"DESC "];
            }
            [order appendString:@", "];
            count++;
        }
        [order deleteCharactersInRange:NSMakeRange(order.length-2, 2)];
    }
    
    
    // 截取指定序号数据
    NSString *limit = @"";
    if (range.length != 0) {
        limit = [NSString stringWithFormat:@" LIMIT %lu,%lu ",(unsigned long)range.location,(unsigned long)range.length];
    }
    
    NSString *sql = [NSString stringWithFormat:@"SELECT %@ FROM %@ GROUP BY %@ %@ %@ %@",par,tableName,con,group,order,limit];
    
    return sql;
}


#pragma mark insert
// 插入行的通用方法，参数为：表格名称、参数名称、参数值、参数名称、参数值
+ (NSString *)getInsertTableSQLWithTableName:(NSString *)tableName parameters:(NSDictionary *)parameters {
    if (tableName == nil || parameters == nil) {
        DMLog(@"getInsertTableSQLWithTableName selectParameters parameters: is null");
        return nil;
    }
    
    if ([tableName isEqualToString:@""]) {
        DMLog(@"getInsertTableSQLWithTableName selectParameters parameters: name is \"\" ");
        return nil;
    }
    
    if (parameters.count == 0) {
        DMLog(@"getInsertTableSQLWithTableName selectParameters parameters: count == 0");
        return nil;
    }
    
    NSMutableString *names = [NSMutableString string];
    NSMutableString *values = [NSMutableString string];
    
    for (NSString *key in parameters.keyEnumerator) {
        [names appendFormat:@"%@, ",key];
        [values appendFormat:@"'%@', ",[self getString:[parameters objectForKey:key]]];
    }
    [names deleteCharactersInRange:NSMakeRange(names.length-2, 2)];
    [values deleteCharactersInRange:NSMakeRange(values.length-2, 2)];
    
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@(%@) VALUES (%@)",tableName,names,values];
    
//    NSLog(@"%@",sql);
    
    return sql;
}

#pragma mark update
// 更新表格的通用方法，参数为：更新表名称，修改后的参数名称为KEY参数值为obj的字典，需要修改的条件字典 参数名称为key 参数值为obj
+ (NSString *)getUpdateTableSQLWithTableName:(NSString *)tableName parameters:(NSDictionary *)parameters conditions:(NSDictionary *)conditions {
    
    if (tableName == nil || parameters == nil) {
        DMLog(@"getUpdateTableSQLWithTableName selectParameters parameters: is null");
        return nil;
    }
    
    if ([tableName isEqualToString:@""]) {
        DMLog(@"getUpdateTableSQLWithTableName selectParameters parameters: name is \"\" ");
        return nil;
    }
    
    if (parameters.count == 0) {
        DMLog(@"getUpdateTableSQLWithTableName selectParameters parameters: count == 0");
        return nil;
    }
    
    // 参数
    NSMutableString *par = [NSMutableString string];
    for (NSString *key in parameters.keyEnumerator) {
        [par appendFormat:@"%@='%@', ",key,[self getString:[parameters objectForKey:key]]];
    }
    [par deleteCharactersInRange:NSMakeRange(par.length-2, 2)];
    
    // 条件
    NSString *con = [self getConWithConditions:conditions];
    
    NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET %@ %@",tableName,par,con];
    
//    NSLog(@"%@",sql);
    
    return sql;
}

#pragma mark delete
// 删除数据通用方法
// tableName  : 需要执行删除指令的对应表名称
// conditions : 需要查询的条件字典 属性名称为key 值为obj(若需要查询多个值用IN关键字时，obj为NSArray)
+ (NSString *)getDeleteDataSQLWithTableName:(NSString *)tableName conditions:(NSDictionary *)conditions {
    
    // 条件
    NSString *con = [self getConWithConditions:conditions];
    
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ %@",tableName,con];
    
//    NSLog(@"delete %@",sql);
    
    return sql;
}

#pragma mark 子模块

// 查询条件部分
+ (NSString *)getConWithConditions:(NSDictionary *)conditions {
    NSMutableString *con = [NSMutableString string];
    if (conditions != nil && conditions.count != 0) {
        [con appendString:@"WHERE "];
        
        for (NSString *key in conditions.keyEnumerator) {
            
            // obj为数组时使用IN关键字，如果不是则使用“=”
            if ([[conditions objectForKey:key]isKindOfClass:[NSArray class]]) {
                
                NSArray *array = [conditions objectForKey:key];
                
                [con appendFormat:@"%@ IN ( ",key];
                
                NSInteger count = array.count;
                while (count--) {
                    [con appendFormat:@"'%@', ",[self getString:[array objectAtIndex:count]]];
                }
                [con deleteCharactersInRange:NSMakeRange(con.length-2, 2)];
                [con appendString:@") "];
                
            } else if ([conditions objectForKey:key] == [NSNull null]) {
                [con appendFormat:@"%@ is null",key];
            } else {
                [con appendFormat:@"%@='%@' ",key,[self getString:[conditions objectForKey:key]]];
            }
            [con appendString:@"AND "];
        }
        [con deleteCharactersInRange:NSMakeRange(con.length-4, 4)];
    }
    return con;
}

#pragma mark -

+ (NSString *)getString:(NSObject *)obj {
    if ([obj isKindOfClass:[NSString class]]) {
        return [(NSString *)obj stringByReplacingOccurrencesOfString:@"'" withString:@"''"]; // 添加替换单引号，避免sqlite单引号关键字
    }
    if ([obj isKindOfClass:[NSNumber class]]) {
        return [(NSNumber *)obj stringValue];
    }
    if ([obj isKindOfClass:[NSDate class]]) {
        return [NSString stringWithFormat:@"%f",[(NSDate *)obj timeIntervalSince1970]];
    }
    return @"";
}

@end
