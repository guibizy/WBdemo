//
//  PublishAddWB.m
//  WBdemo
//
//  Created by guibi on 15/4/30.
//  Copyright (c) 2015年 74td. All rights reserved.
//

#import "PublishAddWB.h"

#import "PublishWB.h"
#import "AppDelegate.h"

@interface PublishAddWB ()


@property(strong,nonatomic) PublishAddWB *this;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewNslayHeight;
@property (weak, nonatomic) IBOutlet UIView *viewOfadd;
@property (weak, nonatomic) IBOutlet UIView *barView;

@end

@implementation PublishAddWB

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view bringSubviewToFront:self.barView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void) addViewForShare {
    self.this = self;
    
    UIWindow * keyWindow = [[UIApplication sharedApplication] keyWindow];
    if (![self.view.superview isEqual:keyWindow]) {
        self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        [keyWindow addSubview:self.view];
    }
    
    self.view.alpha = 0;
    [UIView animateWithDuration:0.35 animations:^{
        self.view.alpha =1;
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            self.viewNslayHeight.constant = 0;
            [self.viewOfadd layoutIfNeeded];
        } completion:^(BOOL finished) {
            
        }];
    }];
}
- (void) removeView{
    self.view.alpha = 1;
    [UIView animateWithDuration:0.3 animations:^{
        self.viewNslayHeight.constant = -290;
        [self.viewOfadd layoutIfNeeded];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.35 animations:^{
            self.view.alpha = 0;
        } completion:^(BOOL finished) {
            [self.view removeFromSuperview];
            self.this = nil;
        }];
    }];
    
}
- (IBAction)removeSelf:(id)sender {
    [self removeView];
}
- (IBAction)pushtoPublish:(id)sender {
    PublishWB *add = [[PublishWB alloc]init];
    [self removeView];
    add.WBstatus = 3;
    GetAppDelegate;
    [appDelegate.navController pushViewController:add animated:YES];
}
- (IBAction)pushtoPublishWithphoto:(id)sender {
    PublishWB *add = [[PublishWB alloc]init];
    [self removeView];
    add.WBstatus = 4;
    GetAppDelegate;
    [appDelegate.navController pushViewController:add animated:YES];
}

@end
