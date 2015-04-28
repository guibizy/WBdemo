//
//  HomeUserInfoVC.m
//  WBdemo
//
//  Created by Nick on 15-4-3.
//  Copyright (c) 2015年 74td. All rights reserved.
//

#import "HomeUserInfoVC.h"

#import "UIImageView+WebCache.h"
#import "AccountOAuthModel.h"
#import "AccountUserModel.h"

@interface HomeUserInfoVC ()

@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *weiboLab;
@property (weak, nonatomic) IBOutlet UILabel *guanzhuLab;
@property (weak, nonatomic) IBOutlet UILabel *fensiLab;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLab;


@end

@implementation HomeUserInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:[AccountOAuthModel sharedInstance].user.profile_image_url] placeholderImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",[AccountOAuthModel sharedInstance].user.profile_image_url]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    
    self.nameLab.text = [AccountOAuthModel sharedInstance].user.screen_name;
    self.weiboLab.text =[NSString stringWithFormat:@"%d",[AccountOAuthModel sharedInstance].user.statuses_count];
    self.guanzhuLab.text = [NSString stringWithFormat:@"%d",[AccountOAuthModel sharedInstance].user.friends_count];
    self.fensiLab.text = [NSString stringWithFormat:@"%d",[AccountOAuthModel sharedInstance].user.followers_count];
    self.descriptionLab.text = [NSString stringWithFormat:@"简介：%@",[AccountOAuthModel sharedInstance].user._description];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resfesh) name:@"refreshMY" object:nil];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"refreshMY" object:nil];
}
-(void)resfesh{
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:[AccountOAuthModel sharedInstance].user.profile_image_url] placeholderImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",[AccountOAuthModel sharedInstance].user.profile_image_url]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    
    self.nameLab.text = [AccountOAuthModel sharedInstance].user.screen_name;
    self.weiboLab.text =[NSString stringWithFormat:@"%d",[AccountOAuthModel sharedInstance].user.statuses_count];
    self.guanzhuLab.text = [NSString stringWithFormat:@"%d",[AccountOAuthModel sharedInstance].user.friends_count];
    self.fensiLab.text = [NSString stringWithFormat:@"%d",[AccountOAuthModel sharedInstance].user.followers_count];
    self.descriptionLab.text = [NSString stringWithFormat:@"简介：%@",[AccountOAuthModel sharedInstance].user._description];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
