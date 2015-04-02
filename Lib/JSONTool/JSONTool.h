//
//  JSONTool.h
//  chaozhou
//
//  Created by 悦讯科技  on 13-7-12.
//  Copyright (c) 2013年 悦讯科技 . All rights reserved.
//


// --- mode 使用

#import <Foundation/Foundation.h>

@protocol JSON2DataDelegate <NSObject>

- (void)setJSONDic:(NSDictionary *)dic;

- (NSDictionary *)getDicForJson;

@end

@interface JSONTool : NSObject

#pragma mark - to data

// processing 块，把json解析后的数据进行处理解析，返回实际数据内容进行数据填充
+ (NSArray *)JSON2DataArrayWithJSON:(NSData *)jsonData dataClass:(Class)dataClass processing:(NSArray *(^)(id request))processing;

// processing 块，把json解析后的数据进行处理解析，返回实际数据内容进行数据填充
+ (id)JSON2DataWithJSON:(NSData *)jsonData dataClass:(Class)dataClass processing:(NSDictionary *(^)(id request))processing;

+ (id)JSON2IDWithJSON:(NSData *)jsonData;

#pragma mark - to string

+ (NSString *)idToJSONWithModel:(id<JSON2DataDelegate>)model;

// id 内容为 数组或字典
+ (NSString *)idToJSONWithID:(id)data;

+ (NSString *)modelArrayToJSON:(NSArray *)array;

@end
