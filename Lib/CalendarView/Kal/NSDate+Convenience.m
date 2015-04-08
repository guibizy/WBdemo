//
//  NSDate+Convenience.m
//  FiveStar
//
//  Created by Leon on 13-1-14.
//
//

@implementation NSDate (Convenience)

- (NSInteger)year {
    NSCalendar *gregorian = [[NSCalendar alloc]
            initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorian components:NSYearCalendarUnit fromDate:self];
    return [components year];
}


- (NSInteger)month {
    NSCalendar *gregorian = [[NSCalendar alloc]
            initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorian components:NSMonthCalendarUnit fromDate:self];
    return [components month];
}

- (NSInteger)day {
    NSCalendar *gregorian = [[NSCalendar alloc]
            initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorian components:NSDayCalendarUnit fromDate:self];
    return [components day];
}

- (NSInteger)hour {
    NSCalendar *gregorian = [[NSCalendar alloc]
            initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorian components:NSHourCalendarUnit fromDate:self];
    return [components hour];
}

- (NSDate *)offsetDay:(NSInteger)numDays {
    NSCalendar *gregorian = [[NSCalendar alloc]
            initWithCalendarIdentifier:NSGregorianCalendar];
//    [gregorian setFirstWeekday:2]; //monday is first day

    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setDay:numDays];
    //[offsetComponents setHour:1];
    //[offsetComponents setMinute:30];

    return [gregorian dateByAddingComponents:offsetComponents
                                      toDate:self options:0];
}

- (BOOL)isToday
{
    return [[NSDate dateStartOfDay:self] isEqualToDate:[NSDate dateStartOfDay:[NSDate date]]];
}

+ (NSDate *)dateForDay:(NSInteger)day month:(NSInteger)month year:(NSInteger)year
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.day = day;
    components.month = month;
    components.year = year;
    return [gregorian dateFromComponents:components];
}

+ (NSDate *)dateStartOfDay:(NSDate *)date {
    NSCalendar *gregorian = [[NSCalendar alloc]
            initWithCalendarIdentifier:NSGregorianCalendar];

    NSDateComponents *components =
            [gregorian               components:(NSYearCalendarUnit | NSMonthCalendarUnit |
                    NSDayCalendarUnit) fromDate:date];
    return [gregorian dateFromComponents:components];
}

- (NSString *)weekString {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *dateComponents = [calendar components:NSCalendarUnitWeekday fromDate:self];
    switch (dateComponents.weekday) {
        case 1: {
            return NSLocalizedString(@"sunday", @"");
        }
            break;

        case 2: {
            return NSLocalizedString(@"monday", @"");
        }
            break;

        case 3: {
            return NSLocalizedString(@"tuesday", @"");
        }
            break;

        case 4: {
            return NSLocalizedString(@"wednesday", @"");
        }
            break;

        case 5: {
            return NSLocalizedString(@"thursday", @"");
        }
            break;

        case 6: {
            return NSLocalizedString(@"friday", @"");
        }
            break;

        case 7: {
            return NSLocalizedString(@"saturday", @"");
        }
            break;

        default:
            break;
    }

    return @"";
}

+ (NSInteger)dayBetweenStartDate:(NSDate *)startDate endDate:(NSDate *)endDate {
    NSCalendar *calendar = [[NSCalendar alloc]
            initWithCalendarIdentifier:NSGregorianCalendar];
    unsigned int unitFlags = NSDayCalendarUnit;
    NSDateComponents *comps = [calendar components:unitFlags fromDate:startDate toDate:endDate options:0];
    //    int months = [comps month];
    NSInteger days = [comps day];
    return days;
}

+ (NSDate *)dateFromString:(NSString *)dateString format:(NSString *)format {
    if (!format)
        format = @"yyyy-MM-dd";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormatter setDateFormat:format];
    NSDate *date = [dateFormatter dateFromString:dateString];
    return date;
}

+ (NSString *)stringFromDate:(NSDate *)date format:(NSString *)format {
    if (!format)
        format = @"yyyy-MM-dd";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSString *dateString = [dateFormatter stringFromDate:date];
    return dateString;
}


+ (NSDate *)dateFromString:(NSString *)dateString {
    return [self dateFromStringBySpecifyTime:dateString hour:0 minute:0 second:0];
}

+ (NSDate *)dateFromStringBySpecifyTime:(NSString *)dateString hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second {
    NSArray *arrayDayTime = [dateString componentsSeparatedByString:@" "];
    NSArray *arrayDay = [arrayDayTime[0] componentsSeparatedByString:@"-"];

    NSInteger flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *tmpDateComponents = [calendar components:flags fromDate:[NSDate date]];
    tmpDateComponents.year = [arrayDay[0] intValue];
    tmpDateComponents.month = [arrayDay[1] intValue];
    tmpDateComponents.day = [arrayDay[2] intValue];
    if ([arrayDayTime count] > 1) {
        NSArray *arrayTime = [arrayDayTime[1] componentsSeparatedByString:@":"];
        tmpDateComponents.hour = [arrayTime[0] intValue];
        tmpDateComponents.minute = [arrayTime[1] intValue];
        tmpDateComponents.second = [arrayTime[2] intValue];
    }
    else {
        tmpDateComponents.hour = hour;
        tmpDateComponents.minute = minute;
        tmpDateComponents.second = second;
    }
    return [calendar dateFromComponents:tmpDateComponents];
}

