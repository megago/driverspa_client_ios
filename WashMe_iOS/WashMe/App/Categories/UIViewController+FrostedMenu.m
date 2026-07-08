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
    [self showControllerInStoryboard:storyboard tabBar:tabBar selectedIndex:0];
}

- (void)showControllerInStoryboard: (NSString *)storyboard tabBar:(NSString *)tabBar selectedIndex:(NSInteger)selectedIndex
{
    // If the tab bar is already the content, just switch tabs (keeps state).
    if([self.frostedViewController.contentViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *current = (UITabBarController *) self.frostedViewController.contentViewController;
        if(selectedIndex >= 0 && selectedIndex < (NSInteger)current.viewControllers.count) {
            current.selectedIndex = selectedIndex;
        }
        [self.frostedViewController hideMenuViewController];
        return;
    }

    UIStoryboard *sb = [UIStoryboard storyboardWithName:storyboard bundle:nil];
    UITabBarController *tc = [sb instantiateViewControllerWithIdentifier:tabBar];
    if(selectedIndex >= 0 && selectedIndex < (NSInteger)tc.viewControllers.count) {
        tc.selectedIndex = selectedIndex;
    }
    self.frostedViewController.contentViewController = tc;
    [self.frostedViewController hideMenuViewController];
}


@end
