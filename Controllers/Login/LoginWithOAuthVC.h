//
//  LoginWithOAuthVC.h
//  WBdemo
//
//  Created by Nick on 15-4-1.
//  Copyright (c) 2015年 74td. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol logindele<NSObject>

-(void)loginLat;

@end

@interface LoginWithOAuthVC : UIViewController

@property (nonatomic, weak) id<logindele> delegate;

@end
