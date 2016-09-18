//
//  BookObject.m
//  WashMe
//
//  Created by Almas Adilbek on 11/11/14.
//  Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

#import "BookObject.h"
#import "CarwashComplex.h"
#import "IdTitleObject.h"
#import "NSString+Ext.h"
#import "NSDate+Utilities.h"

@implementation BookObject

- (NSString *)localizedPrice {
    return [NSString stringWithFormat:@"%@ тг.", [NSString numberFormattedNumberText:self.price]];
}

- (NSString *)servicesTitles {
    NSMutableArray *array = [NSMutableArray array];
    for(IdTitleObject *obj in self.services) {
        [array addObject:obj.title];
    }
    return [array componentsJoinedByString:@", "];
}

- (NSString *)prettyTime {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy.MM.dd"];
    return [NSString stringWithFormat:@"%@ в %@", [df stringFromDate:self.bookDate], self.bookTime];
}

- (NSString *)localizedDaysAgo
{
    if ([self.bookDate isTomorrow]){
        return @"завтра";
    }
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitDay
                                               fromDate:self.bookDate
                                                 toDate:[NSDate date]
                                                options:0];
    NSString *str = [NSString stringWithFormat:@"%ld", components.day];
    NSString *lastChar = [str substringFromIndex:[str length] - 1];
    
    if ([lastChar isEqualToString:@"0"]) {
        return @"cегодня";
    } else if ([lastChar isEqualToString:@"1"]) {
        return [NSString stringWithFormat:@"%ld день назад", components.day];
    } else if ([lastChar isEqualToString:@"2"] || [lastChar isEqualToString:@"3"] || [lastChar isEqualToString:@"4"]){
        return [NSString stringWithFormat:@"%ld дня назад", components.day];
    }
    return [NSString stringWithFormat:@"%ld дней назад", components.day];
}

@end
