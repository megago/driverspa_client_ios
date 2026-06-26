//
//  UIView+Loader.m
//  Zenge
//
//  Created by Almas Adilbek on 12/17/15.
//  Copyright © 2015 Zenge. All rights reserved.
//

#import <ObjectiveSugar/NSArray+ObjectiveSugar.h>
#import "UIView+Loader.h"
#import "UIView+ConcisePureLayout.h"

#define kLoaderTag 990

@implementation UIView (Loader)

- (void)showLoader:(NSString *)message {
    [self showLoader:message translucentNavigation:NO];
}

- (void)showLoader:(NSString *)message translucentNavigation:(BOOL)tn {
    [self showLoader:message translucentNavigation:tn color:[UIColor whiteColor]];
}

- (void)showLoader:(NSString *)message color:(UIColor *)tintColor {
    [self showLoader:message translucentNavigation:NO color:tintColor];
}

- (void)showLoader:(NSString *)message translucentNavigation:(BOOL)tn color:(UIColor *)tintColor
{
    UIView *loaderContainer = [UIView newAutoLayoutView];
    loaderContainer.tag = kLoaderTag;
    [self addSubview:loaderContainer];
    if(self.width >= 320) {
        [loaderContainer aa_setWidth:150];
    } else {
        [loaderContainer aa_sameWidthWith:self];
    }

    if(!tn) {
        [loaderContainer aa_centerInSuperview];
    } else {
        [loaderContainer aa_centerHorizontal];
        [loaderContainer aa_centerVerticalWithOffset:-64];
    }

    UIActivityIndicatorView *loader = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    loader.hidesWhenStopped = YES;
    [loader hidesWhenStopped];
    [loader aa_setDimensions];
    [loaderContainer addSubview:loader];
    [loader aa_superviewTop:0];
    [loader aa_centerHorizontal];
    [loader startAnimating];

    if(message) {
        UILabel *messageLabel = [UILabel newAutoLayoutView];
        messageLabel.backgroundColor = [UIColor clearColor];
        messageLabel.font = [UIFont systemFontOfSize:15];
        messageLabel.textColor = tintColor;
        messageLabel.text = message;
        messageLabel.numberOfLines = 0;
        messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        [loaderContainer addSubview:messageLabel];
        [messageLabel aa_pinUnderView:loader offset:15];
        [messageLabel aa_superviewFitWidth];
        [messageLabel aa_superviewBottom:0];
    } else {
        [loader aa_superviewBottom:0];
    }
}

- (void)removeLoader {
    UIView *loader = [self viewWithTag:kLoaderTag];
    if(loader) {
        [loader removeFromSuperview];
        loader = nil;
    }
}

- (void)showWhiteLoader {
    [self showLoaderWithStyle:UIActivityIndicatorViewStyleWhite];
}

- (void)showGrayLoader {
    [self showLoaderWithStyle:UIActivityIndicatorViewStyleGray];
}

- (void)fadeSubviews:(CGFloat)alpha {
    [self.subviews each:^(UIView *object) {
        object.alpha = alpha;
    }];
}

- (void)fadeInSubviews {
    [self.subviews each:^(UIView *object) {
        object.alpha = 1;
    }];
}


- (void)showLoaderWithStyle:(UIActivityIndicatorViewStyle)style {
    UIActivityIndicatorView *loader = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:style];
    loader.tag = kLoaderTag;
    loader.hidesWhenStopped = YES;
    [loader aa_setDimensions];
    [self addSubview:loader];
    [loader aa_centerInSuperview];
    [loader startAnimating];
}

@end
