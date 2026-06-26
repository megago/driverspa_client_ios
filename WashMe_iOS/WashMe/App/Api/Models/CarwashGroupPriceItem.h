//
//  CarwashGroupPriceItem.h
//  WashMe
//
//  Created by Ivan Korotkikh on 06.01.17.
//  Copyright © 2017 Almas Adilbek. All rights reserved.
//

#import "ModelObject.h"

@interface CarwashGroupPriceItem : ModelObject {
    NSNumber *price;
    NSNumber *time;
    NSNumber *carType;
}
@property (nonatomic, copy) NSNumber *price;
@property (nonatomic, copy) NSNumber *time;
@property (nonatomic, copy) NSNumber *carType;

+ (CarwashGroupPriceItem *)instanceFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;

@end
