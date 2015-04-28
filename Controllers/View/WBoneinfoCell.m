//
//  WBoneinfoCell.m
//  WBdemo
//
//  Created by Nick on 15-4-10.
//  Copyright (c) 2015年 74td. All rights reserved.
//

#import "WBoneinfoCell.h"

#import "AccountUserModel.h"
#import "AccountModel.h"
#import "UIImageView+WebCache.h"

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
-(void)setCellValue:(AccountModel *)model{
    [self.profileImg sd_setImageWithURL: [NSURL URLWithString:model.user.profile_image_url ] placeholderImage:[UIImage imageNamed:@""] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    
    self.screenNameLab.text = model.user.screen_name;
    self.createdLab.text = model.created_at;
    self.textLab.text = model.text;
}
+(float)getCellHeight:(AccountModel *)model{
    return 1;
}
@end
