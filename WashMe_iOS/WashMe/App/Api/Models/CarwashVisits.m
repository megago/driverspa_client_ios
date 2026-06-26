//
//  CarwashVisits.m
//  WashMe
//
//  Created by Ivan Korotkikh on 31.12.16.
//  Copyright © 2016 Almas Adilbek. All rights reserved.
//

#import "CarwashVisits.h"

@implementation CarwashVisits

+ (CarwashVisits *)instanceFromDictionary:(NSDictionary *)aDictionary {
    
    CarwashVisits *instance = [[CarwashVisits alloc] init];
    [instance setAttributesFromDictionary:aDictionary];
    return instance;
    
}

- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary {
    
    if (![aDictionary isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    objectData = aDictionary;
    
    self.name = [self stringValueForKey:@"name"];
    self.phone = [self stringValueForKey:@"mobile"];
    self.carNumber = [self stringValueForKey:@"car_no"];
    self.carMark = [self stringValueForKey:@"car_type"];
    self.profileImageUrl = [self stringValueForKey:@"avatar"];
    self.finishedBooksCount = [self numberValueForKey:@"finished_books_counts"];
    self.rejectedByClientBooksCount = [self numberValueForKey:@"rejected_by_client_books_count"];
    self.nocomeBookCount = [self numberValueForKey:@"nocome_books_count"];
    self.isRegistered = [self boolValueForKey:@"is_registered"];
    
    //double timestampval1 =  [[self numberValueForKey:@"last_finished_book_date"] doubleValue];
    //NSTimeInterval timestamp1 = (NSTimeInterval)timestampval1;
    //self.lastFinishedBookDate = [NSDate dateWithTimeIntervalSince1970:timestamp1];
    
    self.lastFinishedBookDate = [NSDate date];
    
    objectData = nil;
    
}

@end
