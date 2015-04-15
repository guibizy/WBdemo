//
//  LocalStorage+Download.h
//  UMC
//
//  Created by 悦讯科技  on 13-11-30.
//  Copyright (c) 2013年 shihui. All rights reserved.
//

#import "LocalStorage.h"

@interface LocalStorage (Download)

+ (void)createDownloadDir;
+ (void)createDownloadDirWithUserName:(NSString*)userName;

+ (void)removeDownloadDir;
+ (void)removeDownloadDirWithUserName:(NSString*)userName;

#pragma mark -
+ (BOOL)saveDownloadWithFileName:(NSString *)fileName data:(NSData *)data;

+ (NSData *)readDownloadWithFileName:(NSString *)fileName;

+ (BOOL)isExistInDownloadWithFileName:(NSString *)fileName;

#pragma mark -

+ (NSString *)getDownloadPath;
+ (NSString *)getDownloadPathWithUserName:(NSString*)userName;

// 获取在Download下的文件路径
+ (NSString *)getFileDownloadUrlWithFileName:(NSString *)fileName;
+ (NSString *)getFileDownloadUrlWithUserName:(NSString *)userName fileName:(NSString *)fileName;

+ (BOOL)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName;
+ (BOOL)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName withUserName:(NSString*)userName;

+ (void)saveToTempImage:(UIImage *)tempImage WithName:(NSString *)imageName;

#pragma mark - tempUri
+ (NSString *)getTempFileFullUriWithFileName:(NSString*)fileName;

@end
