//
//  LocalStorage.h
//  UMC
//
//  Created by 悦讯科技  on 13-7-9.
//  Copyright (c) 2013年 shihui. All rights reserved.
//

#import <Foundation/Foundation.h>

// 本地文件的读写操作封装类
@interface LocalStorage : NSObject

#pragma mark - File Url

// 获取Document路径
+ (NSString *)getDocumentUri;

// 获取Application Support目录地址
+ (NSString *)getApplicationSupportUri;

// 获取Cache目录地址
+ (NSString *)getCacheUri;

/**
 *  获取temp目录
 *
 *  @return return value description
 */
+ (NSString *)getTempUri;

// 获取在Document下的文件路径
+ (NSString *)getFileDocumentUrlWithFileName:(NSString *)fileName;

#pragma mark - write to file

#pragma mark dictionary
+ (NSDictionary *)getDictionaryFromFileWithFileName:(NSString *)fileName;
+ (NSDictionary *)getDictionaryFromFileWithFilePath:(NSString *)path fileName:(NSString *)fileName;
+ (BOOL)setDicitonaryToFileWithDictionary:(NSDictionary *)dic fileName:(NSString *)fileName;
+ (BOOL)setDicitonaryToFileWithDictionary:(NSDictionary *)dic filePath:(NSString *)path fileName:(NSString *)fileName;

#pragma mark array
+ (NSArray *)getArrayFromFileWithFileName:(NSString *)fileName;
+ (NSArray *)getArrayFromFileWithFilePath:(NSString *)path fileName:(NSString *)fileName;
+ (void)setArrayToFileWithArray:(NSArray *)arr fileName:(NSString *)fileName;
+ (void)setArrayToFileWithArray:(NSArray *)arr filePath:(NSString *)path fileName:(NSString *)fileName;

#pragma mark data
+ (NSData *)getDataFromFileWithFileName:(NSString *)fileName;
+ (NSData *)getDataFromFileWithFilePath:(NSString *)path fileName:(NSString *)fileName;
+ (void)setDataToFileWithData:(NSData *)data fileName:(NSString *)fileName;
+ (void)setDataToFileWithData:(NSData *)data filePath:(NSString *)path fileName:(NSString *)fileName;

#pragma mark - NSKeyedUnarchiver

#pragma mark unit method
+ (NSData *)getDataFromArchiverWithFileName:(NSString *)fileName key:(NSString *)key;
+ (NSData *)getDataFromArchiverWithFilePath:(NSString *)path fileName:(NSString *)fileName key:(NSString *)key;
+ (void)setDataToArchiverWithData:(NSData *)data fileName:(NSString *)fileName key:(NSString *)key;
+ (void)setDataToArchiverWithData:(NSData *)data filePath:(NSString *)path fileName:(NSString *)fileName key:(NSString *)key;

#pragma mark array
+ (NSArray *)getArrayFromArchiverWithFileName:(NSString *)fileName key:(NSString *)key;
+ (NSArray *)getArrayFromArchiverWithFilePath:(NSString *)path fileName:(NSString *)fileName key:(NSString *)key;
+ (void)setArrayToArchiverWithArray:(NSArray *)arr fileName:(NSString *)fileName key:(NSString *)key;
+ (void)setArrayToArchiverWithArray:(NSArray *)arr filePath:(NSString *)path fileName:(NSString *)fileName key:(NSString *)key;

#pragma mark dictionary
+ (NSDictionary *)getDictionaryFromArchiverWithFileName:(NSString *)fileName key:(NSString *)key;
+ (NSDictionary *)getDictionaryFromArchiverWithFilePath:(NSString *)path fileName:(NSString *)fileName key:(NSString *)key;
+ (void)setDicitonaryToArchiverWithDictionary:(NSDictionary *)dic fileName:(NSString *)fileName key:(NSString *)key;
+ (void)setDicitonaryToArchiverWithDictionary:(NSDictionary *)dic filePath:(NSString *)path fileName:(NSString *)fileName key:(NSString *)key;

#pragma mark - NSUserDefaults

+ (id)getObjectFromNSUserDefaultsWithKey:(NSString *)key;
+ (void)setObjectFromNSUserDefaultsWithObject:(id)obj key:(NSString *)key;
+ (void)removeObjectFromNSUserDefaultsWithKey:(NSString *)key;

#pragma mark - file

+ (BOOL)isExistFileWithDocFileName:(NSString *)fileName;
+ (BOOL)moveFileWithFilePaht:(NSString *)path fileName:(NSString *)fileName toPath:(NSString *)toPath toFileName:(NSString *)toFileName;
+ (BOOL)deleteFileWithDocFileName:(NSString *)fileName;
+ (BOOL)removeFileORDirWithDocFileName:(NSString *)fileNam;

+ (BOOL)isExistFileWithFilePath:(NSString *)path fileName:(NSString *)fileName;
+ (BOOL)copyFileWithFilePath:(NSString *)path fileName:(NSString *)fileName toPath:(NSString *)toPath toFileName:(NSString *)toFileName;
+ (BOOL)removeFileORDirWithFilePath:(NSString *)path fileName:(NSString *)fileName;

+ (unsigned long long)fileLengthWithFilePath:(NSString *)path fileName:(NSString *)fileName;

#pragma mark - Dir

+ (BOOL)creatDirWithPath:(NSString *)dirPath;

+ (BOOL)isExistDirWithDirPath:(NSString *)path;

// 设置文件夹不会被同步
+ (BOOL)setIsExcludedFromBackupKeyWithDirPath:(NSString *)dirPath;

/**
 *  查询文件夹下的所有文件
 *
 *  @param dirPath 文件夹目录
 *
 *  @return 文件列表，保存string的文件名
 */
+ (NSArray *)getAllFileWithPath:(NSString *)dirPath;

/**
 *  清空文件夹下的所有文件
 *
 *  @param dirPath 文件夹目录
 *
 *  @return 是否所有操作都成功
 */
+ (BOOL)removeAllFileWithPath:(NSString *)dirPath;

@end
