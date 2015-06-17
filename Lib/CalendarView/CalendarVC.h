

#import <UIKit/UIKit.h>

#import "KalView.h"       // for the KalViewDelegate protocol

typedef void (^SubminButtonOnClick)(NSArray *selectDateArray);

@interface CalendarVC : UIViewController <KalViewDelegate>

@property (nonatomic, assign) KalSelectionMode selectionMode;
@property (nonatomic, strong) NSDate *minAvailableDate;
@property (nonatomic, strong) NSDate *maxAVailableDate;
@property (nonatomic, strong) NSArray *disableDates;
@property (nonatomic, strong) NSArray *confirmedDates;
@property (nonatomic, strong) NSArray *selectedDates; // 默认选中的日期数组

@property (nonatomic, assign) BOOL showState; // could not select ,only can be change month

@property (nonatomic, copy) SubminButtonOnClick block;

- (id)initWithSelectionMode:(KalSelectionMode)selectionMode;
- (void)showAndSelectDate:(NSDate *)date;           // Updates the state of the calendar to display the specified date's month and selects the tile for that date.

@end
