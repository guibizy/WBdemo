//
//  LocalStorage+Document.h
//  YueRecruit
//
//  Created by 悦讯科技  on 15-2-26.
//  Copyright (c) 2015年 悦讯科技. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LocalStorage.h"

@interface LocalStorage (Document)

+ (void)createUserDocumentDirWithUserName:(NSString*)userName;

+ (void)removeUserDocumentDirWithUserName:(NSString*)userName;




+ (NSString *)getUserDocumentPathWithUserName:(NSString*)userName;

@end
