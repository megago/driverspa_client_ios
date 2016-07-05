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

@end
