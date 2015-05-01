//
//  CustomTabBar.m
//  LeqiClient
//
//  Created by ui on 11-5-25.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CustomTabBar.h"

#import "AppDelegate.h"
#import "PublishAddWB.h"
#import <QuartzCore/QuartzCore.h>

@interface CustomTabBar () {
    BOOL isFirst;
}

@property (nonatomic , strong) UIImageView *circleImg;

@end

@implementation CustomTabBar

@synthesize currentSelectedIndex = _currentSelectedIndex;
@synthesize buttons;
@synthesize tabBarDelegate = _tabBarDelegate;

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    CGRect frame = CGRectMake(0, SCREEN_HEIGHT - 45, SCREEN_WIDTH, 45);
//    self.view.frame = frame;
    self.tabBar.frame = frame;
    
    isFirst = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (isFirst) {
        isFirst = NO;
        [self customTabBar];
    }
}

- (void)hideRealTabBar{
	for(UIView *view in self.view.subviews){
		if([view isKindOfClass:[UITabBar class]]){
			view.hidden = YES;
//            view.center = CGPointMake(view.center.x, view.center.y + view.frame.size.height);
			break;
		}
	}
}


- (void)hideExistingTabBar
{
    for(UIView *view in self.view.subviews){
		if([view isKindOfClass:[UIButton class]]){
			view.hidden = YES;
		}
        if([view isKindOfClass:[UIImageView class]]){
			view.hidden = YES;
		}
        if ([view isKindOfClass:[UILabel class]]) {
            view.hidden = YES;
        }
	}
}

-(void)showExistingTabBar
{
    for(UIView *view in self.view.subviews){
		if([view isKindOfClass:[UIButton class]]){
			view.hidden = NO;
		}
        if([view isKindOfClass:[UIImageView class]]){
			view.hidden = NO;
		}
        if ([view isKindOfClass:[UILabel class]]) {
            view.hidden = NO;
        }
	}
}

