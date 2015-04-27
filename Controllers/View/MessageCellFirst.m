//
//  MessageCellFirst.m
//  WBdemo
//
//  Created by Nick on 15-4-3.
//  Copyright (c) 2015年 74td. All rights reserved.
//

#import "MessageCellFirst.h"

@interface MessageCellFirst()

@property (weak, nonatomic) IBOutlet UIImageView *photoImg;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UIImageView *iconImg;


@end

@implementation MessageCellFirst

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
