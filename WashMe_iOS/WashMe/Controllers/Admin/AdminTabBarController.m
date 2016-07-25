//
//  AdminTabBarController.m
//  WashMe
//
//  Created by Ivan Korotkikh on 24.07.16.
//  Copyright © 2016 Almas Adilbek. All rights reserved.
//

#import "AdminTabBarController.h"

@interface AdminTabBarController ()

@end

@implementation AdminTabBarController

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
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor] }
                                             forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor fromRGB:0x03a9f4] }
                                             forState:UIControlStateSelected];
    
    NSArray *images = @[@"tab-nearby", @"iconTimetable", @"tab-nearby", ];
    NSArray *imagesSelected = @[@"tab-nearby-active", @"iconTimetableBlue", @"tab-nearby-active", ];
    
    NSUInteger index = 0;
    for(UITabBarItem *item in self.tabBar.items) {
        item.image = [[UIImage imageNamed:images[index]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        item.selectedImage = [[UIImage imageNamed:imagesSelected[index]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        ++index;
    }
}

@end
