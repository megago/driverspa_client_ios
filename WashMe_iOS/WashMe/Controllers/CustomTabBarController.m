//
//  CustomTabBarController.m
//  StandardInsurance
//
//  Created by Almas Adilbek on 1/30/15.
//  Copyright (c) 2015 Crystal Spring. All rights reserved.
//

#import "CustomTabBarController.h"

@implementation CustomTabBarController

- (void)viewWillLayoutSubviews
{
    CGRect tabFrame = self.tabBar.frame;
    tabFrame.size.height = [[self class] tabbarHeight] - 1;
    tabFrame.origin.y = self.view.frame.size.height - tabFrame.size.height;
    self.tabBar.frame = tabFrame;
}

+ (CGFloat)tabbarHeight {
    return 54;
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
    // Lands on Map (Android parity). GoogleMaps' simulator crash is handled in the map
    // views themselves (placeholder on TARGET_OS_SIMULATOR), so Map-first is safe here too.
    [self setSelectedIndex:0];
}

@end