- (void)customTabBar{
    
//	UIImageView *imgView = [[UIImageView alloc] init];
//    imgView.backgroundColor = UICOLOR_RGBA(255, 255, 255, 1);//(39, 103, 196)此处为未选中的tab的背景色
//    imgView.tag = 100;
//	imgView.frame = CGRectMake(0, SCREEN_HEIGHT-self.tabBar.frame.size.height,SCREEN_WIDTH, SCREEN_HEIGHT);
//	[self.view addSubview:imgView];
    
	//创建按钮
    NSInteger viewCount;
    viewCount = self.viewControllers.count+1;
    
	self.buttons = [NSMutableArray arrayWithCapacity:viewCount-1];
	double _width = SCREEN_WIDTH / viewCount;
	double _height = self.tabBar.frame.size.height;
    
	for (int i = 0; i < viewCount; i++)
    {
        int ij = i;
        if (i >= 2) {
            ij++;
        }
		UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
		btn.frame = CGRectMake(ij*_width,SCREEN_HEIGHT-self.tabBar.frame.size.height, _width, _height);
		[btn addTarget:self action:@selector(selectedTab:) forControlEvents:UIControlEventTouchUpInside];
        btn.backgroundColor = [UIColor clearColor];
		btn.tag = i;
        
        if (i == 2) {
            UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
            btn2.frame = CGRectMake(i*_width,SCREEN_HEIGHT-self.tabBar.frame.size.height, _width, _height);
            [btn2 addTarget:self action:@selector(moreBtnTab:) forControlEvents:UIControlEventTouchUpInside];
            btn2.backgroundColor = [UIColor clearColor];
            btn2.tag = i+1;
            
            UIImageView *imgVMore1 = [[UIImageView alloc]init];
            imgVMore1.frame = CGRectMake(i*_width+_width/2.0-25, SCREEN_HEIGHT-self.tabBar.frame.size.height-3,50, 45);
            imgVMore1.image = [UIImage imageNamed:@"footericon_5_down.png"];
            
            UIImageView *imgVMore2 = [[UIImageView alloc]init];
            CGRect frame = imgVMore1.frame;
            frame.size.height = 20;
            frame.size.width = 20;
            imgVMore2.frame = frame;
            imgVMore2.center = imgVMore1.center;
            imgVMore2.image = [UIImage imageNamed:@"footericon_5.png"];
            
            [self.view addSubview:btn2];
            [self.view addSubview:imgVMore1];
            [self.view addSubview:imgVMore2];
        }
        
        UIImageView *imgV = [[UIImageView alloc]init];
        imgV.frame = CGRectMake(ij*_width+_width/2.0-15, SCREEN_HEIGHT-self.tabBar.frame.size.height, 30, 30); // 突出3像素
        
        UILabel* lab = [[UILabel alloc]init];
        lab.frame = CGRectMake(ij*_width, SCREEN_HEIGHT-self.tabBar.frame.size.height+30, _width, _height-30);
        lab.tag = i;
        lab.textAlignment = NSTextAlignmentCenter;
        lab.font = [UIFont systemFontOfSize:11];
        lab.backgroundColor = [UIColor clearColor];
        lab.textColor = UICOLOR_RGBA(170, 170, 170, 1);
        
        switch (btn.tag) {
            case 0:
                p_btn1=btn;
                lab1 = lab;
                img1 = imgV;
                imgV.image = [UIImage imageNamed:@"footericon_1_down.png"];
                lab1.text = @"首页";
                lab1.textColor = UICOLOR_RGBA(247, 118, 42, 1);
//                self.circleImg = [[UIImageView alloc]initWithFrame:CGRectMake(i*_width+(_width/2+11), self.tabBar.frame.origin.y+5, 6,6)];
//                self.circleImg.image = [UIImage imageNamed:@"position_hd"];
                break;
            case 1:
                p_btn2=btn;
                img2 = imgV;
                imgV.image = [UIImage imageNamed:@"footericon_2.png"];
                lab2 = lab;
                lab2.text = @"消息";
                break;
            case 2:
                p_btn3=btn;
                img3 = imgV;
                imgV.image = [UIImage imageNamed:@"footericon_3.png"];
                lab3 = lab;
                lab3.text = @"发现";
                break;
            case 3:
                p_btn4=btn;
                img4 = imgV;
                imgV.image = [UIImage imageNamed:@"footericon_4.png"];
                lab4 = lab;
                lab4.text = @"我";
                break;
            default:
                break;
        }
		[self.buttons addObject:btn];
		[self.view addSubview:btn];
        [self.view addSubview:imgV];
        
        [self.view addSubview:lab];
//        [self.view addSubview:self.circleImg];
//        [self.view addSubview:self.circleLab];
        self.circleLab.hidden = NO;
        self.circleImg.hidden = YES;
        
        if (i == self.selectedIndex)
        {
            slideBg.center = CGPointMake(btn.center.x, btn.center.y);
        }
	}
	[self.view addSubview:slideBg];
}
-(void)moreBtnTab:(UIButton *)button{
    PublishAddWB *add = [[PublishAddWB alloc]init];
    [add addViewForShare];
}

