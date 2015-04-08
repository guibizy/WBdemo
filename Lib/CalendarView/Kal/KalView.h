/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import <UIKit/UIKit.h>
#import "KalGridView.h"

@class KalLogic;
@protocol KalViewDelegate, KalDataSourceCallbacks;

@interface KalView : UIView
{
  UILabel *headerTitleLabel;
  KalLogic *logic;
}

@property (nonatomic, weak) id<KalViewDelegate> delegate;
@property (nonatomic, strong) KalGridView *gridView;

- (id)initWithFrame:(CGRect)frame delegate:(id<KalViewDelegate>)delegate logic:(KalLogic *)logic;
- (BOOL)isSliding;
- (void)redrawEntireMonth;

// These 3 methods are exposed for the delegate. They should be called 
// *after* the KalLogic has moved to the month specified by the user.
- (void)slideDown;
- (void)slideUp;
- (void)jumpToSelectedMonth;    // change months without animation (i.e. when directly switching to "Today")

@end

#pragma mark -

@protocol KalViewDelegate

- (void)didSelectDateArray:(NSArray *)dateArray; 

@optional

- (void)showPreviousMonth;
- (void)showFollowingMonth;

@end
