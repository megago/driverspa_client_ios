//
//  UIHelper.h
//  Myth
//
//  Created by Almas Adilbek on 8/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AppDelegate;

@interface UIHelper : NSObject {

}

// Getters
+(AppDelegate *)appDelegate;
+(UIWindow *)delegateWindow;
+(UIViewController *)windowRootViewController;

// Alerts
+(void)showAlertWithMessage:(NSString *)message;
+(void)showAlertWithMessageTitle:(NSString *)title message:(NSString *)message;
+(void)showErrorAlertWithMessage:(NSString *)message;
+(void)showAlertTryAgain;

+(void)showAlertFillRequiredField;

// Status bar
+(void)setupWhiteStatusBar:(BOOL)animated;
+(void)setupBlackStatusBar:(BOOL)animated;


@end
