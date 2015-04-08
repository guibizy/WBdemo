/*
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import <CoreGraphics/CoreGraphics.h>
#import "KalMonthView.h"
#import "KalTileView.h"
#import "KalView.h"
#import "KalPrivate.h"
#import "NSDate+Convenience.h"

extern const CGSize kTileSize;

@implementation KalMonthView

@synthesize numWeeks;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        tileAccessibilityFormatter = [[NSDateFormatter alloc] init];
        [tileAccessibilityFormatter setDateFormat:@"EEEE, MMMM d"];
        self.opaque = NO;
        self.clipsToBounds = YES;
        for (int i=0; i<6; i++) {
            for (int j=0; j<7; j++) {
                CGRect r = CGRectMake(j*kTileSize.width, i*kTileSize.height, kTileSize.width, kTileSize.height);
                [self addSubview:[[KalTileView alloc] initWithFrame:r]];
            }
        }
    }
    return self;
}

- (void)showDates:(NSArray *)mainDates
leadingAdjacentDates:(NSArray *)leadingAdjacentDates
trailingAdjacentDates:(NSArray *)trailingAdjacentDates
 minAvailableDate:(NSDate *)minAvailableDate
 maxAvailableDate:(NSDate *)maxAvailableDate
     disableDates:(NSArray *)disableDates
   confirmedDates:(NSArray *)confirmedDates {
    
    int tileNum = 0;
    NSArray *dates[] = { leadingAdjacentDates, mainDates, trailingAdjacentDates };
    
    for (int i=0; i<3; i++) {
        for (int j=0; j<dates[i].count; j++) {
            NSDate *d = dates[i][j];
            KalTileView *tile = [self.subviews objectAtIndex:tileNum];
            [tile resetState];
            tile.date = d;
            
            if ((minAvailableDate && [d compare:minAvailableDate] == NSOrderedAscending)
                || (maxAvailableDate && [d compare:maxAvailableDate] == NSOrderedDescending)
                || (disableDates && [disableDates indexOfObject:d] != NSNotFound)) {
                tile.type = KalTileTypeDisable;
            }
            if (confirmedDates && [confirmedDates indexOfObject:d] != NSNotFound) {
                tile.type = KalTileTypeConfirmed;
            }
            if (i == 0 && j == 0) {
                tile.type |= KalTileTypeFirst;
            }
            if (i == 2 && j == dates[i].count-1) {
                tile.type |= KalTileTypeLast;
            }
            if (dates[i] != mainDates) {
                tile.type |= KalTileTypeAdjacent;
            }
            if ([d isToday]) {
                tile.type |= KalTileTypeToday;
            }
            tileNum++;
        }
    }
    
    numWeeks = ceilf(tileNum / 7.f);
    [self sizeToFit];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextDrawTiledImage(ctx, (CGRect){CGPointZero,kTileSize}, [[UIImage imageNamed:@"Kal.bundle/kal_tile.png"] CGImage]);
}

- (KalTileView *)firstTileOfMonth
{
    KalTileView *tile = nil;
    for (KalTileView *t in self.subviews) {
        if (!t.belongsToAdjacentMonth) {
            tile = t;
            break;
        }
    }
    
    return tile;
}

- (KalTileView *)tileForDate:(NSDate *)date
{
    KalTileView *tile = nil;
    for (KalTileView *t in self.subviews) {
        if ([t.date isEqualToDate:date]) {
            tile = t;
            break;
        }
    }
    return tile;
}

- (void)sizeToFit
{
    self.height = 1.f + kTileSize.height * numWeeks;
}

#pragma mark -


@end
