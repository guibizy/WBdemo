//
//  WeiBoShowCell.m
//  WBdemo
//
//  Created by Nick on 15-4-2.
//  Copyright (c) 2015年 74td. All rights reserved.
//

#define CELLNormalHeight 119
#define InCellViewHeight 18
#define ImgHeight 80
#define LineImgNum 3

#import "WeiBoShowCell.h"
#import "AccountModel.h"
#import "AccountUserModel.h"
#import "NSDate+Convenience.h"
#import "UIImageView+WebCache.h"

@interface WeiBoShowCell()

@property (weak, nonatomic) IBOutlet UIImageView *profileImg;
@property (weak, nonatomic) IBOutlet UIButton *profileBtn;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLab;
@property (weak, nonatomic) IBOutlet UIButton *screenNameBtn;
@property (weak, nonatomic) IBOutlet UILabel *createdLab;
@property (weak, nonatomic) IBOutlet UILabel *sourceLab;
@property (weak, nonatomic) IBOutlet UILabel *textLab;

@property (weak, nonatomic) IBOutlet UILabel *repostsCountLab;
@property (weak, nonatomic) IBOutlet UILabel *commentsCountLab;
@property (weak, nonatomic) IBOutlet UILabel *attitudesCountLab;

@property (weak, nonatomic) IBOutlet UIView *statusView;
@property (weak, nonatomic) IBOutlet UIView *remindStatusView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statusViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *remindStatusHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tipHeight;

@property (weak, nonatomic) IBOutlet UILabel *retweedNameLab;
@property (weak, nonatomic) IBOutlet UILabel *retweedTextLab;
@property (weak, nonatomic) IBOutlet UIView *retweedImgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *retweedImgVHeight;

@property (strong, nonatomic) UIImageView *exImgV;

//@property (strong, nonatomic) AccountModel *oneAccountModel;

@end

@implementation WeiBoShowCell

- (instancetype)init
{
    self = [super init];
    if (self) {
//        self.oneAccountModel = [[AccountModel alloc]init];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
-(void)setCellValue:(AccountModel *)model{
    AccountModel *oneModel = [[AccountModel alloc]init];
    [oneModel setDic:model.retweeted_status];
    
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
    NSRange rangS = [model.source rangeOfString:@"</a>"];
    NSString *sourceTx = [model.source substringWithRange:NSMakeRange((rangF.location + rangF.length), rangS.location - rangF.location - rangF.length)];
    self.sourceLab.text = [NSString stringWithFormat:@"来自 %@",sourceTx];
    self.textLab.text = model.text;
    
    self.statusViewHeight.constant = 0;
    self.statusView.hidden = YES;
    self.remindStatusHeight.constant = 0;
    self.remindStatusView.hidden = YES;
    self.tipHeight.constant = 0;
    self.retweedImgVHeight.constant = 0;
    self.retweedImgView.hidden = YES;
    
    if (model.reposts_count > 0) {
        self.repostsCountLab.text = [NSString stringWithFormat:@"%d",model.reposts_count];
    }
    if (model.comments_count > 0) {
        self.commentsCountLab.text = [NSString stringWithFormat:@"%d",model.comments_count];
    }
    if (model.attitudes_count > 0) {
        self.attitudesCountLab.text = [NSString stringWithFormat:@"%d",model.attitudes_count];
    }
    
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
    //转发图片
    if (oneModel._id > 0) {
        self.remindStatusView.hidden = NO;
        self.retweedNameLab.text = [NSString stringWithFormat:@"%@:",oneModel.user.screen_name];
        self.retweedTextLab.text = [NSString stringWithFormat:@"%@:%@",oneModel.user.screen_name,oneModel.text];
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
+(float)getCellHeight:(AccountModel *)model{
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
    if (oneModel._id > 0) {
        remindHeight = InCellViewHeight;
        retweetedTextHeight = [Define getTextViewHeightWithMessage:oneModel.text width:SCREEN_WIDTH - 16 font:[UIFont fontWithName:@"STHeitiTC-Light" size:15.0] mixHight:15];
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
    return CELLNormalHeight + textHeight + picidsHeight + retweetedTextHeight + remindHeight +retweetedHeight;
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
        CGFloat retweetedTextHeight = [Define getTextViewHeightWithMessage:model.text width:SCREEN_WIDTH - 16 font:[UIFont fontWithName:@"STHeitiTC-Light" size:15.0] mixHight:15];
        self.retweedImgVHeight.constant = column * (ImgHeight + 8);
        self.remindStatusHeight.constant = InCellViewHeight + column * (ImgHeight + 8) + retweetedTextHeight;
    }
//    if (model.pic_ids.count == 1) {
//        
//        UIImageView *image1 = [[UIImageView alloc]init];
//        image1.frame = CGRectMake(8, 8, 80, 80);
//        [image1 sd_setImageWithURL:model.pic_ids[0] placeholderImage:[UIImage imageNamed:@"placeholder.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        }];
//        image1.contentMode = UIViewContentModeScaleAspectFill;
//        if (oneview == self.statusView) {
//            [self.statusView addSubview:image1];
//            self.statusViewHeight.constant = ImgHeight + 8;
//        }
//        if (oneview == self.remindStatusView) {
//            [self.retweedImgView addSubview:image1];
//            CGFloat retweetedTextHeight = [Define getTextViewHeightWithMessage:model.text width:SCREEN_WIDTH - 16 font:[UIFont fontWithName:@"STHeitiTC-Light" size:15.0] mixHight:15];
//            self.retweedImgVHeight.constant = ImgHeight + 8;
//            self.remindStatusHeight.constant = InCellViewHeight + (ImgHeight + 8) + retweetedTextHeight;
//        }
//        
//    }
//    if (model.pic_ids.count > 1) {
//        
//    }
}
@end
