//
//  MyMessageCellF.m
//  WBdemo
//
//  Created by guibi on 15/5/1.
//  Copyright (c) 2015年 74td. All rights reserved.
//

#define cellHeight 160


#import "MyMessageCellF.h"

#import "AccountModel.h"
#import "AccountUserModel.h"
#import "CommentsShowModel.h"
#import "UIImageView+WebCache.h"

@interface MyMessageCellF()

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
@property (weak, nonatomic) IBOutlet UIImageView *statusImg;
@property (weak, nonatomic) IBOutlet UILabel *statusNameLab;

@property (weak, nonatomic) IBOutlet UILabel *statusComentLab;

@property (strong, nonatomic) CommentsShowModel *oneCommentsModel;

@end

@implementation MyMessageCellF

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)setCellValue:(CommentsShowModel *)model{
    self.oneCommentsModel = model;
    
    self.screenNameLab.text = model.user.screen_name;
    self.createdLab.text = model.created_at;
    NSRange rangF = [model.source rangeOfString:@"\">"];
    NSInteger loc = rangF.location + rangF.length;
    if (rangF.location != NSNotFound) {
        NSString *sourceTx = [model.source substringWithRange:NSMakeRange(loc,model.source.length - loc - 4)];
        self.sourceLab.text = [NSString stringWithFormat:@"来自 %@",sourceTx];
    }else{
        self.sourceLab.text = [NSString stringWithFormat:@"来自 %@",model.source];
    }
    self.textLab.text = model.text;
    
    //头像
    [self.profileImg sd_setImageWithURL:[NSURL URLWithString:model.user.profile_image_url] placeholderImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",model.user.profile_image_url]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    
    //头像
    [self.statusImg sd_setImageWithURL:[NSURL URLWithString:model.status.user.profile_image_url] placeholderImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",model.status.user.profile_image_url]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    }];
    
}
+(float)getCellHeight:(CommentsShowModel *)model{
    CGFloat height = [Define getTextViewHeightWithMessage:model.text width:SCREEN_WIDTH - 16 font:[UIFont fontWithName:@"STHeitiTC-Light" size:15.0] mixHight:15];
    return cellHeight+height;
}
@end
