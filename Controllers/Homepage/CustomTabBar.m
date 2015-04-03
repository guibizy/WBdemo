//
//  CustomTabBar.m
//  LeqiClient
//
//  Created by ui on 11-5-25.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CustomTabBar.h"

#import "AppDelegate.h"
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
    
	UIImageView *imgView = [[UIImageView alloc] init];
    imgView.backgroundColor = UICOLOR_RGBA(255, 255, 255, 1);//(39, 103, 196)此处为未选中的tab的背景色
    imgView.tag = 100;
	imgView.frame = CGRectMake(0, SCREEN_HEIGHT-self.tabBar.frame.size.height,SCREEN_WIDTH, SCREEN_HEIGHT);
	[self.view addSubview:imgView];
    
	//创建按钮
    NSInteger viewCount;
    viewCount = self.viewControllers.count;
    
	self.buttons = [NSMutableArray arrayWithCapacity:viewCount];
	double _width = SCREEN_WIDTH / viewCount;
	double _height = self.tabBar.frame.size.height;
    
	for (int i = 0; i < viewCount; i++)
    {
		UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
		btn.frame = CGRectMake(i*_width,self.tabBar.frame.origin.y, _width, _height);
		[btn addTarget:self action:@selector(selectedTab:) forControlEvents:UIControlEventTouchUpInside];
        btn.backgroundColor = [UIColor clearColor];
		btn.tag = i;
        
        UIImageView *imgVbg = [[UIImageView alloc]init];
        imgVbg.frame = CGRectMake(i*_width+_width/2.0-30, self.tabBar.frame.origin.y-3.1, 60, _height+3.1);

        UIImageView *imgV = [[UIImageView alloc]init];
        imgV.frame = CGRectMake(i*_width+_width/2.0-15, self.tabBar.frame.origin.y+3, 30, 30); // 突出3像素
        
        UILabel* lab = [[UILabel alloc]init];
        lab.frame = CGRectMake(i*_width, self.tabBar.frame.origin.y+30, _width, _height-30);
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
                imgbg1 = imgVbg;
                imgVbg.image = [UIImage imageNamed:@"footericon_bg.png"];
                lab1.text = @"首页";
                lab1.textColor = [UIColor whiteColor];
//                self.circleImg = [[UIImageView alloc]initWithFrame:CGRectMake(i*_width+(_width/2+11), self.tabBar.frame.origin.y+5, 6,6)];
//                self.circleImg.image = [UIImage imageNamed:@"position_hd"];
                break;
            case 1:
                p_btn2=btn;
                img2 = imgV;
                imgV.image = [UIImage imageNamed:@"footericon_2.png"];
                imgbg2 = imgVbg;
                imgVbg.image = nil;
                lab2 = lab;
                lab2.text = @"消息";
                break;
            case 2:
                p_btn3 = btn;
                img3 = imgV;
                imgbg3 = imgVbg;
                imgVbg.image = nil;
                imgV.image = [UIImage imageNamed:@"footericon_3.png"];
                lab3 = lab;
                lab3.text = @"发现";
                break;
            case 3:
                p_btn4=btn;
                img4 = imgV;
                imgV.image = [UIImage imageNamed:@"footericon_4.png"];
                imgbg4 = imgVbg;
                imgVbg.image = nil;
                lab4 = lab;
                lab4.text = @"发现";
                break;
            case 4:
                p_btn5=btn;
                img5 = imgV;
                imgV.image = [UIImage imageNamed:@"footericon_4.png"];
                imgbg5 = imgVbg;
                imgVbg.image = nil;
                lab5 = lab;
                lab5.text = @"我";
                break;
                
            default:
                break;
        }
		[self.buttons addObject:btn];
		[self.view addSubview:btn];
        [self.view addSubview:imgVbg];
        [self.view addSubview:imgV];
        
        [self.view addSubview:lab];
        [self.view addSubview:self.circleImg];
        [self.view addSubview:self.circleLab];
        self.circleLab.hidden = NO;
        self.circleImg.hidden = YES;
        
        if (i == self.selectedIndex)
        {
            slideBg.center = CGPointMake(btn.center.x, btn.center.y);
        }
	}
	[self.view addSubview:slideBg];
}

