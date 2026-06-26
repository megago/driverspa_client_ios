//
//  CreateCarwashDraft.m
//  WashMe
//
//  Created by Almas Adilbek on 10/22/14.
//  Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "CreateCarwashDraft.h"
#import "IdTitleObject.h"
#import "CarwashMenuItem.h"
#import "NSString+Ext.h"
#import "TimeIntervalPickerView.h"
#import "City.h"

static CreateCarwashDraft *_sharedInstance = nil;

@implementation CreateCarwashDraft

+ (CreateCarwashDraft *)sharedInstance
{
    if(!_sharedInstance) {
        _sharedInstance = [[CreateCarwashDraft alloc] init];

        _sharedInstance.carwashName = @"";

        _sharedInstance.coordinate = kCLLocationCoordinate2DInvalid;
        _sharedInstance.address = @"";

        _sharedInstance.carTypes = [[NSMutableArray alloc] init];
        _sharedInstance.services = [[NSMutableArray alloc] init];
        _sharedInstance.additionalInfos = [[NSMutableArray alloc] init];
        _sharedInstance.payOptions = [[NSMutableArray alloc] init];

        _sharedInstance.schedule = [[NSMutableArray alloc] init];
        for(NSInteger i=0; i<7; ++i) {
            [_sharedInstance.schedule addObject:@"09:00 - 22:00"];
        }

        _sharedInstance.telephone = @"";
        _sharedInstance.website = @"";
        _sharedInstance.email = @"";
        _sharedInstance.scheduleComment = @"";

        _sharedInstance.menu = [[NSMutableDictionary alloc] init];

        _sharedInstance.boxesCount = 3;
    }
    return _sharedInstance;
}

+ (void)clear
{
    _sharedInstance = nil;
}


#pragma mark -
#pragma mark Address

- (BOOL)issetAddress {
    return [self issetCoordinate] && [self.address trim].length > 0;
}

- (BOOL)issetCoordinate {
    return CLLocationCoordinate2DIsValid([[CreateCarwashDraft sharedInstance] coordinate]);
}

#pragma mark -
#pragma mark CarTypes

- (void)addCarType:(IdTitleObject *)obj {
    [_carTypes addObject:obj];
}

- (void)removeCarTypeWithId:(IdTitleObject *)obj {
    [self removeIdTitleObjectFrom:_carTypes withObjectId:obj.objectId];
}

#pragma mark -
#pragma mark Services

- (BOOL)issetCarTypes {
    return _carTypes.count > 0;
}

- (NSArray *)carTypeIds {
    NSMutableArray *array = [NSMutableArray array];
    for(IdTitleObject *obj in self.carTypes) {
        [array addObject:obj.objectId];
    }
    return array;
}


- (void)addService:(IdTitleObject *)obj {
    [_services addObject:obj];
}

- (void)removeServiceWithId:(id)objectId {
    [self removeIdTitleObjectFrom:_services withObjectId:objectId];
}

- (BOOL)issetServices {
    return _services.count > 0;
}

- (NSArray *)serviceIds {
    NSMutableArray *array = [NSMutableArray array];
    for(IdTitleObject *obj in self.services) {
        [array addObject:obj.objectId];
    }
    return array;
}


#pragma mark -
#pragma mark Prices

- (void)setPrices:(NSArray *)prices forCarType:(IdTitleObject *)carType {
    (self.menu)[[NSString stringWithFormat:@"%@", carType.objectId]] = prices;
}

- (NSArray *)pricesForCarTypeId:(id)objectId {
    NSArray *array = self.menu[[NSString stringWithFormat:@"%@", objectId]];
    return array?array:@[];
}

- (NSDictionary *)menuDictionary {
    NSMutableDictionary *o = [NSMutableDictionary dictionary];
    for(NSString *key in self.menu) {
        NSMutableArray *array = [NSMutableArray array];
        for(CarwashMenuItem *item in self.menu[key]) {
            [array addObject:[item dictionaryValue]];
        }
        o[[NSString stringWithFormat:@"%@", key]] = array;
    }
    return o;
}

