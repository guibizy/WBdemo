//
//  CustomTabBar.h
//  LeqiClient
//
//  Created by ui on 11-5-25.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

static int lastSelectINdex;

@protocol customTabBarDelegate;

@interface CustomTabBar : UITabBarController <UITabBarControllerDelegate>{
	NSMutableArray *buttons;
	NSInteger currentSelectedIndex;
	UIImageView *slideBg;
    id <customTabBarDelegate> tabBarDelegate;
 
    UIButton *p_btn1;
    UIButton *p_btn2;
    UIButton *p_btn3;
    UIButton *p_btn4;
    UIButton *p_btn5;
    
    UIImageView * img1;
    UIImageView * img2;
    UIImageView * img3;
    UIImageView * img4;
    UIImageView * img5;
    
    UILabel *lab1;
    UILabel *lab2;
    UILabel *lab3;
    UILabel *lab4;
    UILabel *lab5;
}
@property (nonatomic, assign) NSInteger	currentSelectedIndex;
@property (nonatomic,retain) NSMutableArray *buttons;
@property (nonatomic, assign) id <customTabBarDelegate> tabBarDelegate;

@property (nonatomic , strong) UILabel *circleLab;

- (void)hideRealTabBar;
- (void)customTabBar;
- (void)selectedTab:(UIButton *)button;
- (void)hideExistingTabBar;
- (void)showExistingTabBar;
- (void)slideTabBg:(UIButton *)btn;
- (void)enabledButtons:(BOOL)flag;
- (void)goToFirstTab;
@end


@protocol customTabBarDelegate <NSObject>

- (void)tabbarButtonClick:(UIButton *)sender;

@end