//
//  SettingTool.m
//  YueRecruit
//
//  Created by 悦讯科技  on 15-1-21.
//  Copyright (c) 2015年 悦讯科技. All rights reserved.
//

// 设置数据保存文件名称
#define LOCAL_STORAGE_NAME @"local_storage.set"

//#define UNIVERSITY_ARR  @"universityAr"
#define OAUTH_ACCESS_TOKEN @"access_token"
#define OAUTH_UUID @"UUID"

#import "SettingTool.h"

#import "SynthesizeSingleton.h"
#import "LocalStorage.h"

@interface SettingTool ()

SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(SettingTool);

@property (nonatomic, strong) NSMutableDictionary *settingDictionary;

@property (nonatomic, strong) NSArray *areaArray;
@property (nonatomic, strong) NSArray *announcementArray;
@property (nonatomic, strong) NSArray *MessagesearchArr;

@end

SYNTHESIZE_SINGLETON_FOR_CLASS_PROTOTYPE(SettingTool);

@implementation SettingTool

SYNTHESIZE_SINGLETON_FOR_CLASS(SettingTool);

- (instancetype)init
{
    self = [super init];
    if (self) {
        [SettingTool readSetting];
    }
    return self;
}

+(void)setAccessToken:(NSString *)accessToken{
    [[SettingTool sharedInstance].settingDictionary setObject:accessToken forKey:OAUTH_ACCESS_TOKEN];
    [SettingTool writeSetting];
}
+(NSString *)getAccessToken{
    @synchronized ([SettingTool sharedInstance]) {
        return [[SettingTool sharedInstance].settingDictionary objectForKey:OAUTH_ACCESS_TOKEN];
    }
}
+(void)setUuid:(NSString *)uuid{
    [[SettingTool sharedInstance].settingDictionary setObject:uuid forKey:OAUTH_UUID];
    [SettingTool writeSetting];
}
+(NSString *)getUuid{
    @synchronized ([SettingTool sharedInstance]) {
        return [[SettingTool sharedInstance].settingDictionary objectForKey:OAUTH_UUID];
    }
}
#pragma mark -

// 读取本地文件，初始化设置信息
+ (void)readSetting {
    [SettingTool sharedInstance].settingDictionary = [[NSMutableDictionary alloc]initWithDictionary:[LocalStorage getDictionaryFromFileWithFileName:LOCAL_STORAGE_NAME]];
}
// 写入本地文件，持久化保存设置信息
+ (void)writeSetting {
    BOOL success = [LocalStorage setDicitonaryToFileWithDictionary:[SettingTool sharedInstance].settingDictionary fileName:LOCAL_STORAGE_NAME];
    NSAssert(success, @"文件写入失败");
}

@end
