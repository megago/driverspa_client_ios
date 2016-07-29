//
//  UIViewController+NavigationBar.m
//  Zenge
//
//  Created by Almas Adilbek on 9/23/15.
//  Copyright © 2015 Zenge. All rights reserved.
//

#import <ConcisePureLayout/UIView+ConcisePureLayout.h>
#import "UIViewController+NavigationBar.h"
#import "UIViewController+Ext.h"
#import "UIViewController+REFrostedViewController.h"
#import "REFrostedViewController.h"
#import "ALView+PureLayout.h"

@implementation UIViewController (NavigationBar)

#pragma mark -
#pragma mark Actions

- (void)goBack {
    if(self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)dismissViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)closeViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)toggleMenu {
    if(self.frostedViewController.isBeingPresented) {
        [self.frostedViewController hideMenuViewController];
    } else {
        [self.frostedViewController presentMenuViewController];
    }
}

- (void)tapNavigationMenuButton {

}

#pragma mark -

- (void)showMenuButton {
    [self setNavigationButtonWithIcon:@"iconHamburger" atLeft:YES selector:@selector(toggleMenu)];
}

- (void)showMenuButtonOrBackButton {
    if(self.navigationController.viewControllers.count > 1) {
        [self setNavigationBackButton];
    } else {
        [self showMenuButton];
    }
}

- (void)setNavigationCloseAtLeft:(BOOL)atLeft {
    [self setNavigationButtonWithIcon:@"icon-close-light" atLeft:atLeft selector:@selector(dismissViewController)];
}

- (void)makeBackButtonEmptyTitle {
    if(self.navigationItem) {
        // Do this in the parent view controller not in the child
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    }
}

- (void)setNavigationBackButton {
    if(self.navigationController) {
        [self.navigationItem hidesBackButton];
        [self setNavigationButtonWithIcon:@"iconNavigationBack" atLeft:YES selector:@selector(goBack)];
    }
}

#pragma mark -
#pragma mark Loader

- (void)showNavigationLoaderAtRight:(BOOL)atRight
{
    UIActivityIndicatorView *loader = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    loader.hidesWhenStopped = YES;
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:loader];

    if(atRight) {
        self.navigationItem.rightBarButtonItem = barButtonItem;
    } else {
        self.navigationItem.leftBarButtonItem = barButtonItem;
    }

    [loader startAnimating];
}

- (void)hideNavigationLoader
{
    id customView = self.navigationItem.rightBarButtonItem.customView;
    if(customView && [customView isKindOfClass:[UIActivityIndicatorView class]]) {
        UIActivityIndicatorView *loader = (UIActivityIndicatorView *)customView;
        if(loader.isAnimating) [loader stopAnimating];
        self.navigationItem.rightBarButtonItem = nil;
    } else {
        customView = self.navigationItem.leftBarButtonItem.customView;
        if(customView && [customView isKindOfClass:[UIActivityIndicatorView class]]) {
            UIActivityIndicatorView *loader = (UIActivityIndicatorView *)customView;
            if(loader.isAnimating) [loader stopAnimating];
            self.navigationItem.leftBarButtonItem = nil;
        }
    }
}

#pragma mark -
#pragma mark Filter

- (void)showNavigationMenuButton:(NSString *)title {
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250, 44)];

    UIView *container = [UIView newAutoLayoutView];
    [titleView addSubview:container];
    [container aa_superviewFitHeight];
    [container aa_centerHorizontal];

    UILabel *titleLabel = [UILabel newAutoLayoutView];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:15];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = title;
    [container addSubview:titleLabel];
    [titleLabel aa_superviewLeft:0];
    [titleLabel aa_superviewFitHeight];

    UIImageView *arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-menu-arrow.png"]];
    [arrowView aa_setDimensions];
    [container addSubview:arrowView];
    [arrowView aa_pinAfterView:titleLabel offset:8];
    [arrowView aa_centerVertical];
    [arrowView aa_superviewRight:0];

    UIControl *control = [UIControl newAutoLayoutView];
    [control addTarget:self action:@selector(tapNavigationMenuButton) forControlEvents:UIControlEventTouchUpInside];
    [container addSubview:control];
    [control autoPinEdgesToSuperviewEdges];

    self.navigationItem.titleView = titleView;
}

#pragma mark -
#pragma mark Helper

- (void)setNavigationButtonWithIcon:(NSString *)iconName atLeft:(BOOL)atLeft selector:(SEL)_selector
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:_selector forControlEvents:UIControlEventTouchUpInside];
    button.showsTouchWhenHighlighted = YES;
    UIImage *image = [UIImage imageNamed:iconName];
    button.width = image.size.width;
    button.height = image.size.height;
    [button setImage:image forState:UIControlStateNormal];
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    if(atLeft) {
        [self.navigationItem setLeftBarButtonItem:buttonItem animated:NO];
    } else {
        [self.navigationItem setRightBarButtonItem:buttonItem animated:NO];
    }
}

- (void)setNavigationBarTransparent {
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
}

- (void)setNavigationBarBlue {
    [self.navigationController.navigationBar setBackgroundColor:[UIColor colorWithRed:65.f/255.f green:120.f/255.f blue:185.f/255.f alpha:1.f]];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
}


- (void)hideBackButton {
    if(self.navigationItem) self.navigationItem.hidesBackButton = YES;
}


@end