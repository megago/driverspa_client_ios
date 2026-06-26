//
//  Toast.m
//  Kiwi.kz
//
//  Created by Almas Adilbek on 08/20/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "MBProgressHUD.h"
#import "Toast.h"
#import "UIImage+Extensions.h"
#import "NSObject+PWObject.h"

static MBProgressHUD *_hub;

@implementation Toast

+(void)showHud {
    [self showHudWithTitle:nil];
}
+(void)showHudWithTitle:(NSString *)title {
    if(!_hub) {
        UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
        [window setUserInteractionEnabled:NO];
        _hub = [[MBProgressHUD alloc] initWithView:window];
        [window addSubview:_hub];
        if(title && title.length > 0) _hub.labelText = title;
        [_hub show:YES];
    }
}
+(void)showHudLoading {
    [self showHudWithTitle:@"Загрузка"];
}
+(void)showHudWait {
    [self showHudWithTitle:@"Ждите"];
}
+(void)hideHud {
    if(_hub) {
        [[_hub superview] setUserInteractionEnabled:YES];
        [_hub hide:YES];
        _hub = nil;
    }
}

#pragma mark -
#pragma mark Hud toasts

+(void)showToastWithIcon:(NSString *)iconName {
    [self showToastWithMessage:@"" icon:iconName];
}

+(void)showToastWithMessage:(NSString *)message icon:(NSString *)iconName
{
    __weak UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    [window setUserInteractionEnabled:NO];

    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:window];
    [window addSubview:HUD];
    HUD.animationType = MBProgressHUDAnimationZoomIn;

    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageWithName:iconName]];
    HUD.mode = MBProgressHUDModeCustomView;

    HUD.labelText = message;

    [HUD show:YES];
    [HUD hide:YES afterDelay:1.5];

    [HUD setCompletionBlock:^{
        window.userInteractionEnabled = YES;
    }];
}

#pragma mark -
#pragma mark Predefined Hud toasts

+ (void)showSuccessToast {
    [self showSuccessToastWithMessage:@""];
}

+(void)showSuccessToastWithMessage:(NSString *)message {
    [self showToastWithMessage:message icon:@"icon-success-tick"];
}

+(void)showErrorToast {
    [self showErrorToastWithMessage:@""];
}

+(void)showErrorToastWithMessage:(NSString *)message {
    [self showToastWithMessage:message icon:@"icon-warning"];
}

+ (void)showDelayedSuccessToast {
    [self showDelayedSuccessToastWithMessage:@""];
}

+ (void)showDelayedSuccessToastWithMessage:(NSString *)message {
    [self performBlock:^{
        [self showSuccessToastWithMessage:message];
    } afterDelay:0.5];
}


@end
