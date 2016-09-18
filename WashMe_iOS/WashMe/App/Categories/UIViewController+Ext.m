//
// Created by Almas Adilbek on 9/7/14.
// Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

#import "UIViewController+Ext.h"
#import "UIFont+Custom.h"
#import "Version.h"
#import "ASize.h"
#import "AAButton.h"
#import "AAButton+Styles.h"
#import "AppDelegate.h"
#import "UIViewController+NoContent.h"

#define kWhiteLogoTag 100


#define kNoContentContainerTag 404

@implementation UIViewController (Ext)

- (void)setBlueBackground {
    UIImageView *bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"blue-bg"]];
    bgView.width = [ASize screenWidth];
    bgView.height = [ASize screenHeight];
    [self.view insertSubview:bgView atIndex:0];
}

- (void)createWashMeWhiteLogo {
    UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"washme-logo"]];
    logo.tag = kWhiteLogoTag;
    logo.centerX = self.view.centerX;
    logo.y = 40;
    [self.view addSubview:logo];
}

- (UIImageView *)whiteLogo {
    return (UIImageView *) [self.view viewWithTag:kWhiteLogoTag];
}

-(void)setNavigationTitle:(NSString *)title
{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, (CGFloat) ([ASize screenWidth] * 0.7), 1)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont robotoBold:16];
    [titleLabel setMinimumScaleFactor:(14.f / 16.f)];
    titleLabel.adjustsFontSizeToFitWidth = YES;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    titleLabel.numberOfLines = 2;
    titleLabel.text = title;
    [titleLabel sizeToFit];
    titleLabel.x = (CGFloat) (([ASize screenWidth] - titleLabel.width) * 0.5);
    titleLabel.y = (CGFloat) ((44 - titleLabel.height) * 0.5) + [Version iOS7:20 or:0];
    [self.view addSubview:titleLabel];
}

- (void)setBackButtonInNavigation
{
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconNavigationBack"] style:UIBarButtonItemStylePlain target:self action:@selector(goBackTapped)];
    self.navigationItem.leftBarButtonItem = backButton;
}

- (void)setBackButton {
    [self createBarButtonAtLeft:YES buttonImage:@"iconNavigationBack" target:self selector:@selector(goBackTapped)];
}

- (UIButton *)createBarButtonAtLeft:(BOOL)atLeft buttonImage:(NSString *)imageName target:(id)target selector:(SEL)_selector
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:target action:_selector forControlEvents:UIControlEventTouchUpInside];
    UIImage *image = [UIImage imageNamed:imageName];
    button.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    [button setImage:image forState:UIControlStateNormal];
    button.showsTouchWhenHighlighted = YES;

    CGFloat padding = 13;

    if(atLeft) {
        button.x = (CGFloat) ((24 - image.size.width) * 0.5) + padding;
    } else {
        button.x = [ASize screenWidth] - (CGFloat) ((24 - image.size.width) * 0.5) - padding - image.size.width;
    }

    button.y = (CGFloat) ((44 - button.frame.size.height) * 0.5) + [Version iOS7:20 or:0];

    [self.view addSubview:button];

    return button;
}

- (void)createBarButtonAtLeftInNavigarion:(BOOL)atLeft buttonImage:(NSString *)imageName target:(id)target selector:(SEL)_selector
{
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:imageName] style:UIBarButtonItemStylePlain target:target action:_selector];
    if (atLeft) {
        self.navigationItem.leftBarButtonItem = button;
    } else {
        self.navigationItem.rightBarButtonItem = button;
    }
}


#pragma mark -
#pragma mark Actions

- (void)goBackTapped {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)hideKeyboard {
    [self.view endEditing:YES];
}

- (void)closeModalViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark Tabbar

- (void)setTabBarVisible:(BOOL)visible animated:(BOOL)animated completion:(void (^)(BOOL))completion {
    
    if ([self tabBarIsVisible] == visible) return (completion)? completion(YES) : nil;
    
    CGRect frame = self.tabBarController.tabBar.frame;
    CGFloat height = frame.size.height;
    CGFloat offsetY = (visible)? -height : height;
    
    CGFloat duration = (animated)? 0.3 : 0.0;
    
    [UIView animateWithDuration:duration animations:^{
        self.tabBarController.tabBar.frame = CGRectOffset(frame, 0, offsetY);
    } completion:completion];
}

- (BOOL)tabBarIsVisible {
    return self.tabBarController.tabBar.frame.origin.y < CGRectGetMaxY(self.view.frame);
}

@end