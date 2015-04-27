//
//  LocalStorage.m
//  UMC
//
//  Created by 悦讯科技  on 13-7-9.
//  Copyright (c) 2013年 shihui. All rights reserved.
//

#import "LocalStorage.h"

#import "Define.h"

@implementation LocalStorage

#pragma mark - File Url

// 获取Document路径
+ (NSString *)getDocumentUri {
    return [LocalStorage getFilesUriWithDirectoryName:NSDocumentDirectory];
}

// 获取Application Support目录地址
+ (NSString *)getApplicationSupportUri {
    return [LocalStorage getFilesUriWithDirectoryName:NSApplicationSupportDirectory];
}

// 获取Cache目录地址
+ (NSString *)getCacheUri {
    return [LocalStorage getFilesUriWithDirectoryName:NSCachesDirectory];
}

// 获取temp目录
+ (NSString *)getTempUri {
    return NSTemporaryDirectory();
}

+ (NSString *)getFilesUriWithDirectoryName:(NSSearchPathDirectory)directoryName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(directoryName, NSUserDomainMask, YES);
    NSString *applicationSupportDirectory = [paths objectAtIndex:0];
    return applicationSupportDirectory;
}

// 获取在Document下的文件路径
+ (NSString *)getFileDocumentUrlWithFileName:(NSString *)fileName {
    return [[self getDocumentUri] stringByAppendingPathComponent:fileName];
}

#pragma mark - write to file
#pragma mark dictionary

+ (NSDictionary *)getDictionaryFromFileWithFileName:(NSString *)fileName{
    return [self getDictionaryFromFileWithFilePath:[self getDocumentUri] fileName:fileName];
}
+ (NSDictionary *)getDictionaryFromFileWithFilePath:(NSString *)path fileName:(NSString *)fileName {
    
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:[path stringByAppendingPathComponent:fileName]];
    
    if (dic == nil) {
        dic = [NSDictionary dictionary];
    }
    return dic;
}

+ (BOOL)setDicitonaryToFileWithDictionary:(NSDictionary *)dic fileName:(NSString *)fileName {
    return [self setDicitonaryToFileWithDictionary:dic filePath:[self getDocumentUri] fileName:fileName];
}
+ (BOOL)setDicitonaryToFileWithDictionary:(NSDictionary *)dic filePath:(NSString *)path fileName:(NSString *)fileName {
    return [dic writeToFile:[path stringByAppendingPathComponent:fileName] atomically:YES];
}

#pragma mark array

+ (NSArray *)getArrayFromFileWithFileName:(NSString *)fileName {
    return [self getArrayFromFileWithFilePath:[self getDocumentUri] fileName:fileName];
}
+ (NSArray *)getArrayFromFileWithFilePath:(NSString *)path fileName:(NSString *)fileName {
    
    NSArray *array = [NSArray arrayWithContentsOfFile:[path stringByAppendingPathComponent:fileName]];
    
    if (array == nil) {
        array = [NSArray array];
    }
    return array;
}

+ (void)setArrayToFileWithArray:(NSArray *)arr fileName:(NSString *)fileName {
    [self setArrayToFileWithArray:arr filePath:[self getDocumentUri] fileName:fileName];
}
+ (void)setArrayToFileWithArray:(NSArray *)arr filePath:(NSString *)path fileName:(NSString *)fileName {
    [arr writeToFile:[path stringByAppendingPathComponent:fileName] atomically:YES];
}

#pragma mark data

+ (NSData *)getDataFromFileWithFileName:(NSString *)fileName {
    return [self getDataFromFileWithFilePath:[self getDocumentUri] fileName:fileName];
}
+ (NSData *)getDataFromFileWithFilePath:(NSString *)path fileName:(NSString *)fileName {
    
    NSData *data = [NSData dataWithContentsOfFile:[path stringByAppendingPathComponent:fileName]];
    if (data == nil) {
        data = [NSData data];
    }
    return data;
}

+ (void)setDataToFileWithData:(NSData *)data fileName:(NSString *)fileName {
    [self setDataToFileWithData:data filePath:[self getDocumentUri] fileName:fileName];
}
+ (void)setDataToFileWithData:(NSData *)data filePath:(NSString *)path fileName:(NSString *)fileName {
    [data writeToFile:[path stringByAppendingPathComponent:fileName] atomically:YES];
}

