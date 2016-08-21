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

    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSFontAttributeName : [UIFont robotoRegular:10],
                                                         NSForegroundColorAttributeName : [UIColor whiteColor] }
                                             forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSFontAttributeName : [UIFont robotoRegular:10],
                                                         NSForegroundColorAttributeName : [UIColor fromRGB:0x03a9f4] }
                                             forState:UIControlStateSelected];

    NSArray *images = @[@"tab-favorites", @"tab-free", @"tab-map", @"tab-timer"];
    NSArray *imagesSelected = @[@"tab-favorites-active", @"tab-free-active", @"tab-map-active", @"tab-timer-active"];

    NSUInteger index = 0;
    for(UITabBarItem *item in self.tabBar.items) {
        item.image = [[UIImage imageNamed:images[index]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        item.selectedImage = [[UIImage imageNamed:imagesSelected[index]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        ++index;
    }
    [self setSelectedIndex:1];
}

@end
