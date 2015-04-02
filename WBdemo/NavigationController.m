//
//  NavigationController.m
//  WBdemo
//
//  Created by Nick on 15-4-2.
//  Copyright (c) 2015年 74td. All rights reserved.
//

#import "NavigationController.h"

#import "HomepageVC.h"
#import "LoginWithOAuthVC.h"
#import "AppDelegate.h"
#import "NetworkTool.h"
#import "SettingTool.h"
#import "AccountOAuthModel.h"

@interface NavigationController ()

@end

@implementation NavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBarHidden = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginout) name:@"_LoginOut" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"_LoginOut" object:nil];
}
-(void)login:(BOOL)status{
    if (status) {
        HomepageVC *login = [[HomepageVC alloc]init];
        GetAppDelegate;
        [appDelegate.navController pushViewController:login animated:YES];
    }
    else{
        LoginWithOAuthVC *login = [[LoginWithOAuthVC alloc]init];
        GetAppDelegate;
        [appDelegate.navController pushViewController:login animated:YES];
    }
}
-(void)loginout{
    
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies])
    {
        [storage deleteCookie:cookie];
    }
    
    [AccountOAuthModel purgeSharedInstance];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"sessionCookies"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    [NetworkTool logoutOAuth2WithAccessToken:[SettingTool getAccessToken] successBlock:^(NSDictionary *resultDic) {
        if ([resultDic[@"result"]  isEqualToString:@"true"]) {
            LoginWithOAuthVC *login = [[LoginWithOAuthVC alloc]init];
            GetAppDelegate;
            [appDelegate.navController pushViewController:login animated:YES];
        }
    } error:^(NSError *error) {
        
    }];
}
@end
