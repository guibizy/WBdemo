/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import <UIKit/UIKit.h>

typedef enum {
    KalSelectionModeSingle = 0,  // only one single
    KalSelectionModeMultiSingle, // many single
    KalSelectionModeRange,       // only one range
    KalSelectionModeMultiRange,  // many range
} KalSelectionMode;

@class KalTileView, KalMonthView, KalLogic;
@protocol KalViewDelegate;

/*
 *    KalGridView
 *    ------------------
 *
 *    Private interface
 *
 *  As a client of the Kal system you should not need to use this class directly
 *  (it is managed by KalView).
 *
 */
@interface KalGridView : UIView
{
  id<KalViewDelegate> __weak delegate;  // Assigned.
  KalLogic *logic;
  KalMonthView *frontMonthView;
  KalMonthView *backMonthView;
}

@property (nonatomic, assign) BOOL transitioning;
@property (nonatomic, assign) KalSelectionMode selectionMode;
@property (nonatomic, strong) NSDate *minAvailableDate;
@property (nonatomic, strong) NSDate *maxAVailableDate;
@property (nonatomic, strong) NSArray *disableDates;
@property (nonatomic, strong) NSArray *confirmedDates;
@property (nonatomic, strong) NSArray *selectedDates;
@property (nonatomic, strong) NSDate *beginDate;
@property (nonatomic, strong) NSDate *endDate;
@property (nonatomic, assign) BOOL isSelect; // this range is select or reject
@property (nonatomic, strong) NSMutableArray *selectDateArray;

- (id)initWithFrame:(CGRect)frame logic:(KalLogic *)logic delegate:(id<KalViewDelegate>)delegate;

// These 3 methods should be called *after* the KalLogic
// has moved to the previous or following month.
- (void)slideUp;
- (void)slideDown;
- (void)jumpToSelectedMonth;    // see comment on KalView

@end
