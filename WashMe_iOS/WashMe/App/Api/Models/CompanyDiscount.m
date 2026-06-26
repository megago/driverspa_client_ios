//
//  CompanyDiscount.m
//  WashMe
//
//  Created by Ivan Korotkikh on 27.12.16.
//  Copyright © 2016 Almas Adilbek. All rights reserved.
//

#import "CompanyDiscount.h"

@implementation CompanyDiscount

+ (CompanyDiscount *)instanceFromDictionary:(NSDictionary *)aDictionary {
    
    CompanyDiscount *instance = [[CompanyDiscount alloc] init];
    [instance setAttributesFromDictionary:aDictionary];
    return instance;
    
}

- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary {
    
    if (![aDictionary isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    objectData = aDictionary;
    
    self.discountId = [self stringValueForKey:@"uid"];
    self.discountValue = [self numberValueForKey:@"campaign_discount"];
    self.discountType = [self stringValueForKey:@"campaign_type"];
    self.discountDescription = [self stringValueForKey:@"description"];
    
    double timestampval1 =  [[self numberValueForKey:@"ts"] doubleValue];
    NSTimeInterval timestamp1 = (NSTimeInterval)timestampval1;
    self.startDate = [NSDate dateWithTimeIntervalSince1970:timestamp1];
    
    double timestampval2 =  [[self numberValueForKey:@"end_time"] doubleValue];
    NSTimeInterval timestamp2 = (NSTimeInterval)timestampval2;
    self.endDate = [NSDate dateWithTimeIntervalSince1970:timestamp2];
    
    objectData = nil;
}

@end
