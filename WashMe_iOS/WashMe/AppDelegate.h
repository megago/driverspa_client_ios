//
//  AppDelegate.h
//  WashMe
//
//  Created by Almas Adilbek on 9/6/14.
//  Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

#import <UIKit/UIKit.h>

@class REFrostedViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property(nonatomic, strong) UITabBarController *tabBarController;
@property(nonatomic, strong) REFrostedViewController *frostedViewController;

- (void)gotoWelcomeViewController;
- (void)setUserAuthorizedTabbarController;

// Push notification
- (void)requestPushAndLocalNotificationPermissions;

@end
