//
//  LoginWithOAuthVC.m
//  WBdemo
//
//  Created by Nick on 15-4-1.
//  Copyright (c) 2015年 74td. All rights reserved.
//

#import "LoginWithOAuthVC.h"

#import "AFNetworking.h"
#import "WeiboSDK.h"
#import "Config.h"
#import "NetworkTool.h"
#import "MBProgressHUDTool.h"
#import "HomepageVC.h"
#import "SettingTool.h"
#import "AccountOAuthModel.h"

@interface LoginWithOAuthVC ()<UIWebViewDelegate>

@end

@implementation LoginWithOAuthVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIWebView *webview = [[UIWebView alloc]init];
    webview.frame = self.view.bounds;
    webview.delegate = self;
    [self.view addSubview:webview];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?client_id=%@&redirect_uri=%@",GET_OAuth2,gAppKey,gRedirectURI]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webview loadRequest:request];
}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    NSString *urlStr = request.URL.absoluteString;
    NSRange range = [urlStr rangeOfString:@"code="];
    if (range.location != NSNotFound) {
        NSInteger loc = range.location + range.length;
        NSString *code = [urlStr substringFromIndex:loc];
        [self accessOAuthWithCode:code];
        return NO;
    }
    return YES;
}
-(void)accessOAuthWithCode:(NSString *)code{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"client_id"] = gAppKey;
    dic[@"client_secret"] = gAppSecrect;
    dic[@"grant_type"] = @"authorization_code";
    dic[@"code"] = code;
    dic[@"redirect_uri"] = gRedirectURI;
    [MBProgressHUDTool showWithStatus:nil needBackground:YES];
    [NetworkTool getAccessTokenWithURL:dic successBlock:^(NSDictionary *resultDic) {
        [SettingTool setAccessToken:resultDic[@"access_token"]];
        [[AccountOAuthModel sharedInstance] setDic:resultDic];
        [MBProgressHUDTool dismiss];
        [self.delegate loginLat];
    } error:^(NSError *error) {
        [MBProgressHUDTool showErrorWithStatus:[NSString stringWithFormat:@"%@",error]];
    }];
}
@end
