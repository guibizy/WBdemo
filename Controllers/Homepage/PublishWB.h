//
//  PublishWB.h
//  WBdemo
//
//  Created by Nick on 15-4-15.
//  Copyright (c) 2015年 74td. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AccountModel;

@interface PublishWB : UIViewController

/**
 *  1.转发微博 2.评论微博 3.发布微博 4.发布微博照片 5.回复评论
 */
@property(assign,nonatomic) NSInteger WBstatus;
@property(strong, nonatomic) AccountModel *oneAccountModel;


@end
