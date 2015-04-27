//
//  AccountModel.h
//  WBdemo
//
//  Created by Nick on 15-4-8.
//  Copyright (c) 2015年 74td. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AccountUserModel;

@interface AccountModel : NSObject

@property (copy, nonatomic) NSString *created_at;//微博创建时间
@property (assign, nonatomic) long long _id;//微博ID
@property (assign, nonatomic) long long mid;//微博MID
@property (copy, nonatomic) NSString *idstr;//字符串型的微博ID
@property (copy, nonatomic) NSString *text;//微博信息内容
@property (copy, nonatomic) NSString *source;//微博来源
@property (assign, nonatomic) BOOL favorited;//是否已收藏
@property (assign, nonatomic) BOOL truncated;//是否被截断

@property (copy, nonatomic) NSString *thumbnail_pic;//缩略图片地址
@property (copy, nonatomic) NSString *bmiddle_pic;//中等尺寸图片地址
@property (copy, nonatomic) NSString *original_pic;//原始图片地址

@property (assign, nonatomic) NSInteger reposts_count;//转发数
@property (assign, nonatomic) NSInteger comments_count;//评论数
@property (assign, nonatomic) NSInteger attitudes_count;//表态数

@property(strong, nonatomic) NSArray *pic_ids;

@property (strong, nonatomic) AccountUserModel *user;
@property (strong, nonatomic) NSDictionary *retweeted_status;

-(void)setDic:(NSDictionary *)dic;
+(void)initSetDic:(NSDictionary *)dic;

@end
