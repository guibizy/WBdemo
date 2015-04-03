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
#import "WeiBoShowCell.h"

@interface HomepageVC ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation HomepageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"疯一般的男子";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark tableview
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellname = @"weiboshowcell";
    WeiBoShowCell *cell = [tableView dequeueReusableCellWithIdentifier:cellname];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"WeiBoShowCell" bundle:nil] forCellReuseIdentifier:cellname];
        cell = [tableView dequeueReusableCellWithIdentifier:cellname];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 20;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
@end
