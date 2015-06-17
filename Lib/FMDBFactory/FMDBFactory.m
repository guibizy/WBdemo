//
//  FMDBFactory.m
//  chaozhou
//

//

#import "FMDBFactory.h"

#import "FMDBTool.h"
#import "FMDBSqlFactory.h"

#import "Define.h"

SYNTHESIZE_SINGLETON_FOR_CLASS_PROTOTYPE(FMDBFactory);

@implementation FMDBFactory

SYNTHESIZE_SINGLETON_FOR_CLASS(FMDBFactory);

- (id)init {
    @synchronized(self) {
        self =[super init];//往往放一些要初始化的变量.
        m_FMDBTool = [FMDBTool sharedInstance];
    }
    return self;
}

#pragma mark - 初始化方法
// 初始化方法
- (BOOL)setDBName:(NSString *)dbName {
    if ([m_FMDBTool.m_dbName isEqualToString:dbName]) {
        return NO;
    }
    m_FMDBTool.m_dbName = dbName;
    return YES;
}

#pragma mark - 关闭数据库

- (void)close {
    [m_FMDBTool close];
}

- (void)removeDB:(NSString *)dbName {
    [m_FMDBTool removeDB:dbName];
}

#pragma mark - 创建数据库表方法

// 根据实现了FMDBFactoryDeleagte的class创建数据库
- (void)createTableWithClass:(Class)_class {
    [self createTableWithSQL:[_class getCreateTableSQL] tableName:[_class getTableName]];
}

// 根据sql语句创建数据库表
- (void)createTableWithSQL:(NSString *)sql tableName:(NSString *)tableName {
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         tableName,@"name",
                         @"table",@"type", nil];
    int count = [self selectCountWithTableName:@"sqlite_master" conditions:dic];
    switch (count) {
        case -1:
            DMLog(@"查询表是否存在时出错");
            break;
        case 0:
            [m_FMDBTool inTransactionExecuteUpdate:sql withArgumentsInArray:nil];
        case 1:
            // 表存在  不创建表
        default:
            break;
    }
}
#pragma mark - 简单封装后的方法

#pragma mark select
/*
 tableName  : 表格名称
 selPars    : 需要查询的属性名称的数组
 conditions : 需要查询的条件字典 属性名称为key 值为obj(若需要查询多个值用IN关键字时，obj为NSArray)
 */
- (NSArray *)selectTableWithTable:(NSString *)tableName selectParameters:(NSArray *)selPars conditions:(NSDictionary *)conditions {
    return [self selectTableWithTable:tableName selectParameters:selPars conditions:conditions orderBy:nil];
}

/*
 tableName  : 表格名称
 selPars    : 需要查询的属性名称的数组
 conditions : 需要查询的条件字典 属性名称为key 值为obj(若需要查询多个值用IN关键字时，obj为NSArray)
 orderBy    : 排序字段参数（若排序字段为nil，则不进行排序）, 按照参数顺序作为排序的优先顺序，先排序数组中0位置的参数
 数组内容为NSDictionary,带有两个参数 nsstring order_name 排序的属性名称, nsnumber(bool) order_is_asc 排序是否递增排序
 */
- (NSArray *)selectTableWithTable:(NSString *)tableName selectParameters:(NSArray *)selPars conditions:(NSDictionary *)conditions orderBy:(NSArray *)orderBy {
    return [self selectTableWithTable:tableName selectParameters:selPars conditions:conditions orderBy:orderBy limit:NSMakeRange(0, 0)];
}

/*
 tableName  : 表格名称
 selPars    : 需要查询的属性名称的数组
 conditions : 需要查询的条件字典 属性名称为key 值为obj(若需要查询多个值用IN关键字时，obj为NSArray)
 orderBy    : 排序字段参数（若排序字段为nil，则不进行排序）, 按照参数顺序作为排序的优先顺序，先排序数组中0位置的参数
 数组内容为NSDictionary,带有两个参数 nsstring order_name 排序的属性名称, nsnumber(bool) order_is_asc 排序是否递增排序
 range      : 截取指定序号的数据
 */
