
#import "CalendarVC.h"

#import "KalLogic.h"
#import "KalPrivate.h"
#import "NSDate+Convenience.h"

NSString *const KalDataSourceChangedNotification = @"KalDataSourceChangedNotification";

@interface CalendarVC ()

@property (nonatomic, strong) KalView *kalView;

@property (nonatomic, strong) KalLogic *logic;

@property (nonatomic, strong) NSArray *selectDateArray;

- (KalView*)calendarView;

@end

@implementation CalendarVC

- (void)setMinAvailableDate:(NSDate *)minAvailableDate
{
    _minAvailableDate = minAvailableDate;
    self.kalView.gridView.minAvailableDate = minAvailableDate;
    [self.kalView redrawEntireMonth];
}

- (void)setMaxAVailableDate:(NSDate *)maxAVailableDate
{
    _maxAVailableDate = maxAVailableDate;
    self.kalView.gridView.maxAVailableDate = maxAVailableDate;
    [self.kalView redrawEntireMonth];
}

- (void)setDisableDates:(NSArray *)disableDates {
    _disableDates = disableDates;
    
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:disableDates.count];
    for (NSDate *date in disableDates) {
        [arr addObject:[NSDate dateStartOfDay:date]];
    }
    self.kalView.gridView.disableDates = arr;
    [self.kalView redrawEntireMonth];
}

- (void)setConfirmedDates:(NSArray *)confirmedDates {
    _confirmedDates = confirmedDates;
    
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:confirmedDates.count];
    for (NSDate *date in confirmedDates) {
        [arr addObject:[NSDate dateStartOfDay:date]];
    }
    self.kalView.gridView.confirmedDates = arr;
    [self.kalView redrawEntireMonth];
}

- (void)setSelectedDates:(NSArray *)selectedDates {
    _selectedDates = selectedDates;
    
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:selectedDates.count];
    for (NSDate *date in selectedDates) {
        [arr addObject:[NSDate dateStartOfDay:date]];
    }
    self.kalView.gridView.selectedDates = arr;
    [self.kalView redrawEntireMonth];
}

#pragma mark

- (void)setShowState:(BOOL)showState {
    _showState = showState;
    
    self.kalView.gridView.userInteractionEnabled = !showState;
}

- (id)initWithSelectionMode:(KalSelectionMode)selectionMode;
{
    if ((self = [super init])) {
        self.logic = [[KalLogic alloc] initForDate:[NSDate date]];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(significantTimeChangeOccurred) name:UIApplicationSignificantTimeChangeNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:KalDataSourceChangedNotification object:nil];
        self.selectionMode = selectionMode;
        if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }
    }
    return self;
}

- (id)init
{
    return [self initWithSelectionMode:KalSelectionModeSingle];
}

- (KalView*)calendarView { return self.kalView; }

- (void)significantTimeChangeOccurred
{
    [[self calendarView] jumpToSelectedMonth];
}

// -----------------------------------------
#pragma mark KalViewDelegate protocol

- (void)didSelectDateArray:(NSArray *)dateArray {
    self.selectDateArray = [dateArray copy];
}

- (void)showPreviousMonth
{
    [self.logic retreatToPreviousMonth];
    [[self calendarView] slideDown];
}

- (void)showFollowingMonth
{
    [self.logic advanceToFollowingMonth];
    [[self calendarView] slideUp];
}

// ---------------------------------------
#pragma mark -

- (void)showAndSelectDate:(NSDate *)date
{
    if ([[self calendarView] isSliding])
        return;
    
    [self.logic moveToMonthForDate:date];
    
    [[self calendarView] jumpToSelectedMonth];
}

// -----------------------------------------------------------------------------------
#pragma mark UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!self.title)
        self.title = @"Calendar";
    
    self.view.clipsToBounds = YES;
    
    self.kalView = [[KalView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 266) delegate:self logic:self.logic];
    self.kalView.gridView.selectionMode = self.selectionMode;
    [self.view addSubview:self.kalView];
    
    UIView *line1 = [[UIView alloc] init];
    line1.frame = CGRectMake(0, 266, SCREEN_WIDTH, 1);
    line1.backgroundColor = UICOLOR_RGBA(238, 238, 240, 1);
    [self.view addSubview:line1];
    
    UIView *line2 = [[UIView alloc] init];
    line2.frame = CGRectMake(0, 306-1, SCREEN_WIDTH, 1);
    line2.backgroundColor = UICOLOR_RGBA(238, 238, 240, 1);
    [self.view addSubview:line2];
    
    UIButton *subminButton = [UIButton buttonWithType:UIButtonTypeCustom];
    subminButton.frame = CGRectMake(0, 266, SCREEN_WIDTH, 40);
    [subminButton setTitle:@"确认" forState:UIControlStateNormal];
    [subminButton setTitleColor:UICOLOR_RGBA(33, 185, 248, 1) forState:UIControlStateNormal];
    [subminButton setBackgroundImage:[UIImage imageNamed:@"black_alpha_0.07"] forState:UIControlStateHighlighted];
    [subminButton addTarget:self action:@selector(subminOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:subminButton];
    
    self.view.backgroundColor = [UIColor whiteColor];
}

#pragma mark - on click

- (void)subminOnClick:(UIButton *)button {
    if (self.block) {
        self.block(self.kalView.gridView.selectDateArray);
    }
}

#pragma mark -

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationSignificantTimeChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KalDataSourceChangedNotification object:nil];
}

@end
