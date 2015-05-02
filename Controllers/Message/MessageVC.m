//
//  MessageVC.m
//  WBdemo
//
//  Created by Nick on 15-4-3.
//  Copyright (c) 2015年 74td. All rights reserved.
//

#import "MessageVC.h"

#import "MessageCellFirst.h"

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
@end
