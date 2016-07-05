//
// Created by Almas Adilbek on 11/8/14.
// Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Ext)

+ (NSDate *)dateFromDefaultFormat:(NSString *)stringDate;
- (NSInteger)weekDayOrdinal;

- (NSString *)timezone;

@end