+ (NSDateComponents *)nowDateComponents {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    return [calendar components:flags fromDate:[NSDate date]];
}

+ (NSDateComponents *)dateComponentsFromNow:(NSInteger)days {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    return [calendar components:flags fromDate:[[NSDate date] dateByAddingTimeInterval:days * 24 * 60 * 60]];
}

+ (BOOL)isBetweenWithDate:(NSDate *)date date1:(NSDate *)date1 date2:(NSDate *)date2 {
    NSDate *beginDate = nil;
    NSDate *endDate = nil;
    
//    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger desiredComponents = (NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit);
    
    NSComparisonResult result = NSOrderedSame;
//    result = [calendar compareDate:date1 toDate:date2 toUnitGranularity:desiredComponents];
    result = [self compareDate:date1 toDate:date2 toUnitGranularity:desiredComponents];
    if (result == NSOrderedAscending) {
        beginDate = date1;
        endDate = date2;
    } else if (result == NSOrderedDescending) {
        beginDate = date1;
        endDate = date2;
    }  else {
        beginDate = date2;
        endDate = date1;
    }
    
//    result = [calendar compareDate:date toDate:beginDate toUnitGranularity:desiredComponents];
    result = [self compareDate:date toDate:beginDate toUnitGranularity:desiredComponents];
    if (result == NSOrderedAscending) {
        return NO;
    } else if (result == NSOrderedDescending) {
        
    } else {
        return YES;
    }
    
//    result = [calendar compareDate:date toDate:endDate toUnitGranularity:desiredComponents];
    result = [self compareDate:date toDate:endDate toUnitGranularity:desiredComponents];
    if (result == NSOrderedAscending) {
        
    } else if (result == NSOrderedDescending) {
        return NO;
    } else {
        return YES;
    }
    
    return YES;
}

+ (NSArray *)dateArrayBetweenDateRangeWithDateArray:(NSArray *)dateArray date1:(NSDate *)date1 date2:(NSDate *)date2 {
    NSMutableArray *betweenArray = [NSMutableArray array];
    
    NSDate *beginDate = nil;
    NSDate *endDate = nil;
    
//    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger desiredComponents = (NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit);
    
    NSComparisonResult result = NSOrderedSame;
//    result = [calendar compareDate:date1 toDate:date2 toUnitGranularity:desiredComponents];
    result = [self compareDate:date1 toDate:date2 toUnitGranularity:desiredComponents];
    if (result == NSOrderedAscending) {
        beginDate = date1;
        endDate = date2;
    } else if (result == NSOrderedDescending) {
        beginDate = date1;
        endDate = date2;
    }  else {
        beginDate = date2;
        endDate = date1;
    }
    
    for (NSDate *date in dateArray) {
//        result = [calendar compareDate:date toDate:beginDate toUnitGranularity:desiredComponents];
        result = [self compareDate:date toDate:beginDate toUnitGranularity:desiredComponents];
        if (result == NSOrderedAscending) {
            continue;
        } else if (result == NSOrderedDescending) {
            
        } else {
            [betweenArray addObject:date];
            continue;
        }
        
//        result = [calendar compareDate:date toDate:endDate toUnitGranularity:desiredComponents];
        result = [self compareDate:date toDate:endDate toUnitGranularity:desiredComponents];
        if (result == NSOrderedAscending) {
            
        } else if (result == NSOrderedDescending) {
            continue;
        } else {
            [betweenArray addObject:date];
            continue;
        }
        
        [betweenArray addObject:date];
        continue;
    }
    
    return betweenArray;
}

// 暂时替代方法 [calendar compareDate:date toDate:endDate toUnitGranularity:desiredComponents];
// 最低支持ios8之后此方法将被放弃
+ (NSComparisonResult)compareDate:(NSDate *)date1 toDate:(NSDate *)date2 toUnitGranularity:(NSCalendarUnit)unit {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:unit fromDate:date1 toDate:date2 options:NSCalendarWrapComponents];
    if (components.year==0 && components.month==0 && components.day==0) {
        return NSOrderedSame;
    }
    if (components.year<0 || components.month<0 || components.day<0) {
        return NSOrderedDescending;
    }
    if (components.year>0 || components.month>0 || components.day>0) {
        return NSOrderedAscending;
    }
    
    NSAssert(1!=1, @"计算时间错误");
    
    return NSOrderedSame;
}

//
+(NSString *)dateFromStringInWeiBo:(NSString *)dateString{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"EEE MMM d HH:mm:ss Z yyyy"];
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    NSDate *createDate = [formatter dateFromString:dateString];
    NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
    [formatter2 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [NSString stringWithFormat:@"%@",[formatter2 stringFromDate:createDate]];
}
@end
