//
//  CarwashApi.m
//  WashMe
//
//  Created by Almas Adilbek on 9/16/14.
//  Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

#import <ObjectiveSugar/NSArray+ObjectiveSugar.h>
#import "CarwashApi.h"
#import "Carwash.h"
#import "CarwashComplex.h"
#import "CarwashRefs.h"
#import "Cache.h"
#import "BoxTimeTable.h"
#import "NSObject+Json.h"
#import "LocationHelper.h"
#import "ApiUtils.h"
#import "City.h"
#import "ImageBundle.h"
#import "BoxSetting.h"
#import "UserSettings.h"
#import "FilterManager.h"
#import "User.h"

@implementation CarwashApi

+ (void)getCarwashes:(success)success failure:(failure)failure {
    City *city = [UserSettings currentCity];
    CLLocationDegrees lon = city.longitude;
    CLLocationDegrees lat = city.latitude;

    [self GET:[NSString stringWithFormat:@"public_carwash?lonlat__near=%f,%f&lonlat__max_distance=%@&working=true&limit=10000", lon, lat, @(50000)] success:^(id response) {
        NSArray *objects = [response objectForKey:@"objects"];
        success([ApiUtils responseToCarwashes:objects]);
    } failure:failure];
}

+(void)getComplexCarwashes:(success)success failure:(failure)failure
{
    City *city = [UserSettings currentCity];
    CLLocationDegrees lon = city.longitude;
    CLLocationDegrees lat = city.latitude;
    if (lon == 0 && lat == 0){
        lon = [[LocationHelper sharedInstance] longitude];
        lat = [[LocationHelper sharedInstance] latitude];
    }
    
    //map_carwash?lonlat__near=%f,%f&lonlat__max_distance=%@&working=true&limit=10000

    [self GET:[NSString stringWithFormat:@"map_carwash?lonlat__near=%f,%f&lonlat__max_distance=%@&limit=10000&city=%@&mobile=%@", lon, lat, @(50000), city.code, [User currentUser].mobile] success:^(id response) {
        NSArray *objects = [response objectForKey:@"objects"];
        NSArray *carwashes = [objects map:^id(id object) {
            return [CarwashComplex instanceFromDictionary:object];
        }];
        success(carwashes);
    } failure:failure];
}

+ (void)getCarwashes:(NSInteger)page filterManager:(FilterManager *)manager success:(success)success failure:(failure)failure {
    [self getCarwashes:page
                  free: manager ? manager.free : nil
               working: manager ? manager.working : nil
              maxPrice: manager ? manager.maxPrice : nil
              comforts: manager ? manager.comfortsString : nil
              payments: manager ? manager.payments : nil
                rating: manager ? manager.rating : nil
           maxDistance: manager ? manager.maxDistance : nil
                  city: manager ? manager.city : nil
                mobile: manager ? manager.mobile : nil
               success:success failure:failure];
}

+ (void)getCarwashes:(NSInteger)page
                free:(NSString *)free
             working:(NSString *)working
            maxPrice:(NSNumber *)maxPrice
            comforts:(NSString *)comforts
            payments:(NSString *)payments
              rating:(NSNumber *)rating
         maxDistance:(NSNumber *)maxDistance
                city:(NSString *)city
              mobile:(NSString *)mobile
             success:(success)success failure:(failure)failure {


    NSInteger itemsInPage = 20;
    if(page < 1) {
        page = 1;
    }

//    CLLocationDegrees lon = [UserSettings currentCity].latitude;
//    CLLocationDegrees lat = [UserSettings currentCity].longitude;

    CLLocationDegrees lon = [[LocationHelper sharedInstance] longitude];
    CLLocationDegrees lat = [[LocationHelper sharedInstance] latitude];
    if(lon == 0 || lat == 0) {
        lat = [User currentUser].city.latitude;//51.155372;
        lon = [User currentUser].city.longitude;//71.432625;
    }
    
    if (city == nil){
        city = [User currentUser].cityCode;
    }
    
    if (mobile == nil){
        mobile = [User currentUser].mobile;
    }
    
    if (maxDistance == nil){
        maxDistance = [NSNumber numberWithInt:50000];
    }
    
    if (rating == nil){
        rating = [NSNumber numberWithInt:0];
    }
    
    if (maxPrice == nil){
        maxPrice = [NSNumber numberWithInt:5000];
    }

    //public_carwash?lonlat__near=71.432625%2C51.155372&limit=100000&lonlat__max_distance=50000&rating__gte=0&max_price=3500&offset=0&mobile=%2B77076744674&city=astana

    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"lonlat__near"] = [NSString stringWithFormat:@"%f,%f", lon, lat];
    //if(free)        params[@"free"] = @([free boolValue]);
    //if(working)     params[@"working"] = @([working boolValue]);
    //if(comforts)    params[@"comforts"] = comforts;
    //if(payments)    params[@"payments"] = payments;
    if(maxDistance) params[@"lonlat__max_distance"] = maxDistance;
    if(rating)      params[@"rating__gte"] = rating;
    if(maxPrice)    params[@"max_price"] = maxPrice;
    if(city)        params[@"city"] = city;
    if(mobile)      params[@"mobile"] = mobile;
    params[@"limit"] = @(itemsInPage);
    params[@"offset"] = @(itemsInPage * (page - 1));

    [self getPublicCarwashes:params success:success failure:failure];
}

