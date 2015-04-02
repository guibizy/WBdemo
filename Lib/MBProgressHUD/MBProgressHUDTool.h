//
//  MBProgressHUDTool.h
//  YueRecruit
//
//  Created by 悦讯 on 15/3/9.
//  Copyright (c) 2015年 悦讯科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MBProgressHUDTool : NSObject

+ (void)showWithStatus:(NSString *)status;
+ (void)showWithStatus:(NSString *)status needBackground:(BOOL)needBackground;

+ (void)showSuccessWithStatus:(NSString *)status;

+ (void)showErrorWithStatus:(NSString *)status;

+ (void)dismiss;

@end
