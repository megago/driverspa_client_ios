//
// Created by Almas Adilbek on 10/11/14.
// Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APIClient.h"

@class BookObject;
@class City;

@interface UserApi : APIClient

+ (void)profile:(success)success failure:(failure)failure;
+ (void)userWithResourceUri:(NSString *)resourceUri success:(success)success failure:(failure)failure;

+ (void)updateProfileWithName:(NSString *)name lastname:(NSString *)lastname cars:(NSArray *)cars success:(success)success failure:(failure)failure;
+ (void)updateProfileWithName:(NSString *)name lastname:(NSString *)lastname cars:(NSArray *)cars city:(City *)city success:(success)success1 failure:(failure)failure1;

+ (void)setImageDefault:(NSString *)imageId success:(success)success failure:(failure)failure;

+ (void)bookmarkCarwash:(NSString *)carwashId success:(success)success failure:(failure)failure;
+ (void)removeCarwashBookmark:(NSString *)carwashId success:(success)success failure:(failure)failure;
+ (void)bookmarks:(success)success failure:(failure)failure;

// Booking
+ (void)bookWithBookObject:(BookObject *)bookObject success:(success)success failure:(failure)failure;
+ (void)bookingsWithStatus:(NSString *)status success:(success)success failure:(failure)failure;

+ (void)bookDetails:(NSString *)bookId success:(success)success failure:(failure)failure;
+ (void)cancelBooking:(NSString *)bookId success:(success)success failure:(failure)failure;

// Settings
+ (void)settings:(success)success failure:(failure)failure;
+ (void)settingsSetValue:(id)value forKey:(NSString *)key success:(success)success failure:(failure)failure;
+ (void)settingsAddDictionary:(NSDictionary *)dictionary success:(success)success failure:(failure)failure;
+ (void)settingsDeleteValueForKey:(NSString *)key success:(success)success failure:(failure)failure;

// Notifications
+ (void)notifications:(success)success failure:(failure)failure;

@end