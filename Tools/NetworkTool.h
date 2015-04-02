//
//  NetworkTool.h
//  WBdemo
//
//  Created by Nick on 15-4-1.
//  Copyright (c) 2015年 74td. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^SuccessBlo)(NSDictionary * resultDic);
typedef void(^ErrorBlo)(NSError *error);


@interface NetworkTool : NSObject

//获取授权信息
+(void)getAccessTokenWithURL:(NSDictionary *)dic successBlock:(SuccessBlo)successBlock error:(ErrorBlo)errorBlock;
//取消授权信息
+(void)logoutOAuth2WithAccessToken:(NSString *)token successBlock:(SuccessBlo)successBlock error:(ErrorBlo)errorBlock;

//根据用户id获取用户信息
+(void)getUsersInfoWithId:(NSString *)token andUid:(NSString *)uid successBlock:(SuccessBlo)successBlock error:(ErrorBlo)errorBlock;

//获取当前登录用户及其所关注用户的最新微博
+(void)getUserHomeTimelineWhthAccessToken:(NSString *)token andCount:(NSInteger)count successBlock:(SuccessBlo)successBlock error:(ErrorBlo)errorBlock;

@end
