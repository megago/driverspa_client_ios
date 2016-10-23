//
//  AppDelegate.m
//  WashMe
//
//  Created by Almas Adilbek on 9/6/14.
//  Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

#import <REFrostedViewController/REFrostedViewController.h>
#import "AppDelegate.h"
#import "WelcomeViewController.h"
#import "RegistrationViewController.h"
#import "CarwashesViewController.h"
#import "ProfileViewController.h"
#import "UserSettingsViewController.h"
#import "Cache.h"
#import "CarwashRefs.h"
#import "CarwashApi.h"
#import "User.h"
#import "AdminCarwashesViewController.h"
#import "AdminMainViewController.h"
#import "UserApi.h"
#import "UserSettings.h"
#import "FavoritesViewController.h"
#import "AdminSettingsViewController.h"
#import "RegisterProfileViewController.h"
#import "IQKeyboardManager.h"
#import "SVProgressHUD.h"
#import "SearchFilterViewController.h"
#import "MenuViewController.h"
#import "AdminMenuViewController.h"
#import "InputTextField.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import <GoogleMaps/GoogleMaps.h>
#import "UserBookViewController.h"
#import "AdminBookViewController.h"
#import "NSObject+Json.h"
#import "LocationHelper.h"

@implementation AppDelegate {
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    [self configAppearance];
    [self configIQKeyboard];
    [self configSVProgressHUD];

    // Google maps
    [GMSServices provideAPIKey:@"AIzaSyDdOQIac6I0iNYyaX7oQlL3R3clgu1nC_s"];

    // Request push notification permissions
    [self requestPushAndLocalNotificationPermissions];

    //Crashlytics
    [Fabric with:@[[Crashlytics class]]];
    
    // Check user
    id v = nil;
    if([User isAuthorized])
    {
        // Login
        if([User login])
        {
            if([User isRegistrationProfileEntered:[User currentUser].mobile])
            {
                if([UserSettings isAdmin]) {
                    [self setAdminAuthorizedTabbarController];
                } else {
                    [self setUserAuthorizedTabbarController];
                }

                // Load settings
                [UserApi settings:^(id response) {
                    [[UserSettings sharedInstance] setSettings:response];
                } failure:nil];
            }
            else
            {
                v = [RegisterProfileViewController new];
            }
        }
    }
    else
    {
        v = [WelcomeViewController new];
    }

    if(!_tabBarController) {
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:v];
        [nc setNavigationBarHidden:YES];
        self.window.rootViewController = nc;
    }

    // Load Refs
    [Cache loadCarwashRefs:^(id obj) {
        // Load company carwash refs
        [Cache loadCompanyRefs:nil];
    }];

    //Request location
    [[LocationHelper sharedInstance] requestLocation:^(CLLocation *currentLocation) {
        
    } failed:^(INTULocationStatus status) {
        
    }];
    
    //Remote Notification Info
    NSDictionary * remoteNotifiInfo = [launchOptions objectForKey: UIApplicationLaunchOptionsRemoteNotificationKey];
    
    //Accept push notification when app is not open
    if (remoteNotifiInfo) {
        [self application:application didReceiveRemoteNotification: remoteNotifiInfo];
    }
    
    NSNumber *badgeCount = [[NSUserDefaults standardUserDefaults] objectForKey:@"badgeCountApplication"];
    [UIApplication sharedApplication].applicationIconBadgeNumber = badgeCount.integerValue;
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)gotoWelcomeViewController
{
    UIViewController *v = [[WelcomeViewController alloc] init];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:v];
    [nc setNavigationBarHidden:YES];
    self.window.rootViewController = nc;
}

- (void)setUserAuthorizedTabbarController {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UserMain" bundle:nil];
    self.tabBarController = [storyboard instantiateViewControllerWithIdentifier:@"tabBarcontroller"];

    MenuViewController *menuController = [[MenuViewController alloc] init];

    self.frostedViewController = [[REFrostedViewController alloc] initWithContentViewController:self.tabBarController menuViewController:menuController];
    _frostedViewController.liveBlur = YES;
    _frostedViewController.liveBlurBackgroundStyle = REFrostedViewControllerLiveBackgroundStyleLight;
    _frostedViewController.direction = REFrostedViewControllerDirectionLeft;
    _frostedViewController.menuViewSize = CGSizeMake([MenuViewController menuWidth], self.window.frame.size.height);

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = _frostedViewController;

    [self.window makeKeyAndVisible];
}

