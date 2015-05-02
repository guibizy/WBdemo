//
//  MyMessageVC.m
//  WBdemo
//
//  Created by guibi on 15/5/1.
//  Copyright (c) 2015年 74td. All rights reserved.
//

#import "MyMessageVC.h"

#import "AppDelegate.h"
#import "MyMessageCellF.h"
#import "NetworkTool.h"
#import "SettingTool.h"
#import "CommentsShowModel.h"

@interface MyMessageVC ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic)NSMutableArray *mycommentsArray;

@end

@implementation MyMessageVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.mycommentsArray = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    if (self.status == 1) {
        [self myMessageData];
    }
    if (self.status == 2) {
        self.titleLab.text = @"所有评论";
        [self myMessageDatatome];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)myMessageData{
    [NetworkTool getMinePinglun:[SettingTool getAccessToken] successBlock:^(NSDictionary *resultDic) {
        NSArray *comments = resultDic[@"comments"];
        if (comments != nil && comments.count > 0) {
            NSMutableArray *ary = [NSMutableArray array];
            for (NSDictionary *dic in comments) {
                CommentsShowModel *comment = [[CommentsShowModel alloc]init];
                [comment setDic:dic];
                [ary addObject:comment];
            }
            [self.mycommentsArray addObjectsFromArray:ary];
        }
        [self.tableview reloadData];
    } error:^(NSError *error) {
        
    }];
}
-(void)myMessageDatatome{
    [NetworkTool getMinePinglunToMe:[SettingTool getAccessToken] successBlock:^(NSDictionary *resultDic) {
        NSArray *comments = resultDic[@"comments"];
        if (comments != nil && comments.count > 0) {
            NSMutableArray *ary = [NSMutableArray array];
            for (NSDictionary *dic in comments) {
                CommentsShowModel *comment = [[CommentsShowModel alloc]init];
                [comment setDic:dic];
                [ary addObject:comment];
            }
            [self.mycommentsArray addObjectsFromArray:ary];
        }
        [self.tableview reloadData];
    } error:^(NSError *error) {
        
    }];
}
#pragma mark tableviews
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellname = @"MyMessageCellF";
    MyMessageCellF *cell = [tableView dequeueReusableCellWithIdentifier:cellname];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"MyMessageCellF" bundle:nil] forCellReuseIdentifier:cellname];
        cell = [tableView dequeueReusableCellWithIdentifier:cellname];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setCellValue:[self.mycommentsArray objectAtIndex:indexPath.row]];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [MyMessageCellF getCellHeight:nil];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mycommentsArray.count;
}

#pragma mark return
- (IBAction)pushBackOnClick:(id)sender {
    GetAppDelegate;
    [appDelegate.navController popViewControllerAnimated:YES];
}

@end
