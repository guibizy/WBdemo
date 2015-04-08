//
//  NetworkTool.m
//  WBdemo
//
//  Created by Nick on 15-4-1.
//  Copyright (c) 2015年 74td. All rights reserved.
//

#import "NetworkTool.h"

#import "AFNetworking.h"
#import "Config.h"

@implementation NetworkTool

+(void)getAccessTokenWithURL:(NSDictionary *)dic successBlock:(SuccessBlo)successBlock error:(ErrorBlo)errorBlock{
    [NetworkTool postWithURL:GET_access_token parameters:dic successBlock:successBlock error:errorBlock];
}


+(void)logoutOAuth2WithAccessToken:(NSString *)token successBlock:(SuccessBlo)successBlock error:(ErrorBlo)errorBlock{
    NSDictionary * dic = @{@"access_token":token};
    [NetworkTool postWithURL:GET_revokeoauth2 parameters:dic successBlock:successBlock error:errorBlock];
}

+(void)getUsersInfoWithId:(NSString *)token andUid:(NSString *)uid successBlock:(SuccessBlo)successBlock error:(ErrorBlo)errorBlock{
    NSDictionary *dic = @{@"access_token":token,
                          @"uid":uid};
    [NetworkTool getWithURL:GET_USERS_INFO_UID parameters:dic successBlock:successBlock error:errorBlock];
}

+(void)getUserHomeTimelineWhthAccessToken:(NSString *)token andCount:(NSInteger)homeCount
                            andPage:(NSInteger)page successBlock:(SuccessBlo)successBlock error:(ErrorBlo)errorBlock{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:token forKey:@"access_token"];
    if (homeCount > 0) {
        [dic setValue:@(homeCount) forKey:@"count"];
    }
    if (page > 0) {
        [dic setValue:@(page) forKey:@"page"];
    }
    [NetworkTool getWithURL:GET_statuses_home_timeline parameters:dic successBlock:successBlock error:errorBlock];
}

#pragma mark -------
+ (void)getWithURL:(NSString *)url parameters:(NSDictionary *)par successBlock:(SuccessBlo)successBlock error:(ErrorBlo)errorBlock {
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager GET:url parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            DMLog(@"%@",responseObject);
            successBlock(responseObject);
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            errorBlock(error);
        });
    }];
}
+ (void)postWithURL:(NSString *)url parameters:(NSDictionary *)par successBlock:(SuccessBlo)successBlock error:(ErrorBlo)errorBlock {
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager POST:url parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            DMLog(@"%@",responseObject);
            
            successBlock(responseObject);
            if ([url isEqualToString:GET_access_token]) {
                NSData *cookiesData = [NSKeyedArchiver archivedDataWithRootObject: [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]];
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:cookiesData forKey: @"sessionCookies"];
                [defaults synchronize];
            }
            
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([url isEqualToString:GET_access_token]) {
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"sessionCookies"];
            }
            errorBlock(error);
        });
    }];
}
@end
