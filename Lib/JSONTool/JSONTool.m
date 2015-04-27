//
//  JSONTool.m
//  chaozhou
//
//  Created by 悦讯科技  on 13-7-12.
//  Copyright (c) 2013年 悦讯科技 . All rights reserved.
//

#import "JSONTool.h"

#import "Define.h"

@implementation JSONTool

#pragma mark - to data

// processing 块，把json解析后的数据进行处理解析，返回实际数据内容进行数据填充
+ (NSArray *)JSON2DataArrayWithJSON:(NSData *)jsonData
                          dataClass:(Class)dataClass
                         processing:(NSArray *(^)(id request))processing {
    
    if (![dataClass instancesRespondToSelector:@selector(setJSONDic:)]) {
        ERRORLog(@"class is not have setJSONDic: method");
        return nil;
    }
    
    NSError *error = nil;
    id request = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    
    if (error != nil) {
        ERRORLog(@"%@\nJSON2DataArrayWithJSON ： %@",[[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding],[error localizedDescription]);
        return nil;
    }
    
    // 是否需要经过处理，若不需要处理则直接使用数据，若需要经过处理则使用处理后的返回值
    NSArray *array = request;
    if (processing != nil) {
        array = processing(request);
    }
    
    // 处理后的
    if (![array isKindOfClass:[NSArray class]] || ![array isKindOfClass:[NSMutableArray class]]) {
        ERRORLog(@"获取json数据无法解析\nid:%@\narray:%@\nrequese:%@",request,array,[[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding]);
        return nil;
    }
    
    NSMutableArray *dataArray = [NSMutableArray array];
    id obj = [[dataClass alloc]init];
    if ([obj conformsToProtocol:@protocol(JSON2DataDelegate)] && [obj respondsToSelector:@selector(setJSONDic:)]) {
        for (NSDictionary *dic in array) {
            id<JSON2DataDelegate> data = [[dataClass alloc]init];
            [data setJSONDic:dic];
            
            [dataArray addObject:data];
        }
    } else {
        ERRORLog(@"%@ 不支持JSON2DataDelegate",dataClass);
    }
    return dataArray;
}

// processing 块，把json解析后的数据进行处理解析，返回实际数据内容进行数据填充
+ (id)JSON2DataWithJSON:(NSData *)jsonData dataClass:(Class)dataClass processing:(NSDictionary *(^)(id request))processing {
    
    if (![dataClass instancesRespondToSelector:@selector(setJSONDic:)]) {
        ERRORLog(@"class is not have setJSONDic: method");
        return nil;
    }
    
    NSError *error = nil;
    id request = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    
    if (error != nil) {
        ERRORLog(@"%@",[error localizedDescription]);
        return nil;
    }
    
    // 是否需要经过处理，若不需要处理则直接使用数据，若需要经过处理则使用处理后的返回值
    NSDictionary *dictionary = request;
    if (processing != nil) {
        dictionary = processing(request);
    }
    
    id<JSON2DataDelegate> data = [[dataClass alloc]init];
    if ([data conformsToProtocol:@protocol(JSON2DataDelegate)] && [data respondsToSelector:@selector(setJSONDic:)]) {
        [data setJSONDic:dictionary];
    } else {
        ERRORLog(@"%@ 不支持JSON2DataDelegate",dataClass);
        data = nil;
    }
    return data;
}

+ (id)JSON2IDWithJSON:(NSData *)jsonData {
    NSError *error = nil;
    id request = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    if (error != nil) {
        ERRORLog(@"%@\n%@",[error localizedDescription],[[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding]);
        return nil;
    }
    return request;
}

#pragma mark - to string

+ (NSString *)idToJSONWithModel:(id<JSON2DataDelegate>)model {
    return [self idToJSONWithID:[model getDicForJson]];
}

+ (NSString *)idToJSONWithID:(id)data {
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:0 error:&error]; // NSJSONWritingPrettyPrinted 增加空格，使json可读性更高
    if (error != nil) {
        ERRORLog(@"%@",[error localizedDescription]);
        return nil;
    }
    return [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
}

+ (NSString *)modelArrayToJSON:(NSArray *)array {
    NSMutableArray *tempArr = [NSMutableArray array];
    
    for (id<JSON2DataDelegate> data in array) {
        [tempArr addObject:[data getDicForJson]];
    }
    
    return [self idToJSONWithID:tempArr];
}

@end
