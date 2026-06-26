//
// Created by Almas Adilbek on 11/8/14.
// Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

#import "NSDate+Ext.h"


@implementation NSDate (Ext)

+ (NSDate *)dateFromDefaultFormat:(NSString *)stringDate {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    return [df dateFromString:stringDate];
}

- (NSInteger)weekDayOrdinal {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [gregorian setFirstWeekday:2];
    NSUInteger adjustedWeekdayOrdinal = [gregorian ordinalityOfUnit:NSWeekdayCalendarUnit inUnit:NSWeekCalendarUnit forDate:[NSDate date]];
    return adjustedWeekdayOrdinal;
}

- (NSString *)timezone {
    NSDateFormatter *date_formater=[[NSDateFormatter alloc]init];
    [date_formater setDateFormat:@"Z"];
    NSString * tz=[date_formater stringFromDate:[NSDate date]];
    return tz;
}


@end