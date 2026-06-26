//
//  UIHelper.m
//  Myth
//
//  Created by Almas Adilbek on 8/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UIHelper.h"
#import "CRGradientNavigationBar.h"
#import "AppDelegate.h"
#import "Version.h"

@implementation UIHelper

#pragma mark -
#pragma mark Getters

+(AppDelegate *)appDelegate {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}
+(UIWindow *)delegateWindow {
    return [[[UIApplication sharedApplication] delegate] window];
}

+ (UIViewController *)windowRootViewController {
    return [[self delegateWindow] rootViewController];
}


#pragma mark -
#pragma mark Alerts

+ (void)showAlertWithMessage:(NSString *)message {
    [self showAlertWithMessageTitle:@"" message:message];
}

+(void)showAlertWithMessageTitle:(NSString *)title message:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}
+(void)showErrorAlertWithMessage:(NSString *)message {
    [UIHelper showAlertWithMessageTitle:@"Ошибка" message:message];
}

+(void)showAlertTryAgain {
    [self showErrorAlertWithMessage:@"Произошла ошибка, попробуйте еще раз."];
}

#pragma mark -
#pragma mark Status Bar

+(void)setupWhiteStatusBar:(BOOL)animated {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:animated];
}

+(void)setupBlackStatusBar:(BOOL)animated {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:animated];
}

#pragma mark -
#pragma mark Api Response

+(void)showAlertFillRequiredField {
    [self showAlertWithMessageTitle:@"Внимание" message:@"Заполните все обязательные поля"];
}

#pragma mark -
#pragma mark Helper

+(UINavigationController *)gradientNavigationController
{
    UINavigationController *navigationController = [[UINavigationController alloc] initWithNavigationBarClass:[CRGradientNavigationBar class] toolbarClass:nil];
    [[navigationController navigationBar] setTranslucent:NO];
    
    return navigationController;
}

@end
