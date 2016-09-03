//
//  NearbyCarwashesViewController.m
//  WashMe
//
//  Created by Almas Adilbek on 10/11/15.
//  Copyright (c) 2015 Almas Adilbek. All rights reserved.
//

#import <ConcisePureLayout/UIView+ConcisePureLayout.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "NearbyCarwashesViewController.h"
#import "UIViewController+Ext.h"
#import "Carwash.h"
#import "CarwashCell.h"
#import "CarwashViewController.h"
#import "UIViewController+NavigationBar.h"
#import "CarwashesMapViewController.h"
#import "SearchViewController.h"
#import "City.h"
#import "UserSettings.h"
#import "CarwashApi.h"
#import "CarwashesHelper.h"
#import "LocationHelper.h"
#import "SearchFilterViewController.h"
#import "UIViewController+NoContent.h"
#import "SVProgressHUD+Ext.h"
#import "UIScrollView+InfiniteScroll.h"
#import "FilterManager.h"
#import "User.h"
#import "LGRefreshView.h"
#import "AppDelegate.h"
#import "Toast.h"
#import "UITabBarItem+CustomBadge.h"
#import "USerApi.h"
#import "CarwashBook.h"

@interface NearbyCarwashesViewController ()
@end

@implementation NearbyCarwashesViewController {
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self subscribeForNotifications];
    
    // Request push notification permissions
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate requestPushAndLocalNotificationPermissions];
    
    //Set badge
    NSNumber *badgeCount = [[NSUserDefaults standardUserDefaults] objectForKey:@"badgeCountApplication"];
    if (badgeCount.intValue > 0) {
        [[[[[self tabBarController] tabBar] items] objectAtIndex:3] setCustomBadgeValue:[NSString stringWithFormat:@"%i", badgeCount.intValue] withFont:[UIFont robotoBold:12.f] andFontColor:[UIColor whiteColor] andBackgroundColor:[UIColor colorWithRed:37.f/255.f green:195.f/255.f blue:91.f/255.f alpha:1.f]];
    } else {
        [[[[[self tabBarController] tabBar] items] objectAtIndex:3] setBadgeValue:nil];
    }

    [[LocationHelper sharedInstance] requestLocation:^(CLLocation *currentLocation) {
        [self loadCarwashes:YES];

        // Define or check the nearest city
        [UserSettings defineCurrentCity];

    } failed:^(INTULocationStatus status) {
        [self loadCarwashes:NO];

        // Define or check the nearest city
        [UserSettings defineCurrentCity];
    }];

    self.allowInfiniteLoading = YES;
}

-(void)loadCarwashes:(BOOL)loadingMore
{
    // Remove no content message if any
    [self removeNoContentMessageIfExists];

    if(!loadingMore || (loadingMore && self.page == 1))[Toast showHudLoading];//[SVProgressHUD showLoading];
    
    //[CarwashApi getPublicCarwashes:nil success:^(NSArray *response) {
    [CarwashApi getCarwashes:self.page filterManager:self.filterManager success:^(NSArray *response) {

        //[SVProgressHUD dismiss];
        [self.list finishInfiniteScroll];

        if(response && response.count == 0) {
            self.allowInfiniteLoading = NO;
        }

        if(!self.carwashes) {
            self.carwashes = [[NSMutableArray alloc] init];
        }

        if(!loadingMore) {
            self.carwashes = [response mutableCopy];
        } else {
            [self.carwashes addObjectsFromArray:response];
        }
        if(self.carwashes.count == 0) {
            [self showNoContentMessage:@"Ничего не найдено"];
        }
        [self.list reloadData];
    } failure:^(NSInteger code, NSString *message) {
        [SVProgressHUD dismiss];
    }];
}

-(void)refreshCarwashes {
    // Remove no content message if any
    [self removeNoContentMessageIfExists];
    
    self.page = 1;
    //self.filterManager = 0;
    
    //[SVProgressHUD showLoading];
    [CarwashApi getCarwashes:self.page filterManager:self.filterManager success:^(NSArray *response) {
        
        [SVProgressHUD dismiss];
        [self.list finishInfiniteScroll];
        
        if(response && response.count == 0) {
            self.allowInfiniteLoading = NO;
        }
        
        if(!self.carwashes) {
            self.carwashes = [[NSMutableArray alloc] init];
        }
        self.carwashes = [response mutableCopy];
        
        if(self.carwashes.count == 0) {
            [self showNoContentMessage:@"Ничего не найдено"];
        }
        [self.list reloadData];
        [self.refreshView endRefreshing];
        
    } failure:^(NSInteger code, NSString *message) {
        [SVProgressHUD dismiss];
    }];
}

- (void)updateBooksBadge:(NSNotification *) notification {
    [UserApi bookingsWithStatus:nil success:^(id response) {
        NSArray *bookings = [NSArray arrayWithArray:response];
        int badgeCount = 0;
        for (CarwashBook *book in bookings) {
            if (book.isPending || book.isApproved) {
                badgeCount++;
            }
        }
        if (badgeCount > 0) {
            [[[[[self tabBarController] tabBar] items] objectAtIndex:3] setCustomBadgeValue:[NSString stringWithFormat:@"%i", badgeCount] withFont:[UIFont robotoBold:12.f] andFontColor:[UIColor whiteColor] andBackgroundColor:[UIColor colorWithRed:37.f/255.f green:195.f/255.f blue:91.f/255.f alpha:1.f]];
            [UIApplication sharedApplication].applicationIconBadgeNumber = badgeCount;
        } else {
            [[[[[self tabBarController] tabBar] items] objectAtIndex:3] setBadgeValue:nil];
            [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        }
        [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInt:badgeCount] forKey:@"badgeCountApplication"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } failure:^(NSInteger code, NSString *message) {
        
    }];
}

#pragma mark -
#pragma mark Actions

- (void)tapNavigationMenuButton {
    SearchFilterViewController *v = [SearchFilterViewController new];
    v.delegate = self;
    v.filterManager = self.filterManager;
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:v];
    [self presentViewController:nc animated:YES completion:nil];
}

#pragma mark -
#pragma mark SearchFilterViewController

- (void)SearchFilterViewControllerSearchWithFilter:(FilterManager *)filterManager {
    self.filterManager = filterManager;
    [self dismissViewControllerAnimated:YES completion:^{
        [self loadCarwashes:NO];
    }];
}

#pragma mark - Notifications

- (void) subscribeForNotifications
{
    [self unsubscribeFromNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateBooksBadge:)
                                                 name: @"UpdateBooksBadge"
                                               object:nil];
}

- (void) unsubscribeFromNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name: @"UpdateBooksBadge"
                                                  object:nil];
}


#pragma mark -

-(void)configUI
{
    [super configUI];
    [self setNavigationTitle:@"Астана"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc {
    [self unsubscribeFromNotifications];
}

@end