- (void)setUserAuthorizedBookControllerWith:(NSString *)objectId {
    UserBookViewController *vc = [UserBookViewController new];
    vc.afterNotification = YES;
    vc.bookId = objectId;
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
    
    MenuViewController *menuController = [[MenuViewController alloc] init];
    
    self.frostedViewController = [[REFrostedViewController alloc] initWithContentViewController:nc menuViewController:menuController];
    _frostedViewController.liveBlur = YES;
    _frostedViewController.liveBlurBackgroundStyle = REFrostedViewControllerLiveBackgroundStyleLight;
    _frostedViewController.direction = REFrostedViewControllerDirectionLeft;
    _frostedViewController.menuViewSize = CGSizeMake([MenuViewController menuWidth], self.window.frame.size.height);
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = _frostedViewController;
    
    [self.window makeKeyAndVisible];
}

- (void)setAdminAuthorizedTabbarController {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"AdminMain" bundle:nil];
    self.tabBarController = [storyboard instantiateViewControllerWithIdentifier:@"tabBarcontroller"];
    
    AdminMenuViewController *menuController = [[AdminMenuViewController alloc] init];
    
    self.frostedViewController = [[REFrostedViewController alloc] initWithContentViewController:self.tabBarController menuViewController:menuController];
    _frostedViewController.liveBlur = YES;
    _frostedViewController.liveBlurBackgroundStyle = REFrostedViewControllerLiveBackgroundStyleLight;
    _frostedViewController.direction = REFrostedViewControllerDirectionLeft;
    _frostedViewController.menuViewSize = CGSizeMake([AdminMenuViewController menuWidth], self.window.frame.size.height);
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = _frostedViewController;
    
    [self.window makeKeyAndVisible];
}

- (void)setAdminAuthorizedSettingsController {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"AdminMain" bundle:nil];
    UINavigationController *nc = [storyboard instantiateViewControllerWithIdentifier:@"box_settings"];
    
    AdminMenuViewController *menuController = [[AdminMenuViewController alloc] init];
    
    self.frostedViewController = [[REFrostedViewController alloc] initWithContentViewController:nc menuViewController:menuController];
    _frostedViewController.liveBlur = YES;
    _frostedViewController.liveBlurBackgroundStyle = REFrostedViewControllerLiveBackgroundStyleLight;
    _frostedViewController.direction = REFrostedViewControllerDirectionLeft;
    _frostedViewController.menuViewSize = CGSizeMake([AdminMenuViewController menuWidth], self.window.frame.size.height);
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = _frostedViewController;
    
    [self.window makeKeyAndVisible];
}

- (void)setAdminAuthorizedReviewsController {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"AdminMain" bundle:nil];
    self.tabBarController = [storyboard instantiateViewControllerWithIdentifier:@"tabBarcontroller"];
    self.tabBarController.selectedIndex = 2;
    
    AdminMenuViewController *menuController = [[AdminMenuViewController alloc] init];
    
    self.frostedViewController = [[REFrostedViewController alloc] initWithContentViewController:self.tabBarController menuViewController:menuController];
    _frostedViewController.liveBlur = YES;
    _frostedViewController.liveBlurBackgroundStyle = REFrostedViewControllerLiveBackgroundStyleLight;
    _frostedViewController.direction = REFrostedViewControllerDirectionLeft;
    _frostedViewController.menuViewSize = CGSizeMake([AdminMenuViewController menuWidth], self.window.frame.size.height);
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = _frostedViewController;
    
    [self.window makeKeyAndVisible];
}

- (void)setAdminAuthorizedBookControllerWith:(NSString *)objectId {
    AdminBookViewController *vc = [AdminBookViewController new];
    vc.afterNotification = YES;
    vc.bookId = objectId;
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
    
    AdminMenuViewController *menuController = [[AdminMenuViewController alloc] init];
    
    self.frostedViewController = [[REFrostedViewController alloc] initWithContentViewController:nc menuViewController:menuController];
    _frostedViewController.liveBlur = YES;
    _frostedViewController.liveBlurBackgroundStyle = REFrostedViewControllerLiveBackgroundStyleLight;
    _frostedViewController.direction = REFrostedViewControllerDirectionLeft;
    _frostedViewController.menuViewSize = CGSizeMake([AdminMenuViewController menuWidth], self.window.frame.size.height);
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = _frostedViewController;
    
    [self.window makeKeyAndVisible];
}

#pragma mark -
#pragma mark Push Notifications

