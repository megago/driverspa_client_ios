//
//  Car.m
//  WashMe
//
//  Created by Almas Adilbek on 3/30/16.
//  Copyright (c) 2016 Almas Adilbek. All rights reserved.
//

#import "Car.h"

@implementation Car

@synthesize carModel, carNumber, carType;

+ (Car *)instanceFromDictionary:(NSDictionary *)aDictionary {

    Car *instance = [[Car alloc] init];
    [instance setAttributesFromDictionary:aDictionary];
    return instance;

}

- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary {

    if (![aDictionary isKindOfClass:[NSDictionary class]]) {
        return;
    }

    self.carNumber = [self stringValueFrom:aDictionary forKey:@"car_number"];
    self.carModel = [self stringValueFrom:aDictionary forKey:@"car_model"];
    self.carType = (CarType) [self intValueFrom:aDictionary forKey:@"car_type"];

}

- (NSString *)iconName {
    return [NSString stringWithFormat:@"btn_cartype%@_normal", @(self.carType)];
}

- (NSDictionary *)dictionaryObject {
    return @{
            @"car_number": self.carNumber ?: @"",
            @"car_model": self.carModel ?: @"",
            @"car_type": @(self.carType)
    };
}


@end