- (void)selectedTab:(UIButton *)button{

	self.currentSelectedIndex = button.tag;
	self.selectedIndex = self.currentSelectedIndex;
    switch (button.tag) {
        case 0:
        {
            lab1.textColor = UICOLOR_RGBA(247, 118, 42, 1);
            img1.image = [UIImage imageNamed:@"footericon_1_down.png"];
            lab2.textColor = UICOLOR_RGBA(170, 170, 170, 1);
            img2.image = [UIImage imageNamed:@"footericon_2.png"];
            lab3.textColor = UICOLOR_RGBA(170, 170, 170, 1);
            img3.image = [UIImage imageNamed:@"footericon_3.png"];
            lab4.textColor = UICOLOR_RGBA(170, 170, 170, 1);
            img4.image = [UIImage imageNamed:@"footericon_4.png"];
            lab5.textColor = UICOLOR_RGBA(170, 170, 170, 1);
            img5.image = [UIImage imageNamed:@"footericon_5.png"];
        }
                break;
        case 1:
        {
            
            lab1.textColor = UICOLOR_RGBA(170, 170, 170, 1);
            img1.image = [UIImage imageNamed:@"footericon_1.png"];
            lab2.textColor = UICOLOR_RGBA(247, 118, 42, 1);
            img2.image = [UIImage imageNamed:@"footericon_2_down.png"];
            lab3.textColor = UICOLOR_RGBA(170, 170, 170, 1);
            img3.image = [UIImage imageNamed:@"footericon_3.png"];
            lab4.textColor = UICOLOR_RGBA(170, 170, 170, 1);
            img4.image = [UIImage imageNamed:@"footericon_4.png"];
            lab5.textColor = UICOLOR_RGBA(170, 170, 170, 1);
            img5.image = [UIImage imageNamed:@"footericon_5.png"];
        }
            break;
        case 2:
            
        {
            lab1.textColor = UICOLOR_RGBA(170, 170, 170, 1);
            img1.image = [UIImage imageNamed:@"footericon_1.png"];
            lab2.textColor = UICOLOR_RGBA(170, 170, 170, 1);
            img2.image = [UIImage imageNamed:@"footericon_2.png"];
            lab3.textColor = UICOLOR_RGBA(247, 118, 42, 1);
            img3.image = [UIImage imageNamed:@"footericon_3_down.png"];
            lab4.textColor = UICOLOR_RGBA(170, 170, 170, 1);
            img4.image = [UIImage imageNamed:@"footericon_4.png"];
            lab5.textColor = UICOLOR_RGBA(170, 170, 170, 1);
            img5.image = [UIImage imageNamed:@"footericon_4.png"];
        }
            
            break;
        case 3:
        {
            lab1.textColor = UICOLOR_RGBA(170, 170, 170, 1);
            img1.image = [UIImage imageNamed:@"footericon_1.png"];
            lab2.textColor = UICOLOR_RGBA(170, 170, 170, 1);
            img2.image = [UIImage imageNamed:@"footericon_2.png"];
            lab3.textColor = UICOLOR_RGBA(170, 170, 170, 1);
            img3.image = [UIImage imageNamed:@"footericon_3.png"];
            lab4.textColor = UICOLOR_RGBA(247, 118, 42, 1);
            img4.image = [UIImage imageNamed:@"footericon_4_down.png"];
            lab5.textColor = UICOLOR_RGBA(170, 170, 170, 1);
            img5.image = [UIImage imageNamed:@"footericon_5.png"];
        }
            break;
        default:
            break;
    }
    
	[self performSelector:@selector(slideTabBg:) withObject:button];
    if ([_tabBarDelegate respondsToSelector:@selector(tabbarButtonClick:)])
    {
        [_tabBarDelegate tabbarButtonClick:button];
    }
}

- (void)slideTabBg:(UIButton *)btn{
    
//	[UIView beginAnimations:nil context:nil];  
//	[UIView setAnimationDuration:0.20];  
//	[UIView setAnimationDelegate:self];
////	slideBg.frame = CGRectMake(btn.frame.origin.x, btn.frame.origin.y, slideBg.image.size.width/2, slideBg.image.size.height/2);
//    slideBg.center = CGPointMake(btn.center.x, btn.center.y);
//	[UIView commitAnimations];
//    
//    CAKeyframeAnimation * animation; 
//	animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"]; 
//	animation.duration = 0.50; 
//	animation.delegate = self;
//	animation.removedOnCompletion = YES;
//	animation.fillMode = kCAFillModeForwards;
//	NSMutableArray *values = [NSMutableArray array];
//	[values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
//	[values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]]; 
//	[values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 0.9)]]; 
//	[values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
//	animation.values = values;
//	[btn.layer addAnimation:animation forKey:nil];
}

- (void)enabledButtons:(BOOL)flag
{
    for (UIButton *btn in self.buttons)
    {
        if (flag)
        {
            btn.enabled = YES;
        }
        else
        {
            btn.enabled = NO;
        }
    }
}

- (void)goToFirstTab {
    self.selectedIndex = 0;
    lab1.textColor = [UIColor whiteColor];
    img1.image = [UIImage imageNamed:@"footericon_1_down.png"];
    lab2.textColor = UICOLOR_RGBA(170, 170, 170, 1);
    img2.image = [UIImage imageNamed:@"footericon_2.png"];
    lab3.textColor = UICOLOR_RGBA(170, 170, 170, 1);
    img3.image = [UIImage imageNamed:@"footericon_3.png"];
    lab4.textColor = UICOLOR_RGBA(170, 170, 170, 1);
    img4.image = [UIImage imageNamed:@"footericon_4.png"];
}

- (void)shopCarBtnAction:(UIButton*)btn {
//    ShoppingCartViewController* shop = [[ShoppingCartViewController alloc]init];
//    GetAppDelegate;
//    [appDelegate.navViewContrller pushViewController:shop animated:YES];
}

@end
