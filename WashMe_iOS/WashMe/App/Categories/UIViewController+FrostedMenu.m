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
    UIStoryboard *sb = [UIStoryboard storyboardWithName:storyboard bundle:nil];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:tabBar];
    // Only tab bar controllers have a selectedIndex — the same helper is also used to show
    // plain navigation controllers (e.g. "profile"), so guard the class before setting it.
    if([vc isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tc = (UITabBarController *) vc;
        if(selectedIndex >= 0 && selectedIndex < (NSInteger)tc.viewControllers.count) {
            tc.selectedIndex = selectedIndex;
        }
    }
    self.frostedViewController.contentViewController = vc;
    [self.frostedViewController hideMenuViewController];
}


@end
