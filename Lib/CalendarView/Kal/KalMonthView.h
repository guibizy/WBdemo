/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import <UIKit/UIKit.h>

@class KalTileView;

@interface KalMonthView : UIView
{
  NSUInteger numWeeks;
  NSDateFormatter *tileAccessibilityFormatter;
}

@property (nonatomic) NSUInteger numWeeks;

- (id)initWithFrame:(CGRect)rect; // designated initializer

- (void)showDates:(NSArray *)mainDates
leadingAdjacentDates:(NSArray *)leadingAdjacentDates
trailingAdjacentDates:(NSArray *)trailingAdjacentDates
 minAvailableDate:(NSDate *)minAvailableDate
 maxAvailableDate:(NSDate *)maxAvailableDate
     disableDates:(NSArray *)disableDates
   confirmedDates:(NSArray *)confirmedDates;

- (KalTileView *)firstTileOfMonth;
- (KalTileView *)tileForDate:(NSDate *)date;

@end
