//
//  CreateCarwashDraft.h
//  WashMe
//
//  Created by Almas Adilbek on 10/22/14.
//  Copyright (c) 2014 Almas Adilbek. All rights reserved.
//



#import <CoreLocation/CoreLocation.h>

@class IdTitleObject;
@class City;

@interface CreateCarwashDraft : NSObject

@property(nonatomic, copy) NSString *carwashName;

@property(nonatomic, strong) City *city;

@property(nonatomic, assign) CLLocationCoordinate2D coordinate;
@property(nonatomic, copy) NSString *address;

@property(nonatomic, strong) NSMutableArray *carTypes;
@property(nonatomic, strong) NSMutableArray *services;

@property(nonatomic, strong) NSMutableDictionary *menu;

// Boxes
@property(nonatomic, assign) NSInteger boxesCount;

// Additional data
@property(nonatomic, copy) NSString *telephone;
@property(nonatomic, copy) NSString *website;
@property(nonatomic, copy) NSString *email;
@property(nonatomic, strong) NSMutableArray *additionalInfos;

// Pay options
@property(nonatomic, strong) NSMutableArray *payOptions;

// Schedule
@property(nonatomic, strong) NSMutableArray *schedule;
@property(nonatomic, copy) NSString *scheduleComment;

+ (CreateCarwashDraft *)sharedInstance;
+ (void)clear;

// Address
- (BOOL)issetCoordinate;
- (BOOL)issetAddress;

// CarTypes
- (void)addCarType:(IdTitleObject *)obj;
- (void)removeCarTypeWithId:(IdTitleObject *)obj;
- (BOOL)issetCarTypes;
- (NSArray *)carTypeIds;

// Services
- (void)addService:(IdTitleObject *)obj;
- (void)removeServiceWithId:(id)objectId;
- (BOOL)issetServices;
- (NSArray *)serviceIds;

// Prices
- (void)setPrices:(NSArray *)prices forCarType:(IdTitleObject *)carType;
- (NSArray *)pricesForCarTypeId:(id)objectId;
- (NSDictionary *)menuDictionary;

// Additional infos
- (void)addAdditionalInfo:(IdTitleObject *)info;
- (void)removeAdditionalInfo:(IdTitleObject *)obj;
- (BOOL)hasAdditionalInfoWithId:(id)objectId;
- (NSArray *)additionalInfosArray;

// Contacts
- (NSArray *)contactValues;

// Payoptions
- (void)addPayoption:(IdTitleObject *)option;
- (void)removePayoption:(IdTitleObject *)obj;
- (BOOL)hasPayoptionWithId:(id)objectId;
- (NSArray *)payoptionkeys;

// Box settings
- (NSArray *)boxSettings;

// Schefule
- (NSDictionary *)scheduleDictionary;

@end
