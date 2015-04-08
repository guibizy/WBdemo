//
//  AccountModel.m
//  WBdemo
//
//  Created by Nick on 15-4-8.
//  Copyright (c) 2015年 74td. All rights reserved.
//

#import "AccountModel.h"
#import "AccountUserModel.h"
#import "NSDate+Convenience.h"

@implementation AccountModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.created_at = @"";
        self._id = 0;
        self.mid = 0;
        self.idstr = 0;
        self.text = 0;
        self.source = 0;
        self.favorited = NO;
        self.truncated = NO;
        self.thumbnail_pic = @"";
        self.bmiddle_pic = @"";
        self.original_pic = @"";
        self.reposts_count = 0;
        self.comments_count = 0;
        self.attitudes_count = 0;
        self.user = [[AccountUserModel alloc]init];
        self.retweeted_status = [NSDictionary dictionary];
    }
    return self;
}
-(void)setDic:(NSDictionary *)dic{
    NSString *created = nil;
    SET_DIC_STRING_KEY(dic, created, @"created_at");
    if (created != nil) {
        self.created_at = [NSString stringWithFormat:@"%@",[NSDate dateFromStringInWeiBo:created]];
    }
    SET_DIC_LONG_LONG_KEY(dic, self._id, @"id");
    SET_DIC_LONG_LONG_KEY(dic, self.mid, @"mid");
    SET_DIC_STRING_KEY(dic, self.idstr, @"idstr");
    SET_DIC_STRING_KEY(dic, self.text, @"text");
    SET_DIC_STRING_KEY(dic, self.source, @"source");
    
    SET_DIC_BOOL_KEY(dic, self.favorited, @"favorited");
    SET_DIC_BOOL_KEY(dic, self.truncated, @"truncated");
    
    SET_DIC_STRING_KEY(dic, self.thumbnail_pic, @"thumbnail_pic");
    SET_DIC_STRING_KEY(dic, self.bmiddle_pic, @"bmiddle_pic");
    SET_DIC_STRING_KEY(dic, self.original_pic, @"original_pic");
    
    SET_DIC_INTERGET_KEY(dic, self.reposts_count, @"reposts_count");
    SET_DIC_INTERGET_KEY(dic, self.comments_count, @"comments_count");
    SET_DIC_INTERGET_KEY(dic, self.attitudes_count, @"attitudes_count");
    
    NSArray *picids = nil;
    SET_DIC_ARRAY_KEY(dic, picids, @"pic_urls");
    if (picids != nil && (NSNull *)picids != [NSNull null]) {
        NSMutableArray *picArr = [NSMutableArray arrayWithCapacity:picids.count];
        for (NSDictionary *picDic in picids) {
            NSString *onepic = [picDic objectForKey:@"thumbnail_pic"];
            [picArr addObject:onepic];
        }
        self.pic_ids = picArr;
    }else{
        self.pic_ids = nil;
    }
    
    SET_DIC_DICTIONARY_KEY(dic, self.retweeted_status, @"retweeted_status");
    
    NSDictionary *oneuser = nil;
    SET_DIC_DICTIONARY_KEY(dic, oneuser, @"user");
    if (oneuser != nil) {
        [self.user setDic:oneuser];
    }
}
+(void)initSetDic:(NSDictionary *)dic{
    [[self alloc]setDic:dic];
}
@end
