//
//  BookObject.h
//  WashMe
//
//  Created by Almas Adilbek on 11/11/14.
//  Copyright (c) 2014 Almas Adilbek. All rights reserved.
//



#import "CarTypesTabbarView.h"

@class CarwashComplex;
@class BoxSetting;

@interface BookObject : NSObject

@property(nonatomic, strong) NSArray *services;
@property(nonatomic, strong) NSArray *servicesGroups;
@property(nonatomic, strong) CarwashComplex *carwash;
@property(nonatomic, copy) NSString *time;
@property(nonatomic, copy) NSString *clientKey;
@property(nonatomic, assign) CarType carType;
@property(nonatomic, copy) NSNumber *price;
@property(nonatomic, strong) NSDate *bookDate;
@property(nonatomic, copy) NSString *bookTime;
@property(nonatomic, copy) NSString *bookId;
@property(nonatomic, assign) BOOL isOffline;
@property(nonatomic, strong) BoxSetting *boxSetting;

- (NSString *)localizedPrice;
- (NSString *)servicesTitles;
- (NSString *)prettyTime;
- (NSString *)localizedDaysAgo;

@end