- (NSArray *)selectTableWithTable:(NSString *)tableName selectParameters:(NSArray *)selPars conditions:(NSDictionary *)conditions orderBy:(NSArray *)orderBy limit:(NSRange)range {
    NSString *sql = [FMDBSqlFactory getSelectTableSQLWithTable:tableName selectParameters:selPars conditions:conditions orderBy:orderBy limit:range];
    return [m_FMDBTool inTransactionExecuteQuery:sql ArgumentsInArray:nil];
}
- (NSArray *)selectTableWithTable:(NSString *)tableName selectParameters:(NSArray *)selPars conditions:(NSDictionary *)conditions groupBy:(NSString *)groupBy  orderBy:(NSArray *)orderBy   limit:(NSRange)range {
    NSString *sql = [FMDBSqlFactory getSelectTableSQLWithTable:tableName selectParameters:selPars conditions:conditions groupBy:groupBy orderBy:orderBy limit:range];
    return [m_FMDBTool inTransactionExecuteQuery:sql ArgumentsInArray:nil];
}

#pragma mark insert

// 插入行，参数为：表格名称、参数名称、参数值、参数名称、参数值
- (BOOL)insertTableWithTableName:(NSString *)tableName parameters:(NSDictionary *)parameters {
    NSString *sql = [self _insertTableWithTableName:tableName parameters:parameters];
    BOOL flog = [m_FMDBTool inTransactionExecuteUpdate:sql withArgumentsInArray:nil];
    return flog;
}
- (NSString *)_insertTableWithTableName:(NSString *)tableName parameters:(NSDictionary *)parameters {
    return [FMDBSqlFactory getInsertTableSQLWithTableName:tableName parameters:parameters];
}

#pragma mark update

// 更新表格，参数为：更新表名称，修改后的参数名称为KEY参数值为obj的字典，需要修改的条件字典 参数名称为key 参数值为obj
- (BOOL)updateTableWithTableName:(NSString *)tableName parameters:(NSDictionary *)parameters conditions:(NSDictionary *)conditions {
    NSString *sql = [self _updateTableWithTableName:tableName parameters:parameters conditions:conditions];
    BOOL flog = [m_FMDBTool inTransactionExecuteUpdate:sql withArgumentsInArray:nil];
    return flog;
}
- (NSString *)_updateTableWithTableName:(NSString *)tableName parameters:(NSDictionary *)parameters conditions:(NSDictionary *)conditions {
    return [FMDBSqlFactory getUpdateTableSQLWithTableName:tableName parameters:parameters conditions:conditions];
}

#pragma mark delete

// 删除数据
// tableName  : 需要执行删除指令的对应表名称
// conditions : 需要查询的条件字典 属性名称为key 值为obj(若需要查询多个值用IN关键字时，obj为NSArray)
- (BOOL)deleteDataWithTableName:(NSString *)tableName conditions:(NSDictionary *)conditions {
    
    NSString *sql = [self _deleteDataWithTableName:tableName conditions:conditions];
    BOOL flog = [m_FMDBTool inTransactionExecuteUpdate:sql withArgumentsInArray:nil];
    
    return flog;
}
- (NSString *)_deleteDataWithTableName:(NSString *)tableName conditions:(NSDictionary *)conditions {
    return [FMDBSqlFactory getDeleteDataSQLWithTableName:tableName conditions:conditions];
}

#pragma mark - 封装后的方法

#pragma mark select

// 根据data查询并填充data
- (id)selectData:(id<FMDBFactoryDeleagte>)data conditions:(NSDictionary *)conditions {
    
    NSArray *array = [self selectTableWithTable:[[data class] getTableName] selectParameters:[self selectConditionsWithData:data] conditions:conditions];
    if (array.count) {
        [data setDic:[array objectAtIndex:0]];
    } else {
        return nil;
    }
    
    return data;
}

// 根据data查询并填充data，利用data内部带有的主键值
- (id)selectData:(id<FMDBFactoryDeleagte>)data {
    
    NSDictionary *dataDic = [data getKeyAndObj];
    NSDictionary *conditions = [dataDic dictionaryWithValuesForKeys:[[data class] getPrimaryKey]];
    
    return [self selectData:data conditions:conditions];
}

// 根据提供的data和条件字典，查询并填充对应数据的数组
- (NSArray *)selectDataArrayWithClass:(Class)_class conditions:(NSDictionary *)conditions {
    return [self selectDataArrayWithClass:_class conditions:conditions orderBy:nil];
}