#pragma mark -
#pragma mark Additional info

- (void)addAdditionalInfo:(IdTitleObject *)info {
    [self.additionalInfos addObject:info];
}

- (void)removeAdditionalInfo:(IdTitleObject *)obj {
    [self removeIdTitleObjectFrom:_additionalInfos withObjectId:obj.objectId];
}

- (BOOL)hasAdditionalInfoWithId:(id)objectId {
    return [self hasObjectInArray:_additionalInfos withObjectId:objectId];
}


#pragma mark -
#pragma mark Contacts

- (NSArray *)contactValues {
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:@{@"type":@"phone", @"value":self.telephone, @"alias":self.telephone}];
    [array addObject:@{@"type":@"website", @"value":self.website, @"alias":self.website}];
    [array addObject:@{@"type":@"email", @"value":self.email, @"alias":self.email}];
    return array;
}

#pragma mark -
#pragma mark Payoptions

- (NSArray *)additionalInfosArray
{
    NSMutableArray * array = [NSMutableArray array];
    for(IdTitleObject *info in self.additionalInfos) {
//        o[info.objectId] = @YES;
        [array addObject:info.objectId];
    }
    return array;
}

- (void)addPayoption:(IdTitleObject *)option {
    [self.payOptions addObject:option];
}

- (void)removePayoption:(IdTitleObject *)obj {
    [self removeIdTitleObjectFrom:_additionalInfos withObjectId:obj.objectId];
}

- (BOOL)hasPayoptionWithId:(id)objectId {
    return [self hasObjectInArray:_payOptions withObjectId:objectId];
}

- (NSArray *)payoptionkeys {
    NSMutableArray *array = [NSMutableArray array];
    for(IdTitleObject *option in self.payOptions) {
        [array addObject:option.objectId];
    }
    return array;
}

#pragma mark -
#pragma mark BoxSettings

- (NSArray *)boxSettings {
    NSMutableArray *array = [NSMutableArray array];
    for(NSInteger i=0; i<self.boxesCount; ++i) {
        [array addObject:@{@"booking_type":@"hybrid"}];
    }
    return array;
}

- (NSDictionary *)scheduleDictionary {
    NSMutableDictionary *o = [NSMutableDictionary dictionary];
    o[@"comment"] = self.scheduleComment;

    NSUInteger index = 0;
    NSArray *days = @[@"mon", @"tue", @"wed", @"thu", @"fri", @"sat", @"sun"];
    for(NSString *time in self.schedule)
    {
        NSArray *times = [time componentsSeparatedByString:[TimeIntervalPickerView timesSeparator]];
        if(times.count == 2) {
            NSString *from = times[0];
            NSString *to = times[1];

            NSArray *fromArray = [from componentsSeparatedByString:@":"];
            NSArray *toArray = [to componentsSeparatedByString:@":"];

            NSInteger fromMinutes = [fromArray[0] integerValue] * 60 + [fromArray[1] integerValue];
            NSInteger toMinutes = [toArray[0] integerValue] * 60 + [toArray[1] integerValue];

            o[days[index]] = @[@{@"fr":@(fromMinutes), @"to":@(toMinutes)}];
        }

        ++index;
    }

    return o;
}


#pragma mark -
#pragma mark Helper

- (void)removeIdTitleObjectFrom:(NSMutableArray *)array withObjectId:(NSNumber *)objectId
{
    NSUInteger index = 0;
    for(IdTitleObject *obj in array) {
        if([obj.objectId isEqual:objectId]) {
            [array removeObjectAtIndex:index];
            break;
        }
        ++index;
    }
}

- (BOOL)hasObjectInArray:(NSArray *)array withObjectId:(id)objectId {
    for(IdTitleObject *obj in array) {
        if([obj.objectId isEqual:objectId]) {
            return YES;
        }
    }
    return NO;
}


@end
