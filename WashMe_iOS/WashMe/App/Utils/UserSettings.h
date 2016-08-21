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

+ (BOOL)isAdmin;
+ (void)setIsAdmin:(BOOL)isAdmin;

@end
