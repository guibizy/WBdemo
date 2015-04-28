//
//  WBoneinfoCell.m
//  WBdemo
//
//  Created by Nick on 15-4-10.
//  Copyright (c) 2015年 74td. All rights reserved.
//
#define cell_HEIGHT 52

#import "WBoneinfoCell.h"

#import "AccountUserModel.h"
#import "AccountModel.h"
#import "UIImageView+WebCache.h"
#import "CommentsShowModel.h"

@interface WBoneinfoCell()

//@property (weak, nonatomic) IBOutlet UIView *cellView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImg;
//@property (weak, nonatomic) IBOutlet UIButton *profileBtn;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLab;
//@property (weak, nonatomic) IBOutlet UIButton *screenNameBtn;
@property (weak, nonatomic) IBOutlet UILabel *createdLab;
//@property (weak, nonatomic) IBOutlet UILabel *sourceLab;
@property (weak, nonatomic) IBOutlet UILabel *textLab;

@end

@implementation WBoneinfoCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
-(void)setCellValue:(CommentsShowModel *)model{
    [self.profileImg sd_setImageWithURL: [NSURL URLWithString:model.user.profile_image_url ] placeholderImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",model.user.profile_image_url]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    
    self.screenNameLab.text = model.user.screen_name;
    self.createdLab.text = model.created_at;
    self.textLab.text = model.text;
}
+(float)getCellHeight:(CommentsShowModel *)model{
    CGFloat labHeight = [Define getTextViewHeightWithMessage:model.text width:SCREEN_WIDTH-64 font:[UIFont fontWithName:@"STHeitiTC-Light" size:17] mixHight:17];
    return labHeight+cell_HEIGHT;
}
@end
