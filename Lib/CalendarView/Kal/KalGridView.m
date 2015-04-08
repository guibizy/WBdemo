/*
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import <CoreGraphics/CoreGraphics.h>

#import "KalGridView.h"
#import "KalView.h"
#import "KalMonthView.h"
#import "KalTileView.h"
#import "KalLogic.h"
#import "KalPrivate.h"
#import "NSDate+Convenience.h"

#define SLIDE_NONE 0
#define SLIDE_UP 1
#define SLIDE_DOWN 2

CGSize kTileSize; // width is auto for screen width in init function

static NSString *kSlideAnimationId = @"KalSwitchMonths";

@interface KalGridView ()

@property (nonatomic, strong) NSMutableArray *rangeArray;

- (void)swapMonthViews;

@end

@implementation KalGridView

- (void)setBeginDate:(NSDate *)beginDate
{
    _beginDate = beginDate;
}

- (void)setEndDate:(NSDate *)endDate {
    _endDate = endDate;
    
    // select + range
    NSMutableArray *allSelectStateArray = [NSMutableArray array];
    
    [allSelectStateArray addObjectsFromArray:self.selectDateArray];
    
    if (_endDate && _beginDate) {
        NSDate *realBeginDate;
        NSDate *realEndDate;
        if ([self.beginDate compare:self.endDate] == NSOrderedAscending) {
            realBeginDate = self.beginDate;
            realEndDate = self.endDate;
        } else {
            realBeginDate = self.endDate;
            realEndDate = self.beginDate;
        }
        NSInteger dayCount = [NSDate dayBetweenStartDate:realBeginDate endDate:realEndDate];
        for (int i=0; i<=dayCount; i++) {
            NSDate *nextDay = [realBeginDate offsetDay:i];
            if (self.isSelect) {
                if ([allSelectStateArray indexOfObject:nextDay] == NSNotFound) {
                    [allSelectStateArray addObject:nextDay];
                } else {
                    continue;
                }
            } else {
                if ([allSelectStateArray indexOfObject:nextDay] == NSNotFound) {
                    continue;
                } else {
                    [allSelectStateArray removeObject:nextDay];
                }
            }
        }
    }
    
    for (KalTileView *t in frontMonthView.subviews) {
        if ([allSelectStateArray indexOfObject:t.date] == NSNotFound
            || (t.type & KalTileTypeDisable)
            || (t.type & KalTileTypeConfirmed)) {
            t.state = KalTileStateNone;
        } else {
            t.state = KalTileStateSelected;
        }
    }
    
    
//    // show select state
//    for (NSDate *date in self.selectDateArray) {
//        KalTileView *tile = [frontMonthView tileForDate:date];
//        if (tile) {
//            tile.state = KalTileStateSelected;
//        }
//    }
//    
//    NSMutableArray *nowRangeArray = [NSMutableArray array];
//    NSMutableArray *lastRangeArray = self.rangeArray;
//    
//    if (_endDate) {
//        NSDate *realBeginDate;
//        NSDate *realEndDate;
//        if ([self.beginDate compare:self.endDate] == NSOrderedAscending) {
//            realBeginDate = self.beginDate;
//            realEndDate = self.endDate;
//        } else {
//            realBeginDate = self.endDate;
//            realEndDate = self.beginDate;
//        }
//        
//        NSInteger dayCount = [NSDate dayBetweenStartDate:realBeginDate endDate:realEndDate];
//        for (int i=0; i<=dayCount; i++) {
//            NSDate *nextDay = [realBeginDate offsetDay:i];
//            KalTileView *nextTile = [frontMonthView tileForDate:nextDay];
//            if (nextTile) {
//                if (self.isSelect) {
//                    nextTile.state = KalTileStateSelected;
//                } else {
//                    nextTile.state = KalTileStateNone;
//                }
//            }
//            
//            [nowRangeArray addObject:nextDay];
//        }
//        self.rangeArray = nowRangeArray;
//    }
//    
//    [lastRangeArray removeObjectsInArray:self.rangeArray];
//    for (NSDate *date in lastRangeArray) {
//        KalTileView *tile = [frontMonthView tileForDate:date];
//        if (tile) {
//            tile.state = KalTileStateNone;
//        }
//    }
}

- (id)initWithFrame:(CGRect)frame logic:(KalLogic *)theLogic delegate:(id<KalViewDelegate>)theDelegate{
    
    kTileSize = CGSizeMake(ceil(frame.size.width/7), 35.f);
    
    if (self = [super initWithFrame:frame]) {
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor whiteColor];
        logic = theLogic;
        delegate = theDelegate;
        self.rangeArray = [NSMutableArray array];
        self.selectDateArray = [NSMutableArray array];
        
        CGRect monthRect = CGRectMake(0.f, 0.f, frame.size.width, frame.size.height);
        frontMonthView = [[KalMonthView alloc] initWithFrame:monthRect];
        backMonthView = [[KalMonthView alloc] initWithFrame:monthRect];
        backMonthView.hidden = YES;
        [self addSubview:backMonthView];
        [self addSubview:frontMonthView];
        
        self.selectionMode = KalSelectionModeSingle;
        
        [self jumpToSelectedMonth];
    }
    return self;
}

- (void)sizeToFit
{
    self.height = frontMonthView.height;
}

#pragma mark -
#pragma mark Touches

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    UIView *hitView = [self hitTest:location withEvent:event];
    
    if (!hitView)
        return;
    
    if ([hitView isKindOfClass:[KalTileView class]]) {
        KalTileView *tile = (KalTileView*)hitView;
        if (tile.type & KalTileTypeDisable || tile.type & KalTileTypeConfirmed)
            return;
        if (tile.type & KalTileTypeAdjacent) {
            return;
        }
        
        switch (self.selectionMode) {
            case KalSelectionModeSingle:
            case KalSelectionModeRange:
                [self.selectDateArray removeAllObjects];
                self.isSelect = YES;
                break;
                
            case KalSelectionModeMultiSingle:
            case KalSelectionModeMultiRange:
                if (tile.state & KalTileStateSelected) {
                    self.isSelect = NO;
                } else {
                    self.isSelect = YES;
                }
                break;
                
            default:
                self.isSelect = YES;
                break;
        }
        
        self.beginDate = tile.date;
        self.endDate = tile.date;
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.transitioning == YES) {
        return;
    }
    
    if (self.selectionMode == KalSelectionModeSingle
        || self.selectionMode == KalSelectionModeMultiSingle)
        return;
    
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    UIView *hitView = [self hitTest:location withEvent:event];
    
    if (!hitView)
        return;
    
    if ([hitView isKindOfClass:[KalTileView class]]) {
        KalTileView *tile = (KalTileView*)hitView;
        
        if (tile.type & KalTileTypeAdjacent) {
            return;
        }
        
        NSDate *endDate = tile.date;
        if (!endDate) {
            return;
        }
        if (tile.belongsToAdjacentMonth
            && !(tile.type & KalTileTypeDisable || tile.type & KalTileTypeConfirmed)) {
            if ([tile.date compare:logic.baseDate] == NSOrderedDescending) {
                [delegate showFollowingMonth];
            } else {
                [delegate showPreviousMonth];
            }
        }
        self.endDate = endDate;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (self.beginDate == nil || self.endDate == nil) {
        return;
    }
    
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    UIView *hitView = [self hitTest:location withEvent:event];
    
    if ([hitView isKindOfClass:[KalTileView class]]) {
        KalTileView *tile = (KalTileView*)hitView;
        if ((tile.type & KalTileTypeDisable) == 0 && (tile.type & KalTileTypeConfirmed) == 0) {
            if (tile.belongsToAdjacentMonth) {
                if ([tile.date compare:logic.baseDate] == NSOrderedDescending) {
                    [delegate showFollowingMonth];
                } else {
                    [delegate showPreviousMonth];
                }
            }
        }
        
        NSDate *realBeginDate = self.beginDate;
        NSDate *realEndDate = self.endDate;
        if ([self.beginDate compare:self.endDate] == NSOrderedDescending) {
            realBeginDate = tile.date;
            realEndDate = self.beginDate;
        }
        [self addDateToArrayWithBeginDate:realBeginDate endDate:realEndDate];
        
        if ([(id)delegate respondsToSelector:@selector(didSelectDateArray:)]) {
            [delegate didSelectDateArray:self.selectDateArray];
        }
        
        self.beginDate = nil;
        self.endDate = nil;
    }
}

- (void)addDateToArrayWithBeginDate:(NSDate *)beginDate endDate:(NSDate *)endDate {
    NSArray *inRangeDateArray = [NSDate dateArrayBetweenDateRangeWithDateArray:self.selectDateArray date1:beginDate date2:endDate];
    NSMutableArray *selectArray = [NSMutableArray arrayWithArray:self.selectDateArray];
    [selectArray removeObjectsInArray:inRangeDateArray];
    if (self.isSelect == YES) {
        NSInteger dayCount = [NSDate dayBetweenStartDate:beginDate endDate:endDate];
        for (int i=0; i<=dayCount; i++) {
            NSDate *nextDay = [beginDate offsetDay:i];
            [selectArray addObject:nextDay];
        }
    } else {
        
    }
    self.selectDateArray = selectArray;
}

#pragma mark -
#pragma mark Slide Animation

- (void)swapMonthsAndSlide:(int)direction keepOneRow:(BOOL)keepOneRow
{
    backMonthView.hidden = NO;
    
    // set initial positions before the slide
    if (direction == SLIDE_UP) {
        backMonthView.top = keepOneRow
        ? frontMonthView.bottom - kTileSize.height
        : frontMonthView.bottom;
    } else if (direction == SLIDE_DOWN) {
        NSUInteger numWeeksToKeep = keepOneRow ? 1 : 0;
        NSInteger numWeeksToSlide = [backMonthView numWeeks] - numWeeksToKeep;
        backMonthView.top = -numWeeksToSlide * kTileSize.height;
    } else {
        backMonthView.top = 0.f;
    }
    
    // trigger the slide animation
    [UIView beginAnimations:kSlideAnimationId context:NULL]; {
        [UIView setAnimationsEnabled:direction!=SLIDE_NONE];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
        
        frontMonthView.top = -backMonthView.top;
        backMonthView.top = 0.f;
        
        frontMonthView.alpha = 0.f;
        backMonthView.alpha = 1.f;
        
        self.height = backMonthView.height;
        
        [self swapMonthViews];
    } [UIView commitAnimations];
    [UIView setAnimationsEnabled:YES];
}

- (void)slide:(int)direction
{
    self.transitioning = YES;

    [backMonthView showDates:logic.daysInSelectedMonth
        leadingAdjacentDates:logic.daysInFinalWeekOfPreviousMonth
       trailingAdjacentDates:logic.daysInFirstWeekOfFollowingMonth
            minAvailableDate:self.minAvailableDate
            maxAvailableDate:self.maxAVailableDate
                disableDates:self.disableDates
              confirmedDates:self.confirmedDates];
    
    [self.selectDateArray addObjectsFromArray:self.selectedDates];
    
    // At this point, the calendar logic has already been advanced or retreated to the
    // following/previous month, so in order to determine whether there are
    // any cells to keep, we need to check for a partial week in the month
    // that is sliding offscreen.
    
    BOOL keepOneRow = (direction == SLIDE_UP && [logic.daysInFinalWeekOfPreviousMonth count] > 0)
    || (direction == SLIDE_DOWN && [logic.daysInFirstWeekOfFollowingMonth count] > 0);
    
    [self swapMonthsAndSlide:direction keepOneRow:keepOneRow];
    
    self.endDate = _endDate;
}

- (void)slideUp { [self slide:SLIDE_UP]; }
- (void)slideDown { [self slide:SLIDE_DOWN]; }

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    self.transitioning = NO;
    backMonthView.hidden = YES;
}

#pragma mark -

- (void)swapMonthViews
{
    KalMonthView *tmp = backMonthView;
    backMonthView = frontMonthView;
    frontMonthView = tmp;
    [self exchangeSubviewAtIndex:[self.subviews indexOfObject:frontMonthView] withSubviewAtIndex:[self.subviews indexOfObject:backMonthView]];
}

- (void)jumpToSelectedMonth
{
    [self slide:SLIDE_NONE];
}

@end
