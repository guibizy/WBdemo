//
//  WeiBoShowCell.h
//  WBdemo
//
//  Created by Nick on 15-4-2.
//  Copyright (c) 2015年 74td. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AccountModel;

@interface WeiBoShowCell : UITableViewCell

-(void)setCellValue:(AccountModel *)model;
+(float)getCellHeight:(AccountModel *)model;

@end
