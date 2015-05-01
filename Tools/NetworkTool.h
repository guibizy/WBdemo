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
+(void)getAccessTokenWithURL:(NSDictionary *)dic
                successBlock:(SuccessBlo)successBlock error:(ErrorBlo)errorBlock;

//取消授权信息
+(void)logoutOAuth2WithAccessToken:(NSString *)token
                      successBlock:(SuccessBlo)successBlock error:(ErrorBlo)errorBlock;

//根据用户id获取用户信息
+(void)getUsersInfoWithId:(NSString *)token
                   andUid:(long long)uid
             successBlock:(SuccessBlo)successBlock error:(ErrorBlo)errorBlock;

//获取当前登录用户及其所关注用户的最新微博
+(void)getUserHomeTimelineWhthAccessToken:(NSString *)token
                                 andCount:(NSInteger)homeCount
                                  andPage:(NSInteger)page
                             successBlock:(SuccessBlo)successBlock error:(ErrorBlo)errorBlock;

//根据微博ID返回某条微博的评论列表
/*
 只返回授权用户的评论，非授权用户的评论将不返回；
 使用官方移动SDK调用，可多返回30%的非授权用户的评论；
 */
+(void)getCommentsShowWhthAccessTokenAndID:(NSString *)token
                                     andID:(long long)_id
                                 andCount:(NSInteger)homeCount
                                  andPage:(NSInteger)page
                             successBlock:(SuccessBlo)successBlock error:(ErrorBlo)errorBlock;
/**
 *  评论一条微博
 */
+(void)commentsCreate:(NSString *)token
                andID:(long long)_id
             andContent:(NSString *)comment
         successBlock:(SuccessBlo)successBlock error:(ErrorBlo)errorBlock;
/**
 *  删除一条评论
 */
+(void)commentsDestroy:(NSString *)token
                andID:(long long)cid
         successBlock:(SuccessBlo)successBlock error:(ErrorBlo)errorBlock;
/**
 *  回复一条评论
 without_mention	false	int	回复中是否自动加入“回复@用户名”，0：是、1：否，默认为0。
 comment_ori	false	int	当评论转发微博时，是否评论给原微博，0：否、1：是，默认为0。
 */
+(void)commentsReply:(NSString *)token
                 andID:(long long)cid
               andwbID:(long long)_id
            andComment:(NSString *)comment
    andwithout_mention:(NSInteger )without_mention
        andcomment_ori:(NSInteger )comment_ori
          successBlock:(SuccessBlo)successBlock error:(ErrorBlo)errorBlock;

/**
 *  转发一条微博
 source	false	string	采用OAuth授权方式不需要此参数，其他授权方式为必填参数，数值为应用的AppKey。
 access_token	false	string	采用OAuth授权方式为必填参数，其他授权方式不需要此参数，OAuth授权后获得。
 id	true	int64	要转发的微博ID。
 status	false	string	添加的转发文本，必须做URLencode，内容不超过140个汉字，不填则默认为“转发微博”。
 is_comment	false	int	是否在转发的同时发表评论，0：否、1：评论给当前微博、2：评论给原微博、3：都评论，默认为0 。
 rip	false	string	开发者上报的操作用户真实IP，形如：211.156.0.1
 */
+(void)statusesRepost:(NSString *)token
             andwbID:(long long)_id
          andStatus:(NSString *)status
        andis_comment:(NSInteger )is_comment
        successBlock:(SuccessBlo)successBlock error:(ErrorBlo)errorBlock;
/**
 *  删除一条微博
 */
+(void)statusesDestroy:(NSString *)token
              andwbID:(long long)_id
         successBlock:(SuccessBlo)successBlock error:(ErrorBlo)errorBlock;
//发布一条微博
+(void)publishWB:(NSString *)token
               andwbText:(NSString *)status
          successBlock:(SuccessBlo)successBlock error:(ErrorBlo)errorBlock;
//发布一条有图片微博
+(void)publishWBWithData:(NSString *)token
               andwbText:(NSString *)status
             andDataArry:(NSArray *)photoArray
    successBlock:(SuccessBlo)successBlock error:(ErrorBlo)errorBlock;
@end




/**
 *  用来封装文件数据的模型
 */
@interface IWFormData : NSObject
/**
 *  文件数据
 */
@property (nonatomic, strong) NSData *data;

/**
 *  参数名
 */
@property (nonatomic, copy) NSString *name;

/**
 *  文件名
 */
@property (nonatomic, copy) NSString *filename;

/**
 *  文件类型
 */
@property (nonatomic, copy) NSString *mimeType;
@end