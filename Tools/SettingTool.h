//
//  SettingTool.h
//  YueRecruit
//
//  Created by 悦讯科技  on 15-1-21.
//  Copyright (c) 2015年 悦讯科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SettingTool : NSObject

+(void)setAccessToken:(NSString *)accessToken;
+(NSString *)getAccessToken;

+(void)setUuid:(NSString *)uuid;
+(NSString *)getUuid;

@end
