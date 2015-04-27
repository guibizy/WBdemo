//
//  MBProgressHUDTool.m
//  YueRecruit
//
//  Created by 悦讯 on 15/3/9.
//  Copyright (c) 2015年 悦讯科技. All rights reserved.
//

#import "MBProgressHUDTool.h"

#import "MBProgressHUD.h"
#import "SynthesizeSingleton.h"

@interface MBProgressHUDTool () <MBProgressHUDDelegate>

@property (nonatomic, strong) MBProgressHUD *HUD;

SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(MBProgressHUDTool);

@end

SYNTHESIZE_SINGLETON_FOR_CLASS_PROTOTYPE(MBProgressHUDTool);

@implementation MBProgressHUDTool

SYNTHESIZE_SINGLETON_FOR_CLASS(MBProgressHUDTool);

+ (void)showWithStatus:(NSString *)status {
    [MBProgressHUDTool showWithStatus:status needBackground:NO];
}

+ (void)showWithStatus:(NSString *)status needBackground:(BOOL)needBackground {
    [MBProgressHUDTool dismiss];
    
    MBProgressHUD *HUD = [MBProgressHUDTool getHUD];
    HUD.labelText = status;
//    HUD.customView = [MBProgressHUDTool makeAnimation];

    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MBProgressHUD_37x-Checkmark"]];
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.dimBackground = needBackground;
    
    [MBProgressHUDTool sharedInstance].HUD = HUD;
    [HUD show:YES];
}

+ (void)showSuccessWithStatus:(NSString *)status {
    [MBProgressHUDTool dismiss];
    
    MBProgressHUD *HUD = [MBProgressHUDTool getHUD];
    HUD.labelText = status;
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MBProgressHUD_37x-Checkmark"]];
    HUD.mode = MBProgressHUDModeCustomView;
    
    [HUD showAnimated:YES whileExecutingBlock:^{
        sleep(1.7);
    } completionBlock:^{
        [HUD removeFromSuperview];
    }];
}
+ (void)showErrorWithStatus:(NSString *)status {
    [MBProgressHUDTool dismiss];
    
    MBProgressHUD *HUD = [MBProgressHUDTool getHUD];
    HUD.labelText = status;
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MBProgressHUD_error"]];
    HUD.mode = MBProgressHUDModeCustomView;
    
    [HUD showAnimated:YES whileExecutingBlock:^{
        sleep(2.5);
    } completionBlock:^{
        [HUD removeFromSuperview];
    }];
}

+ (void)dismiss {
    if ([MBProgressHUDTool sharedInstance].HUD) {
        [[MBProgressHUDTool sharedInstance].HUD hide:YES];
        [MBProgressHUDTool sharedInstance].HUD = nil;
    }
}

#pragma mark -

+ (UIWindow *)getWindow {
    return ([[UIApplication sharedApplication] keyWindow]);
}

+ (MBProgressHUD *)getHUD {
    MBProgressHUD *HUD =[[MBProgressHUD alloc] initWithWindow:[MBProgressHUDTool getWindow]];
    HUD.delegate = [MBProgressHUDTool sharedInstance];
    
    [[MBProgressHUDTool getWindow] addSubview:HUD];
    
    return HUD;
}

#pragma mark - delegate

- (void)hudWasHidden:(MBProgressHUD *)hud {
    [hud removeFromSuperview];
    if (self.HUD == hud) {
        self.HUD = nil;
    }
}

@end
