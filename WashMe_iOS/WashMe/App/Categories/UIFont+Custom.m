//
// Created by Almas Adilbek on 9/7/14.
// Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

#import "UIFont+Custom.h"


@implementation UIFont (Custom)

+ (UIFont *)robotoThin:(CGFloat)size {
    return [UIFont fontWithName:@"Roboto-Thin" size:size];
}

+ (UIFont *)robotoRegular:(CGFloat)size {
    return [UIFont fontWithName:@"Roboto-Regular" size:size];
}

+ (UIFont *)robotoBold:(CGFloat)size {
    return [UIFont fontWithName:@"Roboto-Bold" size:size];
}

+ (UIFont *)robotoItalic:(CGFloat)size {
    return [UIFont fontWithName:@"Roboto-Italic" size:size];
}

+ (UIFont *)robotoCondensedLight:(CGFloat)size {
    return [UIFont fontWithName:@"RobotoCondensed-Light1100138" size:size];
}


@end