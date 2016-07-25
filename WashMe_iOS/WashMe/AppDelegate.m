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


@implementation AppDelegate {
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    [self configAppearance];
    [self configIQKeyboard];
    [self configSVProgressHUD];

    // Google maps
    [GMSServices provideAPIKey:@"AIzaSyD9KOGWAAAtoJUHzqtfzPXvt-I5TBwcatM"];

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


#pragma mark -
#pragma mark Push Notifications

-(void)requestPushAndLocalNotificationPermissions {
    [[UIApplication sharedApplication] registerForRemoteNotifications];

    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]){
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    }
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];

    // Save token to user defaults
    [[NSUserDefaults standardUserDefaults] setValue:token forKey:@"pushNotificationToken"];

    // Save token in settings if authorized
    if([User isAuthorized])
    {
        [UserApi settingsSetValue:token forKey:kSettingsKeyAPNSToken success:^(id response) {
            // Set apns is allowed in settings
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            params[kSettingsKeyAllowAPNS] = @"1";
            params[kSettingsKeyPlatform] = @"iOS";
            params[kSettingsKeyAppVersion] = [AppUtils appVersion];
            [UserApi settingsAddDictionary:params success:^(id response) {
                NSLog(@"settingsAddDictionary: %@", response);
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
