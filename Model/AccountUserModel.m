//
//  AccountUserModel.m
//  WBdemo
//
//  Created by Nick on 15-4-8.
//  Copyright (c) 2015年 74td. All rights reserved.
//

#import "AccountUserModel.h"

@implementation AccountUserModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self._id = 0;
        self.idstr = @"";
        self.screen_name = @"";
        self.name = @"";
        self.province = 0;
        self.city = 0;
        self.location = @"";
        self._description = @"";
        self.url = @"";
        self.profile_image_url = @"";
        self.profile_url = @"";
        self.domain = @"";
        self.weihao = @"";
        self.gender = @"";
        self.followers_count = 0;
        self.friends_count = 0;
        self.statuses_count = 0;
        self.favourites_count = 0;
        self.follow_me = NO;
    }
    return self;
}
-(void)setDic:(NSDictionary *)dic{
    SET_DIC_LONG_LONG_KEY(dic, self._id, @"id");
    SET_DIC_STRING_KEY(dic, self.idstr, @"idstr");
    SET_DIC_STRING_KEY(dic, self.screen_name, @"screen_name");
    SET_DIC_STRING_KEY(dic, self.name, @"name");
    SET_DIC_INTERGET_KEY(dic, self.province, @"province");
    SET_DIC_INTERGET_KEY(dic, self.city, @"city");
    
    SET_DIC_STRING_KEY(dic, self.location, @"location");
    SET_DIC_STRING_KEY(dic, self._description, @"description");
    SET_DIC_STRING_KEY(dic, self.url, @"url");
    SET_DIC_STRING_KEY(dic, self.profile_image_url, @"profile_image_url");
    SET_DIC_STRING_KEY(dic, self.profile_url, @"profile_url");
    SET_DIC_STRING_KEY(dic, self.domain, @"domain");
    SET_DIC_STRING_KEY(dic, self.weihao, @"weihao");
    SET_DIC_STRING_KEY(dic, self.gender, @"gender");
    
    SET_DIC_INTERGET_KEY(dic, self.followers_count, @"followers_count");
    SET_DIC_INTERGET_KEY(dic, self.friends_count, @"friends_count");
    SET_DIC_INTERGET_KEY(dic, self.statuses_count, @"statuses_count");
    SET_DIC_INTERGET_KEY(dic, self.favourites_count, @"favourites_count");
    
    SET_DIC_BOOL_KEY(dic, self.follow_me, @"follow_me");
}
+(void)initSetDic:(NSDictionary *)dic{
    [[self alloc]setDic:dic];
}
@end
