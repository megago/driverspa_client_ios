//
//  UIViewController+FrostedMenu.h
//  WashMe
//
//  Created by Almas Adilbek on 4/2/16.
//  Copyright © 2016 Almas Adilbek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (FrostedMenu)

- (void)showMenu;
- (void)hideMenu;

- (void)pushViewControllerInCurrentContentController:(UIViewController *)viewController;
- (void)showControllerInStoryboard: (NSString *)storyboard navigation:(NSString *)navigation andTitle:(NSString*)title;
- (void)showControllerInStoryboard: (NSString *)storyboard tabBar:(NSString *)tabBar;

@end
