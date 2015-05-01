//
//  WBoneInfoVC.m
//  WBdemo
//
//  Created by Nick on 15-4-9.
//  Copyright (c) 2015年 74td. All rights reserved.
//

#define headHeight 110
#define LineImgNum 3
#define ImgHeight 80
#define PAGE_NUM 20

#import "WBoneInfoVC.h"

#import "AccountModel.h"
#import "UIImageView+WebCache.h"
#import "AccountUserModel.h"
#import "NSDate+Convenience.h"
#import "WBoneinfoCell.h"
#import "NetworkTool.h"
#import "SettingTool.h"
#import "MBProgressHUDTool.h"
#import "CommentsShowModel.h"
#import "PublishWB.h"

@interface WBoneInfoVC ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *tabHeadView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImg;
@property (weak, nonatomic) IBOutlet UIButton *profileBtn;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLab;
@property (weak, nonatomic) IBOutlet UIButton *screenNameBtn;
@property (weak, nonatomic) IBOutlet UILabel *createdLab;
@property (weak, nonatomic) IBOutlet UILabel *sourceLab;
@property (weak, nonatomic) IBOutlet UILabel *textLab;
@property (weak, nonatomic) IBOutlet UITableView *tableview;

//@property (weak, nonatomic) IBOutlet UILabel *repostsCountLab;
//@property (weak, nonatomic) IBOutlet UILabel *commentsCountLab;
//@property (weak, nonatomic) IBOutlet UILabel *attitudesCountLab;
@property (weak, nonatomic) IBOutlet UILabel *dianzanLab;

@property (weak, nonatomic) IBOutlet UIView *statusView;
@property (weak, nonatomic) IBOutlet UIView *remindStatusView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statusViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *remindStatusHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tipHeight;

@property (weak, nonatomic) IBOutlet UILabel *retweedTextLab;
@property (weak, nonatomic) IBOutlet UIView *retweedImgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *retweedImgVHeight;
@property (weak, nonatomic) IBOutlet UILabel *pinglunNumLab;


@property (strong, nonatomic) IBOutlet UIView *secionView;
//弹窗view
@property (strong, nonatomic) IBOutlet UIView *alertView;
@property (weak, nonatomic) IBOutlet UIButton *alertBen;

@property (strong, nonatomic) NSMutableArray *pinglunArray;
@property (strong, nonatomic) CommentsShowModel *oneCommentModel;

@end

