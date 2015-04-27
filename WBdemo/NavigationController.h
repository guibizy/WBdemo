//
//  NavigationController.h
//  WBdemo
//
//  Created by Nick on 15-4-2.
//  Copyright (c) 2015年 74td. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CustomTabBar.h"
#import "LoginWithOAuthVC.h"

@interface NavigationController : UINavigationController<logindele>

@property (strong,nonatomic) CustomTabBar *tabbar;

-(void)loginI:(BOOL)status;
-(void)loginout;

@end
