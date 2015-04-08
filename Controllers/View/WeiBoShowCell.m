//
//  WeiBoShowCell.m
//  WBdemo
//
//  Created by Nick on 15-4-2.
//  Copyright (c) 2015年 74td. All rights reserved.
//

#define CELLNormalHeight 119
#define InCellViewHeight 18

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

@end

@implementation WeiBoShowCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
-(void)setCellValue:(AccountModel *)model{
    
    
    [self.profileImg sd_setImageWithURL:[NSURL URLWithString:model.user.profile_image_url] placeholderImage:[UIImage imageNamed:@"placeholder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    
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
    NSRange rangS = [model.source rangeOfString:@"</"];
    NSString *sourceTx = [model.source substringWithRange:NSMakeRange((rangF.location + rangF.length), rangS.location - rangF.location - rangS.length)];
    self.sourceLab.text = [NSString stringWithFormat:@"来自 %@",sourceTx];
    self.textLab.text = model.text;
    
    self.statusViewHeight.constant = 0;
    self.statusView.hidden = YES;
    self.remindStatusHeight.constant = 0;
    self.remindStatusView.hidden = YES;
    self.tipHeight.constant = 0;
    
    if (model.reposts_count > 0) {
        self.repostsCountLab.text = [NSString stringWithFormat:@"%d",model.reposts_count];
    }
    if (model.comments_count > 0) {
        self.commentsCountLab.text = [NSString stringWithFormat:@"%d",model.comments_count];
    }
    if (model.attitudes_count > 0) {
        self.attitudesCountLab.text = [NSString stringWithFormat:@"%d",model.attitudes_count];
    }
}
+(float)getCellHeight:(AccountModel *)model{
    CGFloat textHeight = [Define getTextViewHeightWithMessage:model.text width:SCREEN_WIDTH - 16 font:[UIFont fontWithName:@"STHeitiTC-Light" size:15.0] mixHight:15];
    return CELLNormalHeight + textHeight;
}
@end
