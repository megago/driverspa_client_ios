//
//  CarwashGroupPriceItem.m
//  WashMe
//
//  Created by Ivan Korotkikh on 06.01.17.
//  Copyright © 2017 Almas Adilbek. All rights reserved.
//

#import "CarwashGroupPriceItem.h"

@implementation CarwashGroupPriceItem

@synthesize price, time, carType;

+ (CarwashGroupPriceItem *)instanceFromDictionary:(NSDictionary *)aDictionary {
    CarwashGroupPriceItem *instance = [[CarwashGroupPriceItem alloc] init];
    [instance setAttributesFromDictionary:aDictionary];
    return instance;
}

- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary {
    
    if (![aDictionary isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    objectData = aDictionary;
    
    self.price = aDictionary[@"price"];
    self.time = aDictionary[@"time"];
    self.carType = aDictionary[@"cartype"];
 
    objectData = nil;
}

@end
