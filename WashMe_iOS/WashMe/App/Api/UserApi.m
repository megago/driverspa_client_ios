//
// Created by Almas Adilbek on 10/11/14.
// Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

#import "UserApi.h"
#import "NSObject+Json.h"
#import "NSString+Ext.h"
#import "User.h"
#import "CarwashApi.h"
#import "ApiUtils.h"
#import "CarwashBook.h"
#import "BookObject.h"
#import "Carwash.h"
#import "CarwashComplex.h"
#import "IdTitleObject.h"
#import "EventNotification.h"
#import "UserObject.h"
#import "Car.h"
#import "NSArray+ObjectiveSugar.h"
#import "City.h"


@implementation UserApi {

}

+ (void)profile:(success)success failure:(failure)failure {
    [self userWithResourceUri:[User currentUser].resourceUri success:success failure:failure];
}

+ (void)userWithResourceUri:(NSString *)resourceUri success:(success)success failure:(failure)failure
{
    [self GET:resourceUri success:^(id response) {
        success([UserObject instanceFromDictionary:response]);
    } failure:failure];
}

+ (void)updateProfileWithName:(NSString *)name lastname:(NSString *)lastname cars:(NSArray *)cars success:(success)success failure:(failure)failure {
    [self updateProfileWithName:name lastname:lastname cars:cars city:nil success:success failure:failure];
}

+ (void)updateProfileWithName:(NSString *)name lastname:(NSString *)lastname cars:(NSArray *)cars city:(City *)city success:(success)success failure:(failure)failure
{
    if(!name) name = @"";
    if(!lastname) lastname = @"";
    if(!cars) cars = @[];

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"first_name"] = name;
    params[@"last_name"] = lastname;
    if(city) params[@"city"] = city.code;

    if(cars && cars.count > 0) {
        // Save cars.
        NSArray *carsArray = [cars map:^id(Car *object) {
            return object.dictionaryObject;
        }];
        params[@"cars"] = carsArray;
    }

    [self PATCH:[NSString stringWithFormat:@"account/%@", [User currentUser].userId] body:[params JSONRepresentation] success:success failure:failure];
}

+ (void)setImageDefault:(NSString *)imageId success:(success)success failure:(failure)failure {
    [self POST:[NSString stringWithFormat:@"image_upload/default/%@", imageId] success:success failure:failure];
}

#pragma mark -
#pragma mark Bookmarks

+(void)bookmarkCarwash:(NSString *)carwashId success:(success)success failure:(failure)failure {
    [self POST:@"client_bookmarks" body:[@{@"id":carwashId} JSONRepresentation] success:success failure:failure];
}

+(void)removeCarwashBookmark:(NSString *)carwashId success:(success)success failure:(failure)failure {
    [self DELETE:[NSString stringWithFormat:@"client_bookmarks/%@", carwashId] success:success failure:failure];
}

+ (void)bookmarks:(success)success failure:(failure)failure {
    [self GET:@"client_bookmarks" success:^(id response) {
        success([ApiUtils responseToCarwashes:response[@"objects"]]);
    } failure:failure];
}

#pragma mark -
#pragma mark Bookings

+(void)bookWithBookObject:(BookObject *)bookObject success:(success)success failure:(failure)failure
{
    NSMutableArray *services = [NSMutableArray array];
    for(IdTitleObject *obj in bookObject.services) {
        [services addObject:obj.objectId];
    }

    NSMutableDictionary * o = [NSMutableDictionary dictionary];
    o[@"carwash"] = bookObject.carwash.resourceUri;
    o[@"time"] = bookObject.time;
    o[@"services"] = services;
    o[@"client_key"] = bookObject.clientKey;
    o[@"cartype"] = @(bookObject.carType);
    o[@"requestType"] = @"NEW";

    NSLog(@"%@", o);
//    return;

    [self POST:@"client_booking" body:[o JSONRepresentation] success:^(id response) {
        success([CarwashBook instanceFromDictionary:response]);
    } failure:failure];
}

+ (void)bookingsWithStatus:(NSString *)status success:(success)success failure:(failure)failure
{
    [self GET:[NSString stringWithFormat:@"client_booking%@", status ? [NSString stringWithFormat:@"?status=%@", status] : @""] success:^(id response) {
        success([ApiUtils responseToCarwashBooks:response[@"objects"]]);
    } failure:failure];
}

+(void)bookDetails:(NSString *)bookId success:(success)success failure:(failure)failure {
    [self GET:[NSString stringWithFormat:@"client_booking/%@", bookId] success:^(id response) {
        success([CarwashBook instanceFromDictionary:response]);
    } failure:failure];
}

+ (void)cancelBooking:(NSString *)bookId success:(success)success failure:(failure)failure {
    [self POST:@"client_booking/cancel" body:[@{@"id":bookId} JSONRepresentation] success:success failure:failure];
}

#pragma mark -
#pragma mark Settings

+ (void)settings:(success)success failure:(failure)failure {
    [self GET:@"settings/you" success:^(id response) {
        success(response[@"settings"]);
    } failure:failure];
}

+ (void)settingsSetValue:(id)value forKey:(NSString *)key success:(success)success failure:(failure)failure
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[key] = value;
    [self PATCH:@"settings/you" body:[param JSONRepresentation] success:^(id response) {
        if(success) success(response[@"settings"]);
    } failure:failure];
}

+ (void)settingsAddDictionary:(NSDictionary *)dictionary success:(success)success failure:(failure)failure
{
    if(dictionary) {
        [self PATCH:@"settings/you" body:[dictionary JSONRepresentation] success:^(id response) {
            if(success) success(response[@"settings"]);
        } failure:failure];
    }
}

+ (void)settingsDeleteValueForKey:(NSString *)key success:(success)success failure:(failure)failure {
    [self settingsSetValue:@":del" forKey:key success:success failure:failure];
}

#pragma mark -
#pragma mark Notifications

+ (void)notifications:(success)success failure:(failure)failure
{
    [self GET:@"client_notifications" success:^(id response) {

        NSArray *objects = response[@"objects"];

        NSMutableArray * array = [NSMutableArray array];
        for(NSDictionary *item in objects) {
            [array addObject:[EventNotification instanceFromDictionary:item]];
        }
        success(array);

    } failure:failure];
}

@end