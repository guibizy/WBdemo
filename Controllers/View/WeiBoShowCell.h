//
//  WeiBoShowCell.h
//  WBdemo
//
//  Created by Nick on 15-4-2.
//  Copyright (c) 2015年 74td. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AccountModel;

typedef void(^showCellCallBack)(AccountModel *model, UITableViewCell *cell);

@interface WeiBoShowCell : UITableViewCell

@property(copy,nonatomic) showCellCallBack repostsCallBackBlock;//转发
@property(copy,nonatomic) showCellCallBack commentsCallBackBlock;//评论
@property(copy,nonatomic) showCellCallBack attitudesCallBackBlock;//点赞

-(void)setCellValue:(AccountModel *)model;
+(float)getCellHeight:(AccountModel *)model;

@end
