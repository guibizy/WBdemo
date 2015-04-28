//
//  WBoneinfoCell.h
//  WBdemo
//
//  Created by Nick on 15-4-10.
//  Copyright (c) 2015年 74td. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CommentsShowModel;

@interface WBoneinfoCell : UITableViewCell

-(void)setCellValue:(CommentsShowModel *)model;
+(float)getCellHeight:(CommentsShowModel *)model;

@end
