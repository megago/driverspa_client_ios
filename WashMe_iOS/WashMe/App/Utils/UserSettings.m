//
//  UserSettings.m
//  WashMe
//
//  Created by Almas Adilbek on 12/18/14.
//  Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

#import "UserSettings.h"
#import "City.h"
#import "Cache.h"
#import "CarwashRefs.h"
#import "LocationHelper.h"
#import "UIAlertView+Blocks.h"
#import "NSObject+PropertyUtils.h"

#define kCityCodeKey @"currentCityCode"

@implementation UserSettings

+ (UserSettings *)sharedInstance {
    static UserSettings *_sharedInstance = nil;
    if(!_sharedInstance) {
        _sharedInstance = [[UserSettings alloc] init];
    }
    return _sharedInstance;
}

- (BOOL)issetSettings {
    return self.settings != nil;
}

+ (void)defineCurrentCity
{
    CLLocationCoordinate2D myLocation = [LocationHelper myLocationCoordinate];
    NSArray *cities = [self cities];
    City *nearestCity = nil;
    CGFloat minDistance = CGFLOAT_MAX;
    for(City *city in cities) {
        CGFloat distance = [LocationHelper metersBetweenPlace1:myLocation andPlace2:[city location]];
        if(distance < minDistance) {
            nearestCity = city;
            minDistance = distance;
        }
    }

    if(nearestCity) {
        City *currentCity = [self currentCity];
        if(currentCity) {
            if(![currentCity isCity:nearestCity])
            {
                [UIAlertView showWithTitle:@"Ближайший к Вам город:" message:nearestCity.title cancelButtonTitle:@"Отмена" otherButtonTitles:@[@"Выбрать город?"] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                    if(buttonIndex != alertView.cancelButtonIndex) {
                        [self setCurrentCity:nearestCity];

                        // Post notification city changed
                        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationCityChanged object:nearestCity];
                    }
                }];
            }
        } else {
            [self setCurrentCity:nearestCity];
        }
    }
}

+ (City *)currentCity {
    NSString *code = [[NSUserDefaults standardUserDefaults] valueForKey:kCityCodeKey];
    if(code) {
        NSArray *cities = [self cities];
        for(City *cityItem in cities) {
            if([cityItem.code isEqual:code]) {
//                NSLog(@"Current city: %@", [cityItem instancePropertyValues]);
                return cityItem;
            }
        }
    }
    return nil;
}

+ (void)setCurrentCity:(City *)city
{
//    NSLog(@"Set new city: %@", [city instancePropertyValues]);
    [[NSUserDefaults standardUserDefaults] setValue:city.code forKey:kCityCodeKey];
}

+ (BOOL)isAdmin {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"isAuthorizedAsAdmin"];
}

+ (void)setIsAdmin:(BOOL)isAdmin {
    [[NSUserDefaults standardUserDefaults] setBool:isAdmin forKey:@"isAuthorizedAsAdmin"];
}

+ (NSArray *)cities {
    CarwashRefs *refs = [Cache carwashRefs];
    if(refs) {
        return [refs cities];
    }
    return @[];
}

+ (void)setIsRegisteredPushToken:(BOOL)isRegistered
{
    [[NSUserDefaults standardUserDefaults] setBool:isRegistered forKey:@"isRegisteredPushToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)isRegisteredPushToken {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"isRegisteredPushToken"];
}

+ (void)setCurrentPushToken:(NSString *)pushToken {
    [[NSUserDefaults standardUserDefaults] setValue:pushToken forKey:kSettingsKeyPushToken];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)removePushToken {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kSettingsKeyPushToken];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)currentPushToken {
    return [[NSUserDefaults standardUserDefaults] valueForKey:kSettingsKeyPushToken];
}

+ (void)setCurrentUDID:(NSString *)udid {
    [[NSUserDefaults standardUserDefaults] setValue:udid forKey:kSettingsKeyUDID];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)removeUDID {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kSettingsKeyUDID];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)currentUDID {
    return [[NSUserDefaults standardUserDefaults] valueForKey:kSettingsKeyUDID];
}

@end
