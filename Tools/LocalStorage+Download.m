//
//  LocalStorage+Download.m
//  UMC
//
//  Created by 悦讯科技  on 13-11-30.
//  Copyright (c) 2013年 shihui. All rights reserved.
//

#import "LocalStorage+Download.h"

@implementation LocalStorage (Download)

+ (void)createDownloadDir {
    NSString *path = [self getDownloadPath];
    [LocalStorage creatDirWithPath:path];
    [LocalStorage setIsExcludedFromBackupKeyWithDirPath:path];
}

+ (void)createDownloadDirWithUserName:(NSString*)userName {
    NSString *path = [self getDownloadPathWithUserName:userName];
    [LocalStorage creatDirWithPath:path];
    [LocalStorage setIsExcludedFromBackupKeyWithDirPath:path];
}

+ (void)removeDownloadDir {
    NSString *path = [self getDownloadPath];
    [LocalStorage removeFileORDirWithFilePath:path fileName:nil];
}

+ (void)removeDownloadDirWithUserName:(NSString*)userName {
    NSString *path = [self getDownloadPathWithUserName:userName];
    [LocalStorage removeFileORDirWithFilePath:path fileName:nil];
}

#pragma mark -

+ (BOOL)saveDownloadWithFileName:(NSString *)fileName data:(NSData *)data {
    if (fileName == nil || fileName.length == 0) {
        return NO;
    }
    
    NSString *path = [self getDownloadPath];
    NSString *filePath = [path stringByAppendingPathComponent:fileName];
    return [data writeToFile:filePath atomically:YES];
}

+ (NSData *)readDownloadWithFileName:(NSString *)fileName {
    if (fileName == nil || fileName.length == 0) {
        return nil;
    }
    NSString *path = [self getDownloadPath];
    NSString *filePath = [path stringByAppendingPathComponent:fileName];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    return data;
}

+ (BOOL)isExistInDownloadWithFileName:(NSString *)fileName {
    if (fileName == nil || fileName.length == 0) {
        return NO;
    }
    NSString *path = [self getDownloadPath];
    return [LocalStorage isExistFileWithFilePath:path fileName:fileName];
}

#pragma mark -

+ (NSString *)getDownloadPath {
    NSString *path = [self getApplicationSupportUri];
    path = [path stringByAppendingPathComponent:@"download"];
    return path;
}

+ (NSString *)getDownloadPathWithUserName:(NSString*)userName {
    NSString *path = [self getApplicationSupportUri];
    path = [path stringByAppendingPathComponent:userName];
    path = [path stringByAppendingPathComponent:@"download"];
    return path;
}

+ (NSString *)getFileDownloadUrlWithFileName:(NSString *)fileName {
    return [[self getDownloadPath] stringByAppendingPathComponent:fileName];
}

+ (NSString *)getFileDownloadUrlWithUserName:(NSString *)userName fileName:(NSString *)fileName {
    return [[self getDownloadPathWithUserName:userName] stringByAppendingPathComponent:fileName];
}

+ (BOOL)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName{
    NSData* imageData = UIImageJPEGRepresentation(tempImage,0.7);
    NSString *path = [self getDownloadPath];
    NSString* fullPathToFile = [path stringByAppendingPathComponent:imageName];
    return [imageData writeToFile:fullPathToFile atomically:NO];
}

+ (BOOL)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName withUserName:(NSString*)userName {
    NSData* imageData = UIImageJPEGRepresentation(tempImage,0.7);
    NSString *path = [self getDownloadPathWithUserName:userName];
    NSString* fullPathToFile = [path stringByAppendingPathComponent:imageName];
    return [imageData writeToFile:fullPathToFile atomically:NO];
}

+ (void)saveToTempImage:(UIImage *)tempImage WithName:(NSString *)imageName {
    NSData* imageData = UIImageJPEGRepresentation(tempImage,0.7);
    NSString *path = [self getTempUri];
    NSString* fullPathToFile = [path stringByAppendingPathComponent:imageName];
    [imageData writeToFile:fullPathToFile atomically:NO];
}

+ (NSString *)getTempFileFullUriWithFileName:(NSString*)fileName {
    return [[LocalStorage getTempUri] stringByAppendingPathComponent:fileName];
}

+ (void)createThumbImage:(UIImage *)image size:(CGSize )thumbSize percent:(float)percent toPath:(NSString *)thumbPath{
    CGSize imageSize = image.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat scaleFactor = 0.0;
    CGPoint thumbPoint = CGPointMake(0.0,0.0);
    CGFloat widthFactor = thumbSize.width / width;
    CGFloat heightFactor = thumbSize.height / height;
    if (widthFactor > heightFactor)  {
        scaleFactor = widthFactor;
    }
    else {
        scaleFactor = heightFactor;
    }
    CGFloat scaledWidth  = width * scaleFactor;
    CGFloat scaledHeight = height * scaleFactor;
    if (widthFactor > heightFactor)
    {
        thumbPoint.y = (thumbSize.height - scaledHeight) * 0.5;
    }
    else if (widthFactor < heightFactor)
    {
        thumbPoint.x = (thumbSize.width - scaledWidth) * 0.5;
    }
    UIGraphicsBeginImageContext(thumbSize);
    CGRect thumbRect = CGRectZero;
    thumbRect.origin = thumbPoint;
    thumbRect.size.width  = scaledWidth;
    thumbRect.size.height = scaledHeight;
    [image drawInRect:thumbRect];
    
    UIImage *thumbImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *thumbImageData = UIImageJPEGRepresentation(thumbImage, percent);
    [thumbImageData writeToFile:thumbPath atomically:NO];
}

@end
