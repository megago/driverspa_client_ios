//
//  Toast.h
//  Kiwi.kz
//
//  Created by Almas Adilbek on 08/20/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//



@interface Toast : NSObject

+(void)showHud;
+(void)showHudWithTitle:(NSString *)title;

+(void)hideHud;
+(void)showHudLoading;
+(void)showHudWait;

// Toast huds
+(void)showToastWithIcon:(NSString *)iconName;
+(void)showToastWithMessage:(NSString *)message icon:(NSString *)iconName;

// Predefined Toasts huds
+(void)showSuccessToast;
+(void)showSuccessToastWithMessage:(NSString *)message;
+(void)showErrorToast;
+(void)showErrorToastWithMessage:(NSString *)message;
+(void)showDelayedSuccessToast;
+(void)showDelayedSuccessToastWithMessage:(NSString *)message;

@end