- (void)selectedTab:(UIButton *)button{

	self.currentSelectedIndex = button.tag;
	self.selectedIndex = self.currentSelectedIndex;
    switch (button.tag) {
        case 0:
        {
            imgbg1.image = [UIImage imageNamed:@"footericon_bg.png"];
            imgbg2.image = nil;
            imgbg3.image = nil;
            imgbg4.image = nil;
            imgbg5.image = nil;
            lab1.textColor = [UIColor whiteColor];
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
            imgbg1.image = nil;
            imgbg2.image = [UIImage imageNamed:@"footericon_bg.png"];
            imgbg3.image = nil;
            imgbg4.image = nil;
            
            lab1.textColor = UICOLOR_RGBA(170, 170, 170, 1);
            img1.image = [UIImage imageNamed:@"footericon_1.png"];
            lab2.textColor = [UIColor whiteColor];
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
            imgbg1.image = nil;
            imgbg2.image = nil;
            imgbg3.image = [UIImage imageNamed:@"footericon_bg.png"];
            imgbg4.image = nil;
            imgbg5.image = nil;
            lab1.textColor = UICOLOR_RGBA(170, 170, 170, 1);
            img1.image = [UIImage imageNamed:@"footericon_1.png"];
            lab2.textColor = UICOLOR_RGBA(170, 170, 170, 1);
            img2.image = [UIImage imageNamed:@"footericon_2.png"];
            lab3.textColor = [UIColor whiteColor];
            img3.image = [UIImage imageNamed:@"footericon_3_down.png"];
            lab4.textColor = UICOLOR_RGBA(170, 170, 170, 1);
            img4.image = [UIImage imageNamed:@"footericon_4.png"];
            lab5.textColor = UICOLOR_RGBA(170, 170, 170, 1);
            img5.image = [UIImage imageNamed:@"footericon_4.png"];
        }
            
            break;
        case 3:
        {
            imgbg1.image = nil;
            imgbg2.image = nil;
            imgbg3.image = nil;
            imgbg4.image = [UIImage imageNamed:@"footericon_bg.png"];
            imgbg5.image = nil;
            lab1.textColor = UICOLOR_RGBA(170, 170, 170, 1);
            img1.image = [UIImage imageNamed:@"footericon_1.png"];
            lab2.textColor = UICOLOR_RGBA(170, 170, 170, 1);
            img2.image = [UIImage imageNamed:@"footericon_2.png"];
            lab3.textColor = UICOLOR_RGBA(170, 170, 170, 1);
            img3.image = [UIImage imageNamed:@"footericon_3.png"];
            lab4.textColor = [UIColor whiteColor];
            img4.image = [UIImage imageNamed:@"footericon_4_down.png"];
            lab5.textColor = UICOLOR_RGBA(170, 170, 170, 1);
            img5.image = [UIImage imageNamed:@"footericon_5.png"];
        }
            break;
        case 4:
        {
            imgbg1.image = nil;
            imgbg2.image = nil;
            imgbg3.image = nil;
            imgbg4.image = nil;
            imgbg5.image = [UIImage imageNamed:@"footericon_bg.png"];
            lab1.textColor = UICOLOR_RGBA(170, 170, 170, 1);
            img1.image = [UIImage imageNamed:@"footericon_1.png"];
            lab2.textColor = UICOLOR_RGBA(170, 170, 170, 1);
            img2.image = [UIImage imageNamed:@"footericon_2.png"];
            lab3.textColor = UICOLOR_RGBA(170, 170, 170, 1);
            img3.image = [UIImage imageNamed:@"footericon_3.png"];
            lab4.textColor = [UIColor whiteColor];
            img4.image = [UIImage imageNamed:@"footericon_4.png"];
            lab5.textColor = UICOLOR_RGBA(170, 170, 170, 1);
            img5.image = [UIImage imageNamed:@"footericon_5_down.png"];
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
    imgbg1.image = [UIImage imageNamed:@"footericon_bg.png"];
    imgbg2.image = nil;
    imgbg3.image = nil;
    imgbg4.image = nil;
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

#pragma mark - notification

- (void)reviceMessageCount:(NSNotification*)notification {
    NSDictionary *info = [notification userInfo];
    NSInteger count = [[info objectForKey:@"num"] integerValue];
    if (count == 0) {
        self.circleImg.hidden = YES;
    } else {
        self.circleImg.hidden = NO;
    }
}

@end
