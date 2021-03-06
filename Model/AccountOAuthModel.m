//
//  AccountOAuthModel.m
//  WBdemo
//
//  Created by Nick on 15-4-2.
//  Copyright (c) 2015年 74td. All rights reserved.
//

#import "AccountOAuthModel.h"

#import "AccountUserModel.h"
#import "NetworkTool.h"
#import "SettingTool.h"

SYNTHESIZE_SINGLETON_FOR_CLASS_PROTOTYPE(AccountOAuthModel);

@implementation AccountOAuthModel

SYNTHESIZE_SINGLETON_FOR_CLASS(AccountOAuthModel);

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.uid = 0;
        self.expires_in = 0;
        self.access_token = @"";
        self.create_at = 0;
        self.user = [[AccountUserModel alloc]init];
    }
    return self;
}

+(void)initSetDic:(NSDictionary *)dic{
    [[self alloc]setDic:dic];

}
-(void)setDic:(NSDictionary *)dic{
    SET_DIC_LONG_LONG_KEY(dic, self.uid, @"uid");
    SET_DIC_LONG_LONG_KEY(dic, self.expires_in, @"expires_in");
    SET_DIC_STRING_KEY(dic, self.access_token, @"access_token");
    SET_DIC_LONG_LONG_KEY(dic, self.create_at, @"create_at");
    
    NSDictionary *userdic = dic;
    if (userdic != nil) {
        [self.user setDic:userdic];
    }
}

+(void)refreshPersonInfo{
    [NetworkTool getUsersInfoWithId:[SettingTool getAccessToken] andUid:[[SettingTool getUuid] longLongValue] successBlock:^(NSDictionary *resultDic) {
        [[AccountOAuthModel sharedInstance] setDic:resultDic];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshMy" object:nil];
    } error:^(NSError *error) {
    }];
}

@end