- (NSArray *)selectDataArrayWithClass:(Class)_class conditions:(NSDictionary *)conditions orderBy:(NSArray *)orderBy {
    return [self selectDataArrayWithClass:_class conditions:conditions orderBy:orderBy limit:NSMakeRange(0, 0)];
}

/*
 _class  : 需要查询的数据类型
 conditions : 需要查询的条件字典 属性名称为key 值为obj(若需要查询多个值用IN关键字时，obj为NSArray)
 orderBy    : 排序字段参数（若排序字段为nil，则不进行排序）, 按照参数顺序作为排序的优先顺序，先排序数组中0位置的参数
              数组内容为NSDictionary,带有两个参数 nsstring order_name 排序的属性名称, nsnumber(bool) order_is_asc 排序是否递增排序
 range      : 截取指定序号的数据
 */
- (NSArray *)selectDataArrayWithClass:(Class)_class conditions:(NSDictionary *)conditions orderBy:(NSArray *)orderBy limit:(NSRange)range {
    
    id<FMDBFactoryDeleagte> dataTemp = [[_class alloc]init];
    if (![dataTemp conformsToProtocol:@protocol(FMDBFactoryDeleagte)]) {
        [dataTemp release];
        return [NSArray array];
    }
    
    NSMutableArray *array = [NSMutableArray array];
    
    NSArray *arr = [self selectTableWithTable:[_class getTableName] selectParameters:[[dataTemp getKeyAndObj]allKeys]conditions:conditions orderBy:orderBy limit:range];
    
    for (NSDictionary *dic in arr) {
        id<FMDBFactoryDeleagte> data = [[_class alloc]init];
        [data setDic:dic];
        [array addObject:data];
        [data release];
    }
    
    [dataTemp release];
    
    return array;
}
- (NSArray *)selectDataArrayWithClass:(Class)_class
                           conditions:(NSDictionary *)conditions
                              groupBy:(NSString *)groupBy
                              orderBy:(NSArray *)orderBy
                                limit:(NSRange)range
{
    id<FMDBFactoryDeleagte> dataTemp = [[_class alloc]init];
    if (![dataTemp conformsToProtocol:@protocol(FMDBFactoryDeleagte)]) {
        [dataTemp release];
        return [NSArray array];
    }
    
    NSMutableArray *array = [NSMutableArray array];
    
    NSArray *arr = [self selectTableWithTable:[_class getTableName] selectParameters:[[dataTemp getKeyAndObj]allKeys]conditions:conditions groupBy:groupBy orderBy:orderBy limit:range];
    
    for (NSDictionary *dic in arr) {
        id<FMDBFactoryDeleagte> data = [[_class alloc]init];
        [data setDic:dic];
        [array addObject:data];
        [data release];
    }
    
    [dataTemp release];
    
    return array;
}

#pragma mark insert

// 把data插入数据库
- (BOOL)insertData:(id<FMDBFactoryDeleagte>)data {
    return [m_FMDBTool inTransactionExecuteUpdate:[self _insertData:data] withArgumentsInArray:nil];
}
- (NSString *)_insertData:(id<FMDBFactoryDeleagte>)data {
    return [self _insertTableWithTableName:[[data class] getTableName] parameters:[data getKeyAndObj]];
}

// 把data数组批量插入数据库
- (BOOL)insertDataArray:(NSArray *)array {
    NSArray *sqlArray = [self _insertDataArray:array];
    return [m_FMDBTool inTransactionExecuteUpdates:sqlArray withArgumentsInArray:nil];
}
- (NSArray *)_insertDataArray:(NSArray *)array {
    
    NSMutableArray *sqlArray = [NSMutableArray array];
    for (id<FMDBFactoryDeleagte> data in array) {
        [sqlArray addObject:[self _insertData:data]];
    }
    return sqlArray;
}


#pragma mark update

