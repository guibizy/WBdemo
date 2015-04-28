//
//  HomepageVC.m
//  WBdemo
//
//  Created by Nick on 15-4-1.
//  Copyright (c) 2015年 74td. All rights reserved.
//

#define PAGE_NUM 20

#import "HomepageVC.h"

#import "SettingTool.h"
#import "AccountOAuthModel.h"
#import "LoginWithOAuthVC.h"
#import "AppDelegate.h"
#import "NetworkTool.h"
#import "WeiBoShowCell.h"
#import "AccountModel.h"
#import "MBProgressHUDTool.h"
#import "MJRefresh.h"
#import "WBoneInfoVC.h"
#import "AccountUserModel.h"
#import "PublishWB.h"

@interface HomepageVC ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *accountUserArray;
@property (weak, nonatomic) IBOutlet UILabel *mySelfLab;

@end

@implementation HomepageVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.accountUserArray = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mySelfLab.text = [AccountOAuthModel sharedInstance].user.screen_name;
    self.navigationController.navigationBarHidden = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView addHeaderWithCallback:^{
        [self getHomeTimeLineData:YES];
    }];
    [self.tableView addFooterWithCallback:^{
        [self getHomeTimeLineData:NO];
    }];
    [self getHomeTimeLineData:YES];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refresh) name:@"refreshMy" object:nil];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshMY" object:nil];
}
-(void)refresh{
    self.mySelfLab.text = [AccountOAuthModel sharedInstance].user.screen_name;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
#pragma mark －获取网络数据
-(void)getHomeTimeLineData:(BOOL)status{
    NSInteger page = 0;
    if (status) {
        if (self.accountUserArray.count > 0) {
            [self.accountUserArray removeAllObjects];
        }
    }else{
        page = self.accountUserArray.count/PAGE_NUM + 1;
    }
    [NetworkTool getUserHomeTimelineWhthAccessToken:[SettingTool getAccessToken] andCount:PAGE_NUM andPage:page successBlock:^(NSDictionary *resultDic) {
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
        if (resultDic[@"statuses"] != nil && resultDic[@"statuses"] != [NSNull null]) {
            NSMutableArray *tempArray = [NSMutableArray array];
            for (NSDictionary * dic in resultDic[@"statuses"]) {
                AccountModel *oneuser = [[AccountModel alloc]init];
                [oneuser setDic:dic];
                [tempArray addObject:oneuser];
            }
            [self.accountUserArray addObjectsFromArray:tempArray];
            [self.tableView reloadData];
        }else{
            [MBProgressHUDTool showErrorWithStatus:@"网络连接错误"];
        }
    } error:^(NSError *error) {
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
        [MBProgressHUDTool showErrorWithStatus:@"网络连接错误"];
//        [MBProgressHUDTool showErrorWithStatus:[NSString stringWithFormat:@"%@",error]];
    }];
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
    cell.repostsCallBackBlock = ^(AccountModel *model,UITableViewCell *cell){
        [self repostsCallBackSelectetor:model];
    };
    cell.commentsCallBackBlock = ^(AccountModel *model,UITableViewCell *cell){
        [self commentsCallBackSelectetor:model];
    };
    cell.attitudesCallBackBlock = ^(AccountModel *model,UITableViewCell *cell){
        [self attitudesCallBackSelectetor:model andCell:cell];
    };
    [cell setCellValue:[self.accountUserArray objectAtIndex:indexPath.row]];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = [WeiBoShowCell getCellHeight:[self.accountUserArray objectAtIndex:indexPath.row]];
    return height;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.accountUserArray.count;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WBoneInfoVC *onewbinfo = [[WBoneInfoVC alloc]init];
    AccountModel *model = [self.accountUserArray objectAtIndex:indexPath.row];
    onewbinfo.oneAccountModel = model;
    GetAppDelegate;
    [appDelegate.navController pushViewController:onewbinfo animated:YES];
}
#pragma mark callback-selector
/**
 *  转发
 */
-(void)repostsCallBackSelectetor:(AccountModel *)model{
    PublishWB *reposts = [[PublishWB alloc]init];
    reposts.WBstatus = 1;
    reposts.oneAccountModel = model;
    GetAppDelegate;
    [appDelegate.navController pushViewController:reposts animated:YES];
}
/**
 *  评论
 */
-(void)commentsCallBackSelectetor:(AccountModel *)model{
    PublishWB *reposts = [[PublishWB alloc]init];
    reposts.WBstatus = 2;
    reposts.oneAccountModel = model;
    GetAppDelegate;
    [appDelegate.navController pushViewController:reposts animated:YES];
}
/**
 * 点赞
 *
 *  @param model
 *  @param cell  
 */
-(void)attitudesCallBackSelectetor:(AccountModel *)model andCell:(UITableViewCell *)cell{
    
}
@end
