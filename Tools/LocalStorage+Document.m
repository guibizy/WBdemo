//
//  LocalStorage+Document.m
//  YueRecruit
//
//  Created by 悦讯科技  on 15-2-26.
//  Copyright (c) 2015年 悦讯科技. All rights reserved.
//

#import "LocalStorage+Document.h"

@implementation LocalStorage (Document)

+ (void)createUserDocumentDirWithUserName:(NSString*)userName {
    NSString *path = [self getUserDocumentPathWithUserName:userName];
    [LocalStorage creatDirWithPath:path];
    [LocalStorage setIsExcludedFromBackupKeyWithDirPath:path];
}

+ (void)removeUserDocumentDirWithUserName:(NSString*)userName {
    NSString *path = [self getUserDocumentPathWithUserName:userName];
    [LocalStorage removeFileORDirWithFilePath:path fileName:nil];
}


+ (NSString *)getUserDocumentPathWithUserName:(NSString*)userName {
    NSString *path = [self getDocumentUri];
    path = [path stringByAppendingPathComponent:userName];
    return path;
}

@end
