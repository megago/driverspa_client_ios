//
//  Car.h
//  WashMe
//
//  Created by Almas Adilbek on 3/30/16.
//  Copyright (c) 2016 Almas Adilbek. All rights reserved.
//



#import "CarTypesTabbarView.h"
#import "ModelObject.h"

@interface Car : ModelObject

@property(nonatomic, assign) CarType carType;
@property(nonatomic, copy) NSString *carNumber;
@property(nonatomic, copy) NSString *carModel;

+ (Car *)instanceFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;

- (NSString *)iconName;
- (NSDictionary *)dictionaryObject;

@end
