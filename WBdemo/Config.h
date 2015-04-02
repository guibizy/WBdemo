//
//  Config.h
//  WBdemo
//
//  Created by Nick on 15-4-1.
//  Copyright (c) 2015年 74td. All rights reserved.
//

#ifndef WBdemo_Config_h
#define WBdemo_Config_h


#define HTTP_URL @"https://api.weibo.com"

#define GET_OAuth2 [NSString stringWithFormat:@"%@/oauth2/authorize", HTTP_URL]

#define GET_access_token [NSString stringWithFormat:@"%@/oauth2/access_token", HTTP_URL]

#define GET_revokeoauth2 [NSString stringWithFormat:@"%@/oauth2/revokeoauth2", HTTP_URL]

#define GET_get_token_info [NSString stringWithFormat:@"%@/oauth2/get_token_info", HTTP_URL]

//获取当前登录用户及其所关注用户的最新微博
#define GET_statuses_home_timeline [NSString stringWithFormat:@"%@/2/statuses/home_timeline.json", HTTP_URL]

//通过id获取用户信息
#define GET_USERS_INFO_UID [NSString stringWithFormat:@"%@/2/users/show.json", HTTP_URL]

//获取当前登录用户及其所关注用户的最新微博的ID
#define GET_FRIENDS_TIMELINE [NSString stringWithFormat:@"%@/2/statuses/friends_timeline/ids.json", HTTP_URL]


#endif
