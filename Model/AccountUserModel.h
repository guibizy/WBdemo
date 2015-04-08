//
//  AccountUserModel.h
//  WBdemo
//
//  Created by Nick on 15-4-8.
//  Copyright (c) 2015年 74td. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccountUserModel : NSObject

@property(assign, nonatomic) long long _id;//用户UID
@property(copy, nonatomic) NSString *idstr;//字符串型的用户UID
@property(copy, nonatomic) NSString *screen_name;//用户昵称
@property(copy, nonatomic) NSString *name;//友好显示名称
@property(assign, nonatomic) NSInteger province;//用户所在省级ID
@property(assign, nonatomic) NSInteger city;//用户所在城市ID
@property(copy, nonatomic) NSString *location;//用户所在地
@property(copy, nonatomic) NSString *_description;//用户个人描述
@property(copy, nonatomic) NSString *url;//用户博客地址
@property(copy, nonatomic) NSString *profile_image_url;//用户头像地址
//@property(copy, nonatomic) NSString * coverImageUrl;
//@property(copy, nonatomic) NSString * coverImageForPhoneUrl;
@property(copy, nonatomic) NSString *profile_url ;// 	用户的微博统一URL地址
@property(copy, nonatomic) NSString *domain;//用户的个性化域名
@property(copy, nonatomic) NSString *weihao;
@property(copy, nonatomic) NSString *gender;
@property(assign, nonatomic) NSInteger followers_count;//粉丝数
@property(assign, nonatomic) NSInteger friends_count;//关注数
//@property(copy, nonatomic) NSString * pageFriendsCount;
@property(assign, nonatomic) NSInteger statuses_count;//微博数
@property(assign, nonatomic) NSInteger favourites_count;//收藏数
@property(readwrite, assign, nonatomic) BOOL follow_me;//该用户是否关注当前登录用户

-(void)setDic:(NSDictionary *)dic;
+(void)initSetDic:(NSDictionary *)dic;

@end
