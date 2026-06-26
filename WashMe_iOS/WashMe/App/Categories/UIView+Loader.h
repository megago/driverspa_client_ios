//
//  UIView+Loader.h
//  Zenge
//
//  Created by Almas Adilbek on 12/17/15.
//  Copyright © 2015 Zenge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Loader)

- (void)showLoader:(NSString *)message;
- (void)showLoader:(NSString *)message translucentNavigation:(BOOL)tn;
- (void)showLoader:(NSString *)message color:(UIColor *)tintColor;
- (void)showLoader:(NSString *)message translucentNavigation:(BOOL)tn color:(UIColor *)tintColor;

- (void)removeLoader;

- (void)showWhiteLoader;
- (void)showGrayLoader;

- (void)fadeSubviews:(CGFloat)alpha;
- (void)fadeInSubviews;

@end
