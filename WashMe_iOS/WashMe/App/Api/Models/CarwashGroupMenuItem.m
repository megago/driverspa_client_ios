//
//  CarwashGroupMenuItem.m
//  WashMe
//
//  Created by Ivan Korotkikh on 02.01.17.
//  Copyright © 2017 Almas Adilbek. All rights reserved.
//

#import "CarwashGroupMenuItem.h"
#import "CarwashGroupPriceItem.h"

@implementation CarwashGroupMenuItem

@synthesize uid, name, services, prices;

+ (CarwashGroupMenuItem *)instanceFromDictionary:(NSDictionary *)aDictionary {
    
    CarwashGroupMenuItem *instance = [[CarwashGroupMenuItem alloc] init];
    [instance setAttributesFromDictionary:aDictionary];
    return instance;
}

- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary {
    
    if (![aDictionary isKindOfClass:[NSDictionary class]]) {
        return;
    }
    objectData = aDictionary;
    
    self.uid = [self stringValueForKey:@"uid"];
    self.name = [self stringValueForKey:@"name"];
    self.services = [self arrayValueForKey:@"services"];

    // Prices
    NSArray *receivedPrices = aDictionary[@"prices"];
    NSMutableArray *itemPrices = [NSMutableArray array];
    
    for(NSDictionary *o in receivedPrices) {
        CarwashGroupPriceItem *menuItem = [CarwashGroupPriceItem instanceFromDictionary:o];
        [itemPrices addObject:menuItem];
    }
    self.prices = itemPrices;
    
    objectData = nil;
}

@end
