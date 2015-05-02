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
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [MyMessageCellF getCellHeight:nil];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

#pragma mark return
- (IBAction)pushBackOnClick:(id)sender {
    GetAppDelegate;
    [appDelegate.navController popViewControllerAnimated:YES];
}

@end
