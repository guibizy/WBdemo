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

+(void)getUsersInfoWithId:(NSString *)token andUid:(long long)uid successBlock:(SuccessBlo)successBlock error:(ErrorBlo)errorBlock{
    NSDictionary *dic = @{@"access_token":token,
                          @"uid":@(uid)};
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

+(void)getCommentsShowWhthAccessTokenAndID:(NSString *)token
                                     andID:(long long)_id
                                  andCount:(NSInteger)homeCount
                                   andPage:(NSInteger)page
                              successBlock:(SuccessBlo)successBlock error:(ErrorBlo)errorBlock{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:token forKey:@"access_token"];
    [dic setValue:@(_id) forKey:@"id"];
    if (homeCount > 0) {
        [dic setValue:@(homeCount) forKey:@"count"];
    }
    if (page > 0) {
        [dic setValue:@(page) forKey:@"page"];
    }
    [NetworkTool getWithURL:GET_COMMENTS_SHOW parameters:dic successBlock:successBlock error:errorBlock];
}

/**
 *  评论一条微博
 *
 *  @return return value description
 */
+(void)commentsCreate:(NSString *)token andID:(long long)_id andContent:(NSString *)comment successBlock:(SuccessBlo)successBlock error:(ErrorBlo)errorBlock{
    NSDictionary *dic = @{@"access_token":token,
                          @"id":@(_id),
                          @"comment":comment};
    [NetworkTool postWithURL:wb_PINGLUN parameters:dic successBlock:successBlock error:errorBlock];
}
/**
 *  删除一条评论
 *
 *  @return return value description
 */
+(void)commentsDestroy:(NSString *)token andID:(long long)cid successBlock:(SuccessBlo)successBlock error:(ErrorBlo)errorBlock{
    NSDictionary *dic = @{@"access_token":token,
                          @"cid":@(cid)};
    [NetworkTool postWithURL:wb_PINGLUN_destroy parameters:dic successBlock:successBlock error:errorBlock];
}

/**
 *  回复一条评论
 *
 *  @return return value description
 */
+(void)commentsReply:(NSString *)token
               andID:(long long)cid
             andwbID:(long long)_id
          andComment:(NSString *)comment
  andwithout_mention:(NSInteger)without_mention
      andcomment_ori:(NSInteger)comment_ori
        successBlock:(SuccessBlo)successBlock error:(ErrorBlo)errorBlock{
    NSDictionary *dic = @{@"access_token":token,
                          @"cid":@(cid),
                          @"id":@(_id),
                          @"comment":comment,
                          @"without_mention":@(without_mention),
                          @"comment_ori":@(comment_ori)};
    [NetworkTool postWithURL:wb_PINGLUN_reply parameters:dic successBlock:successBlock error:errorBlock];
}

/**
 *  转发一条wb
 *
 *  @return return value description
 */
+(void)statusesRepost:(NSString *)token
              andwbID:(long long)_id
            andStatus:(NSString *)status
        andis_comment:(NSInteger)is_comment
         successBlock:(SuccessBlo)successBlock error:(ErrorBlo)errorBlock{
    NSDictionary *dic = @{@"access_token":token,
                          @"id":@(_id),
                          @"status":status,
                          @"is_comment":@(is_comment)};
    [NetworkTool postWithURL:wb_ZHUANFA parameters:dic successBlock:successBlock error:errorBlock];
}
/**
 *  删除一条wb
 *
 *  @return return value description
 */
+(void)statusesDestroy:(NSString *)token
               andwbID:(long long)_id
          successBlock:(SuccessBlo)successBlock error:(ErrorBlo)errorBlock{
    NSDictionary *dic = @{@"access_token":token,
                          @"id":@(_id)};
    [NetworkTool postWithURL:wb_PINGLUN_destroy parameters:dic successBlock:successBlock error:errorBlock];
}


//发布一条微博
+(void)publishWB:(NSString *)token andwbText:(NSString *)status successBlock:(SuccessBlo)successBlock error:(ErrorBlo)errorBlock{
    NSDictionary *dic = @{@"access_token":token,@"status":status};
    [NetworkTool postWithURL:wb_FABU parameters:dic successBlock:successBlock error:errorBlock];
}

//发布一条有图片微博
+(void)publishWBWithData:(NSString *)token andwbText:(NSString *)status andDataArry:(NSArray *)photoArray successBlock:(SuccessBlo)successBlock error:(ErrorBlo)errorBlock{
    NSDictionary *dic = @{@"access_token":token,@"status":status};
    // 1.创建请求管理对象
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    // 2.发送请求
    [mgr POST:wb_FABU_pic parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> totalFormData) {
        for (IWFormData *formData in photoArray) {
            [totalFormData appendPartWithFileData:formData.data name:formData.name fileName:formData.filename mimeType:formData.mimeType];
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (successBlock) {
            successBlock(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    }];
}
//@
+(void)getMinePinglun:(NSString *)token successBlock:(SuccessBlo)successBlock error:(ErrorBlo)errorBlock{
    NSDictionary *dic = @{@"access_token":token};
    [NetworkTool getWithURL:wb_mypinglun parameters:dic successBlock:successBlock error:errorBlock];
}

//
+(void)getMinePinglunToMe:(NSString *)token successBlock:(SuccessBlo)successBlock error:(ErrorBlo)errorBlock{
    NSDictionary *dic = @{@"access_token":token};
    [NetworkTool getWithURL:wb_mypinglun_to_me parameters:dic successBlock:successBlock error:errorBlock];
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

@implementation IWFormData


@end
