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

- (void)showControllerInStoryboard: (NSString *)storyboard navigation:(NSString *)navigation andTitle:(NSString*)title
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:storyboard bundle:nil];
    UINavigationController *nc = [sb instantiateViewControllerWithIdentifier:navigation];
    nc.topViewController.title = title;
    self.frostedViewController.contentViewController = nc;
    [self.frostedViewController hideMenuViewController];
}

- (void)showControllerInStoryboard: (NSString *)storyboard tabBar:(NSString *)tabBar
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:storyboard bundle:nil];
    UITabBarController *tc = [sb instantiateViewControllerWithIdentifier:tabBar];
    self.frostedViewController.contentViewController = tc;
    [self.frostedViewController hideMenuViewController];
}


@end