-(void)requestPushAndLocalNotificationPermissions {
    //if (![[UIApplication sharedApplication] isRegisteredForRemoteNotifications]){
    if (![UserSettings isRegisteredPushToken]){
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        
        if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]){
            [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
        }
    }
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];

    NSString* udid = [[[UIDevice currentDevice] identifierForVendor] UUIDString]; // IOS 6+
    
    // Save token to user defaults
    [UserSettings setCurrentPushToken:token];
    [UserSettings setCurrentUDID:udid];

    // Save token in settings if authorized
    if([User isAuthorized])
    {
        NSMutableDictionary *body = [NSMutableDictionary dictionary];
        body[kSettingsKeyDevice] = [NSString stringWithFormat:@"%@ %@", [[UIDevice currentDevice] systemName], [[UIDevice currentDevice] systemVersion]];
        body[kSettingsKeyOS] = @"iOS";
        body[kSettingsKeyPushType] = @"aps";
        body[kSettingsKeyPushToken] = token;
        
        NSString *path = [NSString stringWithFormat:@"devices/%@", udid];
        [APIClient PUT:path body:[body JSONRepresentation] success:^(id response) {
            [UserApi settingsSetValue:token forKey:kSettingsKeyAPNSToken success:^(id response) {
                // Set apns is allowed in settings
                NSMutableDictionary *params = [NSMutableDictionary dictionary];
                params[kSettingsKeyAllowAPNS] = @"1";
                params[kSettingsKeyPlatform] = @"iOS";
                params[kSettingsKeyAppVersion] = [AppUtils appVersion];
                [UserApi settingsAddDictionary:params success:^(id response) {
                    NSLog(@"settingsAddDictionary: %@", response);
                    [UserSettings setIsRegisteredPushToken:YES];
                } failure:nil];
            } failure:nil];
        } failure:nil];
    }
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
//    [GAN sendException:[NSString stringWithFormat:@"didFailToRegisterForRemoteNotificationsWithError: %@", error.localizedDescription]];
    if([User isAuthorized]) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[kSettingsKeyPlatform] = @"iOS";
        params[kSettingsKeyAppVersion] = [AppUtils appVersion];
        [UserApi settingsAddDictionary:params success:nil failure:nil];
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{    
    if ([User isAuthorized]){
        if ([UserSettings isAdmin]){
            NSString *type = [userInfo objectForKey:@"type"];
            if (type){
                if ([type isEqual:@"booking_created"] || [type isEqual:@"booking_auto_rejected"] || [type isEqual:@"booking_canceled"] || [type isEqual:@"booking_finish_inform"] || [type isEqual:@"booking_rejected"] || [type isEqual:@"booking_approved"] || [type isEqual:@"serving_finish"]){
                    NSString *objectId = [userInfo objectForKey:@"object_id"];
                    if (objectId) {
                        [self setAdminAuthorizedBookControllerWith:objectId];
                    }
                } else if ([type isEqual:@"review_created"]){
                    [self setAdminAuthorizedReviewsController];
                }
            }
        } else {
            NSString *objectId = [userInfo objectForKey:@"object_id"];
            if (objectId) {
                [self setUserAuthorizedBookControllerWith:objectId];
            }
        }
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Предупреждение" message:@"Чтобы просмотреть сообщение необходимо авторизоваться" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark -
#pragma mark Config

- (void)configSVProgressHUD {
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD setForegroundColor:[UIColor fromRGB:0x333333]];
    [SVProgressHUD setBackgroundColor:[UIColor fromRGB:0xF2F2F6]];
    [SVProgressHUD setFont:[UIFont boldSystemFontOfSize:14]];
}

- (void)configIQKeyboard {
    // Manager IQKeyboardManager
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
    [[IQKeyboardManager sharedManager] setToolbarManageBehaviour:IQAutoToolbarBySubviews];
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
    [[IQKeyboardManager sharedManager] setShouldShowTextFieldPlaceholder:NO];
    [[IQKeyboardManager sharedManager] considerToolbarPreviousNextInViewClass:[ScrollViewContentView class]];
}

- (void)configAppearance {
    [[UIToolbar appearance] setTintColor:[UIColor darkGrayColor]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];

    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor clearColor];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor], NSShadowAttributeName: shadow, NSFontAttributeName: [UIFont boldSystemFontOfSize:15]}];
}

#pragma mark -
#pragma mark System

- (void)applicationWillResignActive:(UIApplication *)application {}
- (void)applicationDidEnterBackground:(UIApplication *)application {}
- (void)applicationWillEnterForeground:(UIApplication *)application {}
- (void)applicationDidBecomeActive:(UIApplication *)application {}
- (void)applicationWillTerminate:(UIApplication *)application {}

@end
