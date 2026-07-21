//
//  CustomTabBarController.m
//  StandardInsurance
//
//  Created by Almas Adilbek on 1/30/15.
//  Copyright (c) 2015 Crystal Spring. All rights reserved.
//

#import "CustomTabBarController.h"

@implementation CustomTabBarController

// The bottom tab bar was removed from the UI. Keep the UITabBarController (the side
// drawer still switches sections via -selectedIndex), but hide the bar and let the
// selected section fill the whole screen.
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];

    self.tabBar.hidden = YES;
    CGRect tabFrame = self.tabBar.frame;
    tabFrame.size.height = 0;
    tabFrame.origin.y = self.view.bounds.size.height;
    self.tabBar.frame = tabFrame;

    CGRect bounds = self.view.bounds;
    for (UIViewController *vc in self.viewControllers) {
        if (vc.isViewLoaded) {
            vc.view.frame = bounds;
        }
    }
}

+ (CGFloat)tabbarHeight {
    return 0;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [UITabBar appearance].barTintColor = [UIColor fromRGB:0x000c1c];
    [UITabBar appearance].tintColor = [UIColor fromRGB:0x03a9f4];

    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSFontAttributeName : [UIFont robotoBold:9],
                                                         NSForegroundColorAttributeName : [UIColor whiteColor] }
                                             forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSFontAttributeName : [UIFont robotoBold:9],
                                                         NSForegroundColorAttributeName : [UIColor fromRGB:0x03a9f4] }
                                             forState:UIControlStateSelected];

    // Tab order matches Android DriverSpa client: Map, Nearby, Bookings, Notifications, Favorites.
    NSArray *images = @[@"tab-map", @"tab-nearby", @"tab-timer", @"tab-comment", @"tab-favorites"];
    NSArray *imagesSelected = @[@"tab-map-active", @"tab-nearby-active", @"tab-timer-active", @"tab-comment-active", @"tab-favorites-active"];

    NSUInteger index = 0;
    for(UITabBarItem *item in self.tabBar.items) {
        if(index >= images.count) break;
        item.image = [[UIImage imageNamed:images[index]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        item.selectedImage = [[UIImage imageNamed:imagesSelected[index]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        ++index;
    }
    // Lands on the carwashes list (index 1). Map is reached from the list's top-right
    // "map" button; the map screen has a top-left "list" button to come back.
    [self setSelectedIndex:1];
}

@end
