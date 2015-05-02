//
//  MyMessageCellF.h
//  WBdemo
//
//  Created by guibi on 15/5/1.
//  Copyright (c) 2015年 74td. All rights reserved.
//

#import <UIKit/UIKit.h>


@class CommentsShowModel;

@interface MyMessageCellF : UITableViewCell


-(void)setCellValue:(CommentsShowModel *)model;
+(float)getCellHeight:(CommentsShowModel *)model;

@end
