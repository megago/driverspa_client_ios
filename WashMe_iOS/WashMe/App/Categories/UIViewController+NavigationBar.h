//
//  UIViewController+NavigationBar.h
//  Zenge
//
//  Created by Almas Adilbek on 9/23/15.
//  Copyright © 2015 Zenge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (NavigationBar)

- (void)goBack;
- (void)dismissViewController;
- (void)tapNavigationMenuButton;

- (void)toggleMenu;

- (void)showMenuButton;
- (void)showMenuButtonOrBackButton;
- (void)setNavigationCloseAtLeft:(BOOL)atLeft;

- (void)makeBackButtonEmptyTitle;
- (void)hideBackButton;

- (void)setNavigationBackButton;

- (void)showNavigationLoaderAtRight:(BOOL)atRight;
- (void)hideNavigationLoader;

- (void)showNavigationMenuButton:(NSString *)title;

- (void)setNavigationButtonWithIcon:(NSString *)iconName atLeft:(BOOL)atLeft selector:(SEL)_selector;

- (void)setNavigationBarTransparent;

@end
