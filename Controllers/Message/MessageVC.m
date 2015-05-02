//
//  MessageVC.m
//  WBdemo
//
//  Created by Nick on 15-4-3.
//  Copyright (c) 2015年 74td. All rights reserved.
//

#import "MessageVC.h"

#import "MessageCellFirst.h"
#import "MyMessageVC.h"

@interface MessageVC ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end

@implementation MessageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}
#pragma mark tableview
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellname = @"mseeagecellname";
    MessageCellFirst *cell = [tableView dequeueReusableCellWithIdentifier:cellname];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"MessageCellFirst" bundle:nil] forCellReuseIdentifier:cellname];
        cell = [tableView dequeueReusableCellWithIdentifier:cellname];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setCellStyleFromMessage:indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 56;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        MyMessageVC *my = [[MyMessageVC alloc]init];
        my.status = 1;
        GetAppDelegate;
        [appDelegate.navController pushViewController:my animated:YES];
    }
    if (indexPath.row == 1) {
        MyMessageVC *my = [[MyMessageVC alloc]init];
        my.status = 2;
        GetAppDelegate;
        [appDelegate.navController pushViewController:my animated:YES];
    }
}
@end
