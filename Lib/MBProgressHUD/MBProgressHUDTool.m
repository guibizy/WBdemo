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

#pragma mark - 自增动画效果 by huds
+ (UIImageView *)makeAnimation {
    //连续动画:一个接一个地显示一系列的图像
    NSArray *myImages = [NSArray arrayWithObjects:
                         [UIImage imageNamed:@"loading_animation_1"],
                         [UIImage imageNamed:@"loading_animation_2"],
                         [UIImage imageNamed:@"loading_animation_3"],
                         [UIImage imageNamed:@"loading_animation_4"],
                         [UIImage imageNamed:@"loading_animation_5"],
                         [UIImage imageNamed:@"loading_animation_6"],
                         [UIImage imageNamed:@"loading_animation_7"],
                         [UIImage imageNamed:@"loading_animation_8"],
                         [UIImage imageNamed:@"loading_animation_9"],
                         [UIImage imageNamed:@"loading_animation_10"],
                         [UIImage imageNamed:@"loading_animation_11"],
                         [UIImage imageNamed:@"loading_animation_12"],
                         [UIImage imageNamed:@"loading_animation_13"],
                         [UIImage imageNamed:@"loading_animation_14"],nil];
    
    UIImageView *myAnimatedView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 63)];
    myAnimatedView.animationImages = myImages; //animationImages属性返回一个存放动画图片的数组
    myAnimatedView.animationDuration = 1.0; //浏览整个图片一次所用的时间
    myAnimatedView.animationRepeatCount = 0; // 0 = loops forever 动画重复次数
    [myAnimatedView startAnimating];
    return myAnimatedView;
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