// 根据data的主键作为条件更新数据库
- (BOOL)updateData:(id<FMDBFactoryDeleagte>)data {
    return [m_FMDBTool inTransactionExecuteUpdate:[self _updateData:data] withArgumentsInArray:nil];
}
- (NSString *)_updateData:(id<FMDBFactoryDeleagte>)data {
    
    Class _class = [data class];
    
    NSDictionary *dataDic = [data getKeyAndObj];
    NSDictionary *parameters = dataDic;
    if ([data respondsToSelector:@selector(removeFromUpdateKey)]) {
        NSMutableArray *keys = [NSMutableArray arrayWithArray:[dataDic allKeys]];
        [keys removeObjectsInArray:[_class removeFromUpdateKey]];
        parameters = [parameters dictionaryWithValuesForKeys:keys];
    }
    NSDictionary *conditions = [dataDic dictionaryWithValuesForKeys:[_class getPrimaryKey]];
    return [self _updateTableWithTableName:[_class getTableName] parameters:parameters conditions:conditions];
}

// 根据data批量操作数据库
- (BOOL)updateDataArray:(NSArray *)array {
    NSArray *sqlArray = [self _updateDataArray:array];
    return [m_FMDBTool inTransactionExecuteUpdates:sqlArray withArgumentsInArray:nil];
}
- (NSArray *)_updateDataArray:(NSArray *)array {
    NSMutableArray *sqlArray = [NSMutableArray array];
    for (id<FMDBFactoryDeleagte> data in array) {
        [sqlArray addObject:[self _updateData:data]];
    }
    return sqlArray;
}

#pragma mark delete

// 根据提供的data的主键值删除对应数据库数据
- (BOOL)deleteData:(id<FMDBFactoryDeleagte>)data {
    return [m_FMDBTool inTransactionExecuteUpdate:[self _deleteData:data] withArgumentsInArray:nil];
}
- (NSString *)_deleteData:(id<FMDBFactoryDeleagte>)data {
    return [self _deleteDataWithTableName:[[data class] getTableName] conditions:[[data getKeyAndObj] dictionaryWithValuesForKeys:[[data class] getPrimaryKey]]];
}

// 批量删除data数据
- (BOOL)deleteDataArray:(NSArray *)array {
    
    BOOL flog = YES;
    NSMutableArray *sqlArray = [NSMutableArray array];
    for (id<FMDBFactoryDeleagte> data in array) {
        [sqlArray addObject:[self _deleteData:data]];
    }
    flog = [m_FMDBTool inTransactionExecuteUpdates:sqlArray withArgumentsInArray:nil];
    
    return flog;
}

// 删除表的所有数据
- (BOOL)deleteTable:(NSString *)tableName {
    return [self deleteDataWithTableName:tableName conditions:nil];
}

#pragma mark - 再次封装后的高级方法

// 对数据库进行添加操作，若数据库内已经有该字段则进行update ，若没有该字段则进行insert
- (BOOL)inputData:(id<FMDBFactoryDeleagte>)data {
    
    BOOL flog = YES;
    if (!data) {
        return NO;
    }
    // 数据库内已经有该数据则update，若没有则insert
    if ([self selectDataIsHaveForKey:data]) {
        flog = [self updateData:data];
    } else {
        flog = [self insertData:data];
    }
    
    return flog;
}

// 对数据库进行批量添加操作，若数据库内已经有对应主键的数据，则进行update，若没有则进行insert
- (BOOL)inputDataArray:(NSArray *)array {
    
    __block BOOL flog = YES;
    
    [m_FMDBTool inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSMutableArray *insertArray = [[NSMutableArray alloc]init];
        NSMutableArray *updateArray = [[NSMutableArray alloc]init];
        
        for (id<FMDBFactoryDeleagte> data in array) {
            NSDictionary *dataDic = [data getKeyAndObj];
            NSDictionary *conditions = [dataDic dictionaryWithValuesForKeys:[[data class] getPrimaryKey]];
            NSString *sql = [FMDBSqlFactory getSelectTableSQLWithTable:[[data class] getTableName] selectParameters:[NSArray arrayWithObject:@"*"] conditions:conditions orderBy:nil limit:NSMakeRange(0, 0)];
            if ([m_FMDBTool executeQuery:sql withArgumentsInArray:nil db:db].count == 0) {
                [insertArray addObject:data];
            } else {
                [updateArray addObject:data];
            }
        }
        
        NSArray *insertSqlArray = [self _insertDataArray:insertArray];
        flog &= [m_FMDBTool executeUpdateArray:insertSqlArray withArgumentsInDicArray:nil db:db];
        NSArray *updateSqlArray = [self _updateDataArray:updateArray];
        flog &= [m_FMDBTool executeUpdateArray:updateSqlArray withArgumentsInDicArray:nil db:db];
        
        [insertArray release];
        [updateArray release];
    }];
    return flog;
}

