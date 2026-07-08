//
//  UserSettings.h
//  WashMe
//
//  Created by Almas Adilbek on 12/18/14.
//  Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

#define kSettingsKeyAllowAPNS @"allowAPNS"
#define kSettingsKeyAPNSToken @"apnsToken"
#define kSettingsKeyAppVersion @"appVersion"
#define kSettingsKeyPlatform @"platform"

#define kSettingsKeyDevice @"device"
#define kSettingsKeyOS @"os"
#define kSettingsKeyPushType @"push_type"
#define kSettingsKeyPushToken @"token_id"
#define kSettingsKeyUDID @"udid"

#import <CoreLocation/CoreLocation.h>

static BOOL _isAdmin = NO;

static NSString *kNotificationCityChanged = @"notificationCityChanged";

@class City;

@interface UserSettings : NSObject

@property(nonatomic, strong) NSDictionary *settings;

+ (UserSettings *)sharedInstance;
- (BOOL)issetSettings;

// City
+ (void)defineCurrentCity;
+ (City *)currentCity;
+ (void)setCurrentCity:(City *)city;

// Whether the current city was determined automatically by GPS (YES) or picked
// manually from the list (NO). Mirrors the Android "cityFoundByGPS" flag and
// controls where the checkmark is shown on the city selection screen.
+ (void)setCityFoundByGPS:(BOOL)found;
+ (BOOL)isCityFoundByGPS;

// Nearest city to the given coordinate (nil if no cities). If distanceMeters is
// non-NULL it receives the distance in meters to that city.
+ (City *)nearestCityToCoordinate:(CLLocationCoordinate2D)coordinate distanceMeters:(CGFloat *)distanceMeters;

+ (BOOL)isAdmin;
+ (void)setIsAdmin:(BOOL)isAdmin;

+ (void)setIsRegisteredPushToken:(BOOL)isRegistered;
+ (BOOL)isRegisteredPushToken;

+ (void)setCurrentPushToken:(NSString *)pushToken;
+ (void)removePushToken;
+ (NSString *)currentPushToken;

+ (void)setCurrentUDID:(NSString *)udid;
+ (void)removeUDID;
+ (NSString *)currentUDID;

@end