+ (void)getPublicCarwashes:(NSDictionary *)params success:(success)success failure:(failure)failure {
    NSLog(@"params:%@", params);
    [self GET:@"public_carwash" parameters:params success:^(id response) {
        NSArray *objects = [response objectForKey:@"objects"];
        success([ApiUtils responseToCarwashes:objects]);
    } failure:failure];
}

+ (void)getCarwashDetails:(NSString *)carwashID success:(success)success failure:(failure)failure {
    [self GET:[NSString stringWithFormat:@"public_carwash/%@", carwashID] success:^(id response) {
        success([CarwashComplex instanceFromDictionary:response]);
    } failure:failure];
}

+ (void)getCarwashWithResource:(NSString *)resourceUri success:(success)success failure:(failure)failure {
    [self GET:resourceUri success:^(id response) {
        success([CarwashComplex instanceFromDictionary:response]);
    } failure:failure];
}

+ (void)searchCarwashes:(NSString *)keyword success:(success)success failure:(failure)failure
{
    NSString *url = [[NSString stringWithFormat:@"public_carwash?name__icontains=%@", keyword] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self GET:url success:^(id response) {
        NSArray *objects = response[@"objects"];
        if(objects) {
            success([ApiUtils responseToCarwashes:objects]);
        } else {
            success(@[]);
        }
    } failure:failure];
}

+ (void)addFeedback:(NSString *)text mark:(NSInteger)mark carwashId:(NSString *)carwashId success:(success)success failure:(failure)failure
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"carwash"] = carwashId;
    params[@"mark"] = @(mark);
    params[@"text"] = text;
    [self POST:@"client_reviews" body:[params JSONRepresentation] success:success failure:failure];
}

+(void)ref:(success)success failure:(failure)failure {
    [self GET:@"public_carwash/ref?format=json" success:^(id response) {
        [Cache cacheCarwashRefs:response];
        success([CarwashRefs instanceFromDictionary:response]);
    } failure:failure];
}

+(void)timeTableWithCarwashId:(NSString *)carwashId day:(CarwashBoxesTimeDay)day success:(success)success failure:(failure)failure
{
    NSString *dayString = day == CarwashBoxesTimeDayToday ? @"today" : @"tomorrow";
    [self GET:[NSString stringWithFormat:@"public_carwash/timetable?carwash=%@&day=%@", carwashId, dayString] success:^(id response) {
        NSDictionary *result = response[@"result"];
        NSMutableArray * boxTimeTables = [NSMutableArray array];

        if(result) {
            NSDictionary *boxes = result[@"boxes"];
            if(boxes) {
                for(NSString *cid in boxes) {
                    NSDictionary *box = boxes[cid];
                    [boxTimeTables addObject:[BoxTimeTable instanceFromDictionary:box]];
                }
            }
        }

        if(success) success(boxTimeTables);

    } failure:failure];
}

#pragma mark -
#pragma mark Admin

+ (void)uploadCarwashImage:(UIImage *)image carwashId:(NSString *)carwashId success:(success)success failure:(failure)failure
{
    NSData *imageData = UIImageJPEGRepresentation(image, 0.3);

    [self POST:@"image_upload/new" uploadImage:imageData dataName:@"image" parameters:@{@"carwash":carwashId} success:^(id response) {
        success([ImageBundle instanceFromDictionary:response]);
    } failure:failure];
}

+(void)makeCarwash:(NSString *)carwashId public:(BOOL)isPublic success:(success)success failure:(failure)failure
{
    [self PATCH:[NSString stringWithFormat:@"company_carwash/%@", carwashId] body:[@{@"is_public":isPublic?@(YES):@(NO)} JSONRepresentation] success:^(id response) {
        success([CarwashComplex instanceFromDictionary:response]);
    } failure:failure];
}

+ (void)createBoxForCarwash:(NSString *)carwashId bookingType:(NSString *)bookingType success:(success)success failure:(failure)failure
{
    [self POST:[NSString stringWithFormat:@"company_carwash/%@/box", carwashId] body:[@{@"booking_type":bookingType} JSONRepresentation] success:^(id response) {
        success([BoxSetting instanceFromDictionary:response]);
    } failure:failure];
}

+ (void)editBoxOfCarwash:(NSString *)carwashId boxId:(NSString *)boxId bookingType:(NSString *)bookingType success:(success)success failure:(failure)failure
{
    [self PATCH:[NSString stringWithFormat:@"company_carwash/%@/box/%@", carwashId, boxId] body:[@{@"booking_type":bookingType} JSONRepresentation] success:^(id response) {
        success(nil);
    } failure:failure];
}

+ (void)deleteBoxOfCarwash:(NSString *)carwashId boxId:(NSString *)boxId success:(success)success failure:(failure)failure
{
    [self DELETE:[NSString stringWithFormat:@"company_carwash/%@/box/%@", carwashId, boxId] success:^(id response) {
        success(nil);
    } failure:failure];
}


@end
