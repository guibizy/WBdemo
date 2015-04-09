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

#import "HomepageVC.h"
#import "MessageVC.h"
#import "SearchVC.h"
#import "HomeUserInfoVC.h"


@interface NavigationController ()

@end

@implementation NavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginout) name:@"_LoginOut" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"_LoginOut" object:nil];
}
-(void)loginI:(BOOL)status{
    if (status) {
        [self initTabBar];
        GetAppDelegate;
        [appDelegate.navController pushViewController:self.tabbar animated:YES];
    }
    else{
        LoginWithOAuthVC *login = [[LoginWithOAuthVC alloc]init];
        login.delegate = self;
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
-(void)loginLat{
    [self loginI:YES];
}

-(void)initTabBar{
    HomepageVC *homepage = [[HomepageVC alloc]init];
    MessageVC *message = [[MessageVC alloc]init];
    SearchVC *search = [[SearchVC alloc]init];
    HomeUserInfoVC *userinfo = [[HomeUserInfoVC alloc]init];
    
    NSMutableArray *controllers = [[NSMutableArray alloc]init];
    [controllers addObject:homepage];
    [controllers addObject:message];
    [controllers addObject:search];
    [controllers addObject:userinfo];
    
    
    self.tabbar = [[CustomTabBar alloc] init];
    self.tabbar.viewControllers = controllers;
    self.tabbar.selectedIndex = 0;
}
@end