#pragma mark - NSKeyedUnarchiver

#pragma mark data

+ (NSData *)getDataFromArchiverWithFileName:(NSString *)fileName key:(NSString *)key {
    return [self getDataFromArchiverWithFilePath:[self getDocumentUri] fileName:fileName key:key];
}
+ (NSData *)getDataFromArchiverWithFilePath:(NSString *)path fileName:(NSString *)fileName key:(NSString *)key {
    NSData* data = [self getDataFromFileWithFilePath:path fileName:fileName];
    if (data.length == 0) {
        return data;
    }
    NSKeyedUnarchiver* unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    NSData *retData = [unarchiver decodeObjectForKey:key];
    [unarchiver finishDecoding];
    
    return retData;
}

+ (void)setDataToArchiverWithData:(NSData *)data fileName:(NSString *)fileName key:(NSString *)key {
    [self setDataToArchiverWithData:data filePath:[self getDocumentUri] fileName:fileName key:key];
}
+ (void)setDataToArchiverWithData:(NSData *)data filePath:(NSString *)path fileName:(NSString *)fileName key:(NSString *)key {
    NSMutableData *saveData = [[NSMutableData alloc]init];
	NSKeyedArchiver* archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:saveData];
	[archiver encodeObject:data forKey:key];
	[archiver finishEncoding];
    [self setDataToFileWithData:saveData filePath:path fileName:fileName];
}

#pragma mark array

+ (NSArray *)getArrayFromArchiverWithFileName:(NSString *)fileName key:(NSString *)key {
    return [self getArrayFromArchiverWithFilePath:[self getDocumentUri] fileName:fileName key:key];
}
+ (NSArray *)getArrayFromArchiverWithFilePath:(NSString *)path fileName:(NSString *)fileName key:(NSString *)key {
    NSData *data = [self getDataFromArchiverWithFilePath:path fileName:fileName key:key];
    if (data.length == 0) {
        return [NSArray array];
    }
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

+ (void)setArrayToArchiverWithArray:(NSArray *)arr fileName:(NSString *)fileName key:(NSString *)key {
    [self setArrayToArchiverWithArray:arr filePath:[self getDocumentUri] fileName:fileName key:key];
}
+ (void)setArrayToArchiverWithArray:(NSArray *)arr filePath:(NSString *)path fileName:(NSString *)fileName key:(NSString *)key {
    [self setDataToArchiverWithData:[NSKeyedArchiver archivedDataWithRootObject:arr] filePath:path fileName:fileName key:key];
}

#pragma mark dictionary

+ (NSDictionary *)getDictionaryFromArchiverWithFileName:(NSString *)fileName key:(NSString *)key {
    return [self getDictionaryFromArchiverWithFilePath:[self getDocumentUri] fileName:fileName key:key];
}
+ (NSDictionary *)getDictionaryFromArchiverWithFilePath:(NSString *)path fileName:(NSString *)fileName key:(NSString *)key {
    NSData *data = [self getDataFromArchiverWithFilePath:path fileName:fileName key:key];
    if (data.length == 0) {
        return [NSDictionary dictionary];
    }
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

+ (void)setDicitonaryToArchiverWithDictionary:(NSDictionary *)dic fileName:(NSString *)fileName key:(NSString *)key {
    [self setDicitonaryToArchiverWithDictionary:dic filePath:[self getDocumentUri] fileName:fileName key:key];
}
+ (void)setDicitonaryToArchiverWithDictionary:(NSDictionary *)dic filePath:(NSString *)path fileName:(NSString *)fileName key:(NSString *)key {
    [LocalStorage setDataToArchiverWithData:[NSKeyedArchiver archivedDataWithRootObject:dic] filePath:path fileName:fileName key:key];
}

#pragma mark - NSUserDefaults

+ (id)getObjectFromNSUserDefaultsWithKey:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

+ (void)setObjectFromNSUserDefaultsWithObject:(id)obj key:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setObject:obj forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)removeObjectFromNSUserDefaultsWithKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
}

#pragma mark - file