@implementation WBoneInfoVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.pinglunArray = [NSMutableArray array];
        self.oneCommentModel = [[CommentsShowModel alloc]init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    CGFloat headheight = headHeight;
    [self setKongjianValue:self.oneAccountModel];
    CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, 0);
    headheight = [self setHeadHeight:self.oneAccountModel];
    frame.size.height = headheight;
    self.tabHeadView.frame = frame;
    [self getNetworkData:YES];
}
//
-(void)setKongjianValue:(AccountModel *)model{
    
    AccountModel *oneModel = [[AccountModel alloc]init];
    [oneModel setDic:model.retweeted_status];
    
    self.statusViewHeight.constant = 0;
    self.statusView.hidden = YES;
    self.remindStatusHeight.constant = 0;
    self.remindStatusView.hidden = YES;
    self.tipHeight.constant = 0;
    
    self.screenNameLab.text = model.user.screen_name;
    
    NSDate *createAt = [NSDate dateFromString:model.created_at format:@"yyyy-MM-dd HH:mm:ss"];
    NSTimeInterval sec = [createAt timeIntervalSinceNow];
    
    int minute = abs((int)(sec))/60;
    int hours = minute/60;
    int days = hours/24;
    if (minute > 2) {
        self.createdLab.text = [NSString stringWithFormat:@"%d分钟前",minute];
    }else{
        self.createdLab.text = @"刚刚";
    }
    if (hours > 0) {
        self.createdLab.text = [NSString stringWithFormat:@"%d小时前",hours];
    }
    if (days > 0) {
        self.createdLab.text = [NSString stringWithFormat:@"%@",[NSDate dateFromString:model.created_at format:@"yyyy-MM-dd"]];
    }
    NSRange rangF = [model.source rangeOfString:@"\">"];
    NSInteger loc = rangF.location + rangF.length;
    if (rangF.location != NSNotFound) {
        NSString *sourceTx = [model.source substringWithRange:NSMakeRange(loc,model.source.length - loc - 4)];
        self.sourceLab.text = [NSString stringWithFormat:@"来自 %@",sourceTx];
    }else{
        self.sourceLab.text = [NSString stringWithFormat:@"来自 %@",model.source];
    }
    self.textLab.text = model.text;
//    if (model.reposts_count > 0) {
//        self.repostsCountLab.text = [NSString stringWithFormat:@"%d",model.reposts_count];
//    }
    if (model.comments_count > 0) {
        self.pinglunNumLab.text = [NSString stringWithFormat:@"%d",model.comments_count];
    }
//    if (model.attitudes_count > 0) {
//        self.dianzanLab.text = [NSString stringWithFormat:@"%d",model.attitudes_count];
//    }
    //头像
    [self.profileImg sd_setImageWithURL:[NSURL URLWithString:model.user.profile_image_url] placeholderImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",model.user.profile_image_url]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    //评论图片
    if (model.pic_ids != nil && model.pic_ids.count > 0) {
        self.tipHeight.constant = 10;
        self.statusView.hidden = NO;
        for (UIView *view in self.statusView.subviews) {
            [view removeFromSuperview];
        }
        [self setPngDownText:model andView:self.statusView];
    }else{
        self.statusViewHeight.constant = 0;
        self.statusView.hidden = YES;
    }
    if (oneModel._id > 0.f) {
        self.remindStatusView.hidden = NO;
        
        NSString *screenName = oneModel.user.screen_name;
        NSInteger length = screenName.length;
        NSString *textStr = [NSString stringWithFormat:@"@%@:%@",oneModel.user.screen_name,oneModel.text];
        NSMutableAttributedString *content = [[NSMutableAttributedString alloc]initWithString:textStr];
        [content addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0/255.0 green:122/255.0 blue:255/255.0 alpha:1.0] range:NSMakeRange(0, length+2)];
        
        self.retweedTextLab.attributedText = content;
        if (oneModel.pic_ids != nil && oneModel.pic_ids.count > 0) {
            self.retweedImgView.hidden = NO;
            for (UIView *view in self.retweedImgView.subviews) {
                [view removeFromSuperview];
            }
            [self setPngDownText:oneModel andView:self.remindStatusView];
        }else{
            self.retweedImgVHeight.constant = 0;
            self.retweedImgView.hidden = YES;
        }
    }else{
        self.remindStatusHeight.constant = 0;
        self.remindStatusView.hidden = YES;
    }
}
//
-(float)setHeadHeight:(AccountModel *)model{
    
    AccountModel *oneModel = [[AccountModel alloc]init];
    if (model.retweeted_status != nil) {
        [oneModel setDic:model.retweeted_status];
    }
    
    CGFloat textHeight = [Define getTextViewHeightWithMessage:model.text width:SCREEN_WIDTH - 16 font:[UIFont fontWithName:@"STHeitiTC-Light" size:15.0] mixHight:15];
    CGFloat picidsHeight = 0;
    CGFloat remindHeight = 0;
    CGFloat retweetedTextHeight = 0;
    CGFloat retweetedHeight = 0;
    if (model.pic_ids != nil && model.pic_ids.count > 0) {
        int num = model.pic_ids.count;
        int column = 0;
        if (num%LineImgNum > 0) {
            column = num/LineImgNum + 1;
        }
        else{
            column = num/LineImgNum;
        }
        picidsHeight = column * (ImgHeight + 8);
    }
    if (oneModel._id > 0.f) {
        remindHeight = 8;
        retweetedTextHeight = [Define getTextViewHeightWithMessage:[NSString stringWithFormat:@"%@:%@",oneModel.user.screen_name,oneModel.text] width:SCREEN_WIDTH - 16 font:[UIFont fontWithName:@"STHeitiTC-Light" size:15.0] mixHight:17];
        int num = oneModel.pic_ids.count;
        int column = 0;
        if (num%LineImgNum > 0) {
            column = num/LineImgNum + 1;
        }
        else{
            column = num/LineImgNum;
        }
        retweetedHeight = column * (ImgHeight + 8);
    }
    return headHeight + textHeight + picidsHeight + retweetedTextHeight + remindHeight +retweetedHeight;
}
//下载图片
-(void)setPngDownText:(AccountModel *)model andView:(UIView *)oneview{
    
    int num = model.pic_ids.count;
    
    NSInteger column = 0;
    if (num%LineImgNum > 0) {
        column = num/LineImgNum + 1;
    }
    
    else{
        column = num/LineImgNum;
    }
    
    for (int i = 1 ; i <= column; i ++) {
        for (int j = 1 ; j <= (i*LineImgNum - num >= 0?num - (i-1)*LineImgNum:LineImgNum) ; j ++ ) {
            UIImageView *image2 = [[UIImageView alloc]init];
            image2.frame = CGRectMake(8*j + (j - 1)*ImgHeight, 8*i + (i - 1)*ImgHeight, ImgHeight, ImgHeight);
            image2.contentMode = UIViewContentModeScaleToFill;
            [image2 sd_setImageWithURL:model.pic_ids[(i-1)*LineImgNum + j - 1] placeholderImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",model.pic_ids[(i-1)*LineImgNum + j - 1]]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
                
                UIImageView * imgView1 = [[UIImageView alloc] init];
                imgView1.frame = CGRectMake(0, 0, 80, 80);
                CGRect rect1 =  CGRectMake((image.size.width-80)/2.0, (image.size.height-80)/2.0, 80, 80);//要裁剪的图片区域，按照原图的像素大小来，超过原图大小的边自动适配
                CGImageRef cgimg1 = CGImageCreateWithImageInRect([image CGImage], rect1);
                imgView1.image = [UIImage imageWithCGImage:cgimg1];
                CGImageRelease(cgimg1);//用完一定要释放，否则内存泄露
                image2.image = imgView1.image;
            }];
            if (oneview == self.statusView) {
                [self.statusView addSubview:image2];
            }
            if (oneview == self.remindStatusView) {
                [self.retweedImgView addSubview:image2];
            }
        }
    }
    if (oneview == self.statusView) {
        self.statusViewHeight.constant = column * (ImgHeight + 8);
    }
    if (oneview == self.remindStatusView) {
        CGFloat retweetedTextHeight = [Define getTextViewHeightWithMessage:[NSString stringWithFormat:@"%@:%@",model.user.screen_name,model.text] width:SCREEN_WIDTH - 16 font:[UIFont fontWithName:@"STHeitiTC-Light" size:15.0] mixHight:17];
        self.retweedImgVHeight.constant = column * (ImgHeight + 8);
        self.remindStatusHeight.constant = 8 + column * (ImgHeight + 8) + retweetedTextHeight;
    }
}
//
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
//获取网络数据
-(void)getNetworkData:(BOOL)staus{
    NSInteger page = self.pinglunArray.count / PAGE_NUM + 1;
    if (staus) {
        if (self.pinglunArray.count > 0) {
            [self.pinglunArray removeAllObjects];
        }
        page = 1;
    }
    [NetworkTool getCommentsShowWhthAccessTokenAndID:[SettingTool getAccessToken]
                                               andID:self.oneAccountModel._id
                                            andCount:PAGE_NUM
                                             andPage:page
                                        successBlock:^(NSDictionary *resultDic) {
        NSArray *comments = resultDic[@"comments"];
        if (comments != nil && comments.count > 0) {
            NSMutableArray *ary = [NSMutableArray array];
            for (NSDictionary *dic in comments) {
                CommentsShowModel *comment = [[CommentsShowModel alloc]init];
                [comment setDic:dic];
                [ary addObject:comment];
            }
            [self.pinglunArray addObjectsFromArray:ary];
            self.dianzanLab.text = [NSString stringWithFormat:@"%d",self.pinglunArray.count];
        }
        [self.tableview reloadData];
    } error:^(NSError *error) {
        [MBProgressHUDTool showErrorWithStatus:[NSString stringWithFormat:@"%@",error]];
    }];
}
#pragma mark uitableview
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellname = @"wbpinglunCell";
    WBoneinfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellname];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"WBoneinfoCell" bundle:nil] forCellReuseIdentifier:cellname];
        cell = [tableView dequeueReusableCellWithIdentifier:cellname];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setCellValue:[self.pinglunArray objectAtIndex:indexPath.row]];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [WBoneinfoCell getCellHeight:self.pinglunArray[indexPath.row]];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.pinglunArray.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    self.secionView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40);
    return self.secionView;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.oneCommentModel = [self.pinglunArray objectAtIndex:indexPath.row];
    [self alertViewOpen];
}
#pragma alertview
-(void)alertViewOpen{
    self.alertView.frame = WINDOW.bounds;
    [WINDOW addSubview:self.alertView];
    [UIView animateWithDuration:0.3 animations:^{
        self.alertBen.alpha = 0.5;
    } completion:^(BOOL finished) {
        
    }];
}
-(void)closeAlertView{
    [UIView animateWithDuration:0.3 animations:^{
        self.alertBen.alpha = 0;
    } completion:^(BOOL finished) {
        [self.alertView removeFromSuperview];
    }];
}
- (IBAction)closeOnClick:(id)sender {
    [self closeAlertView];
}
#pragma mark 弹窗各个方法
//回复方法
- (IBAction)huifuOnClick:(id)sender {
    PublishWB *add = [[PublishWB alloc]init];
    add.oneAccountModel = self.oneAccountModel;
    add.oneCommentModel = self.oneCommentModel;
    add.callbackblock = ^(){
        [self getNetworkData:YES];
    };
    add.WBstatus = 5;
    [self closeAlertView];
    GetAppDelegate;
    [appDelegate.navController pushViewController:add animated:YES];
}

#pragma mark -onclick
- (IBAction)pushBackOnClick:(UIButton *)sender {
    GetAppDelegate;
    [appDelegate.navController popViewControllerAnimated:YES];
}
@end
