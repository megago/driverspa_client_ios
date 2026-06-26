//
//  BaseRefs.h
//  WashMe
//
//  Created by Almas Adilbek on 11/8/14.
//  Copyright (c) 2014 Almas Adilbek. All rights reserved.
//



#import "ModelObject.h"

@interface BaseRefs : ModelObject {
    NSArray *services;
    NSArray *carType;
    NSArray *additionalInfos;
}

@property (nonatomic, copy) NSArray *services;
@property (nonatomic, copy) NSArray *carType;
@property (nonatomic, copy) NSArray *additionalInfos;

+ (BaseRefs *)instanceFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;

- (NSString *)servicesRaw;

- (NSDictionary *)servicesDictionary;
- (NSDictionary *)carTypesDictionary;

- (NSString *)serviceTitle:(id)serviceId;
- (NSString *)carTypeTitle:(id)carTypeId;

@end