+ (BOOL)isExistFileWithDocFileName:(NSString *)fileName {
    return [self isExistFileWithFilePath:[self getDocumentUri] fileName:fileName];
}
+ (BOOL)moveFileWithFilePaht:(NSString *)path fileName:(NSString *)fileName toPath:(NSString *)toPath toFileName:(NSString *)toFileName {
    NSString *fullPath = [path stringByAppendingPathComponent:fileName];
    NSString *fullToPath = [toPath stringByAppendingPathComponent:toFileName];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    return [fm moveItemAtPath:fullPath toPath:fullToPath error:nil];
}
+ (BOOL)deleteFileWithDocFileName:(NSString *)fileName {
    return [self removeFileORDirWithFilePath:[self getDocumentUri] fileName:fileName];
}
+ (BOOL)removeFileORDirWithDocFileName:(NSString *)fileName {
    return [self removeFileORDirWithFilePath:[self getDocumentUri] fileName:fileName];
}

+ (BOOL)isExistFileWithFilePath:(NSString *)path fileName:(NSString *)fileName {
    NSFileManager *fm = [NSFileManager defaultManager];
    return [fm fileExistsAtPath:[path stringByAppendingPathComponent:fileName]];
}
+ (BOOL)copyFileWithFilePath:(NSString *)path fileName:(NSString *)fileName toPath:(NSString *)toPath toFileName:(NSString *)toFileName {
    NSFileManager *fm = [NSFileManager defaultManager];
    return [fm copyItemAtPath:[path stringByAppendingPathComponent:fileName] toPath:[toPath stringByAppendingPathComponent:toFileName] error:nil];
}
+ (BOOL)removeFileORDirWithFilePath:(NSString *)path fileName:(NSString *)fileName {
    NSFileManager *fm = [NSFileManager defaultManager];
    return [fm removeItemAtPath:[path stringByAppendingPathComponent:fileName] error:nil];
}

+ (unsigned long long)fileLengthWithFilePath:(NSString *)path fileName:(NSString *)fileName {
    if ([LocalStorage isExistFileWithFilePath:path fileName:fileName] == NO) {
        return 0;
    }
    
    NSFileManager *fm = [NSFileManager defaultManager];
    return [[fm attributesOfItemAtPath:[path stringByAppendingPathComponent:fileName] error:nil] fileSize];
}

#pragma mark - Dir

+ (BOOL)creatDirWithPath:(NSString *)dirPath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = NO;
    BOOL existed = [fileManager fileExistsAtPath:dirPath isDirectory:&isDir];
    
    if (existed != NO){
        // 存在就判断是否是文件夹，是就返回yes，不是就返回no
        if (isDir) {
            return YES;
        } else {
            return NO;
        }
    } else {
        // 不存在就创建
        return [fileManager createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

+ (BOOL)isExistDirWithDirPath:(NSString *)path {
    BOOL isDir = NO;
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL success = [fm fileExistsAtPath:path isDirectory:&isDir];
    
    if (success == NO) {
        return NO;
    }
    if (isDir == NO) {
        return NO;
    }
    return YES;
}

// 设置文件夹不会被同步
+ (BOOL)setIsExcludedFromBackupKeyWithDirPath:(NSString *)dirPath {
    NSError *error = nil;
    BOOL success = [[NSURL fileURLWithPath:dirPath] setResourceValue:[NSNumber numberWithBool:YES]
                                                              forKey:NSURLIsExcludedFromBackupKey
                                                               error:&error];
    if (error) {
        ERRORLog(@"%@",error);
    }
    return success;
}

/**
 *  查询文件夹下的所有文件名称
 *
 *  @param dirPath 文件夹目录
 *
 *  @return 文件列表，保存string的文件名
 */
+ (NSArray *)getAllFileWithPath:(NSString *)dirPath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    NSArray *fileList = nil;
    //fileList便是包含有该文件夹下所有文件的文件名及文件夹名的数组
    fileList = [fileManager contentsOfDirectoryAtPath:dirPath error:&error];
    
    return fileList;
}

/**
 *  清空文件夹下的所有文件
 *
 *  @param dirPath 文件夹目录
 *
 *  @return 是否所有操作都成功
 */
+ (BOOL)removeAllFileWithPath:(NSString *)dirPath {
    BOOL isSuccess = YES;
    NSArray *fileNames = [LocalStorage getAllFileWithPath:dirPath];
    for (NSString *fileName in fileNames) {
        isSuccess &= [LocalStorage removeFileORDirWithFilePath:fileName fileName:dirPath];
    }
    return isSuccess;
}

@end
