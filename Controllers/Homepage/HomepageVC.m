//
//  HomepageVC.m
//  WBdemo
//
//  Created by Nick on 15-4-1.
//  Copyright (c) 2015年 74td. All rights reserved.
//

#import "HomepageVC.h"

#import "SettingTool.h"
#import "AccountOAuthModel.h"
#import "LoginWithOAuthVC.h"
#import "AppDelegate.h"
#import "NetworkTool.h"

@interface HomepageVC ()

@end

@implementation HomepageVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (IBAction)logoutOnClick:(id)sender {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"_LoginOut" object:nil];
}

@end
