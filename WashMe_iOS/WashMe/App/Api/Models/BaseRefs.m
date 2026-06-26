//
//  BaseRefs.m
//  WashMe
//
//  Created by Almas Adilbek on 11/8/14.
//  Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

#import "BaseRefs.h"
#import "IdTitleObject.h"
#import "ApiUtils.h"

@implementation BaseRefs

+ (BaseRefs *)instanceFromDictionary:(NSDictionary *)aDictionary {

    BaseRefs *instance = [[BaseRefs alloc] init];
    [instance setAttributesFromDictionary:aDictionary];
    return instance;

}

- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary {

    if (![aDictionary isKindOfClass:[NSDictionary class]]) {
        return;
    }

    self.services = [ApiUtils responseArrayToIdTitleObjectsArray:aDictionary[@"services"]];
    self.carType = [ApiUtils responseArrayToIdTitleObjectsArray:aDictionary[@"car_type"]];
    self.additionalInfos = [ApiUtils responseArrayToIdTitleObjectsArray:aDictionary[@"additional_info"]];
}

- (NSString *)servicesRaw {
    NSMutableArray *array = [NSMutableArray array];
    for(IdTitleObject *obj in self.services) {
        [array addObject:obj.title];
    }
    return [array componentsJoinedByString:@", "];
}

- (NSDictionary *)servicesDictionary {
    return [self dictionaryOfArray:self.services];
}

- (NSDictionary *)carTypesDictionary {
    return [self dictionaryOfArray:self.carType];
}

- (NSString *)serviceTitle:(id)serviceId {
    NSDictionary *o = [self servicesDictionary];
    IdTitleObject *service = o[serviceId];
    return service.title;
}

- (NSString *)carTypeTitle:(id)carTypeId {
    NSDictionary *o = [self carTypesDictionary];
    IdTitleObject *cartype = o[carTypeId];
    return cartype.title;
}


#pragma mark -
#pragma mark Helper

-(NSDictionary *)dictionaryOfArray:(NSArray *)array {
    NSMutableDictionary *o = [NSMutableDictionary dictionary];
    for(IdTitleObject *obj in array) {
        o[obj.objectId] = obj;
    }
    return o;
}


@end
