//
//  UIViewController+FrostedMenu.m
//  WashMe
//
//  Created by Almas Adilbek on 4/2/16.
//  Copyright © 2016 Almas Adilbek. All rights reserved.
//

#import <REFrostedViewController/UIViewController+REFrostedViewController.h>
#import <REFrostedViewController/REFrostedViewController.h>
#import "UIViewController+FrostedMenu.h"

@implementation UIViewController (FrostedMenu)

- (void)showMenu {
    [self.frostedViewController presentMenuViewController];
}

- (void)hideMenu {
    [self.frostedViewController hideMenuViewController];
}

- (void)pushViewControllerInCurrentContentController:(UIViewController *)viewController {
    viewController.hidesBottomBarWhenPushed = YES;
    UITabBarController *controller = (UITabBarController *) self.frostedViewController.contentViewController;
    UINavigationController *nc = controller.viewControllers[controller.selectedIndex];
    [nc pushViewController:viewController animated:YES];
    [self hideMenu];
}

@end
