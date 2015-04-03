//
//  NavigationController.h
//  WBdemo
//
//  Created by Nick on 15-4-2.
//  Copyright (c) 2015年 74td. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CustomTabBar.h"

@interface NavigationController : UINavigationController

@property (strong,nonatomic) CustomTabBar *tabbar;

-(void)login:(BOOL)status;
-(void)loginout;

@end