#pragma mark - 查询是否存在

// 判断对应条件的字段是否存在
- (BOOL)selectIsHaveWithTable:(NSString *)tableName key:(NSString *)key conditions:(NSDictionary *)conditions {
    BOOL flog = YES;
    if (key == nil || key.length == 0) {
        key = @"*";
    }
    NSArray *arr = [self selectTableWithTable:tableName selectParameters:@[key] conditions:conditions];
    if (arr.count != 0) {
        flog = YES;
    } else {
        flog = NO;
    }
    return flog;
}

// 判断data对应条件在数据库中是否已经存在
- (BOOL)selectDataIsHaveForKey:(id<FMDBFactoryDeleagte>)data conditions:(NSDictionary *)conditions {
    
    if (!data) {
        return NO;
    }
    NSString *keys = @"";
    NSArray *keyArray = [[data class] getPrimaryKey];
    NSMutableString *temp = [NSMutableString string];
    for (NSString *key in keyArray) {
        [temp appendFormat:@"%@,",key];
    }
    if (temp.length > 0) {
        keys = [temp substringToIndex:temp.length-1];
    } else {
        keys = temp;
    }
    return [self selectIsHaveWithTable:[[data class]getTableName] key:keys conditions:conditions];
}

// 判断data对应主键在数据库中是否已经存在
- (BOOL)selectDataIsHaveForKey:(id<FMDBFactoryDeleagte>)data {
    
    NSDictionary * dataDic = [data getKeyAndObj];
    NSDictionary *conditionsDic = [dataDic dictionaryWithValuesForKeys:[[data class] getPrimaryKey]];
    return [self selectDataIsHaveForKey:data conditions:conditionsDic];
}

#pragma mark 查询数量方法

// 根据表名称查询对应表当前数据库数据总数
- (int)selectCountWithTableName:(NSString *)tableName {
    return [self selectCountWithTableName:tableName conditions:nil];
}

// 查询数据库对应条件的数量
- (int)selectCountWithTableName:(NSString *)tableName conditions:(NSDictionary *)conditions {
    
    NSString *sql = [FMDBSqlFactory getSelectTableSQLWithTable:tableName selectParameters:[NSArray arrayWithObject:@"count(*) as the_count"] conditions:conditions orderBy:nil limit:NSMakeRange(0, 0)];
    NSArray *array = [m_FMDBTool inTransactionExecuteQuery:sql ArgumentsInArray:nil];
    
    if (array==nil || array.count==0) {
        DMLog(@"查询符合条件的字段总数出错");
        return -1;
    }
    
    int count = [[(NSDictionary *)[array objectAtIndex:0] objectForKey:@"the_count"]intValue];
    
    return count;
}

#pragma mark - 数据库版本相关

// 获取当前数据库版本  默认为0
- (int)getUserVersion {
    NSString *sql = @"PRAGMA user_version";
    NSArray *a = [[FMDBTool sharedInstance]inTransactionExecuteQuery:sql ArgumentsInArray:nil];
    if (a == nil || a.count == 0) {
        return -1;
    }
    return [[a[0] objectForKey:@"user_version"] intValue];
}

// 设置当前数据库版本
- (BOOL)setUserVersion:(int)version {
    NSString *sql = [NSString stringWithFormat:@"PRAGMA user_version = %d",version];
    return [[FMDBTool sharedInstance]inTransactionExecuteUpdate:sql withArgumentsInArray:nil];
}

#pragma mark - 辅助方法

// 若data有不查询的字段，则去除需要查询的字段key
- (NSArray *)selectConditionsWithData:(id)data {
    NSArray *temp = [[data getKeyAndObj]allKeys];
    Class _class = [data class];
    if ([_class respondsToSelector:@selector(removeFromSelect)]) {
        NSMutableArray *keys = [NSMutableArray arrayWithArray:temp];
        [keys removeObjectsInArray:[_class removeFromSelect]];
        temp = keys;
    }
    return temp;
}

@end
