//
//  CommentsShowModel.m
//  WBdemo
//
//  Created by Nick on 15-4-9.
//  Copyright (c) 2015年 74td. All rights reserved.
//

#import "CommentsShowModel.h"

#import "AccountModel.h"
#import "AccountUserModel.h"

@implementation CommentsShowModel



- (instancetype)init
{
    self = [super init];
    if (self) {
        self.created_at = @"";
        self._id = 0;
        self.mid = @"";
        self.idstr = @"";
        self.text = @"";
        self.source = @"";
        self.user = [[AccountUserModel alloc]init];
        self.status = [[AccountModel alloc]init];
    }
    return self;
}

-(void)setDic:(NSDictionary *)dic{
    SET_DIC_STRING_KEY(dic, self.created_at, @"created_at");
    SET_DIC_LONG_LONG_KEY(dic, self._id, @"id");
    SET_DIC_STRING_KEY(dic, self.idstr, @"idstr");
    SET_DIC_STRING_KEY(dic, self.mid, @"mid");
    SET_DIC_STRING_KEY(dic, self.text, @"text");
    SET_DIC_STRING_KEY(dic, self.source, @"source");
    
    NSDictionary *serdic = dic[@"user"];
    if (serdic != nil) {
        [self.user setDic:serdic];
    }
    
    NSDictionary *status = dic[@"status"];
    if (status != nil) {
        [self.status setDic:status];
    }
}

@end
