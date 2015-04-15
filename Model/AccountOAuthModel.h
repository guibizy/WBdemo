//
//  AccountOAuthModel.h
//  WBdemo
//
//  Created by Nick on 15-4-2.
//  Copyright (c) 2015年 74td. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SynthesizeSingleton.h"

@class AccountUserModel;

@interface AccountOAuthModel : NSObject

//返回授权信息时
@property(assign,nonatomic) long long uid;   //授权用户的uid
@property(assign,nonatomic) long long expires_in;//生命周期
@property(copy,nonatomic) NSString *access_token;//access——token

//获取授权信息时
@property(assign,nonatomic) long long create_at;//生命周期
@property(strong,nonatomic) AccountUserModel *user;

SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(AccountOAuthModel);

-(void)setDic:(NSDictionary *)dic;
+(void)initSetDic:(NSDictionary *)dic;

@end
