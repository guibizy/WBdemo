//
//  CommentsShowModel.h
//  WBdemo
//
//  Created by Nick on 15-4-9.
//  Copyright (c) 2015年 74td. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AccountUserModel;
@class AccountModel;

@interface CommentsShowModel : NSObject

@property(copy,nonatomic) NSString *created_at;

@property(assign,nonatomic) long long _id;
@property(copy,nonatomic) NSString *mid;
@property(copy,nonatomic) NSString *idstr;

@property(copy,nonatomic) NSString *text;
@property(copy,nonatomic) NSString *source;

@property(strong,nonatomic)AccountUserModel *user;
@property(strong,nonatomic)AccountModel *status;


-(void)setDic:(NSDictionary *)dic;
@end
