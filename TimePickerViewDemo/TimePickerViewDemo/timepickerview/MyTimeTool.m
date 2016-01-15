//
//  TimeTool.m
//  TimePicker
//
//  Created by App on 1/14/16.
//  Copyright © 2016 App. All rights reserved.
//

#import "MyTimeTool.h"
#define MAXCOUNTDAYS 100

@implementation MyTimeTool

+(NSArray *)daysFromNowToDeadLine:(NSString *)deadLine{
    
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"yyyyMMdd"];
    NSDate *startDate = [f dateFromString:[self summaryTimeUsingDate:[NSDate date]]];
    NSDate *endDate = [f dateFromString:deadLine];
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay
                                                        fromDate:startDate
                                                          toDate:endDate
                                                         options:NSCalendarWrapComponents];
    int diffDays = components.day;
    if(diffDays==0) return @[[self summaryTimeUsingDate:[NSDate date]]];
    NSMutableArray *dayArray = [NSMutableArray array];
    if(diffDays > MAXCOUNTDAYS) diffDays = MAXCOUNTDAYS;
    for (int i = 0; i <= diffDays; i++) {
        NSTimeInterval  iDay = 24*60*60*i;  //1天的长度
        NSDate *date = [[NSDate alloc] initWithTimeIntervalSinceNow:iDay];
        [dayArray addObject:[self summaryTimeUsingDate:date]];
    }
    return dayArray;
}

+(int)currentDateHour{
    NSLog(@"hour is: %d", [self dateComponents].hour);
    return [self dateComponents].hour;
}

+(int)currentDateMinute{
    NSLog(@"minute is: %d", [self dateComponents].minute);
    return [self dateComponents].minute;
}

+(NSDateComponents *)dateComponents{
    NSDate *currentDate = [NSDate date];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:currentDate];
    return dateComponent;
}

+(NSString *)summaryTimeUsingDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    return dateString;
}

+(NSString *)summaryTimeUsingDate1:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    return dateString;
}

+(NSString *)displayedSummaryTimeUsingString:(NSString *)string
{
    NSMutableString *result = [[NSMutableString alloc] initWithString:[string substringWithRange:NSMakeRange(0, 4)]];
    [result appendString:@"-"];
    [result appendString:[string substringWithRange:NSMakeRange(4, 2)]];
    [result appendString:@"-"];
    [result appendString:[string substringWithRange:NSMakeRange(6, 2)]];
    return result;
}

@end
