//
// Created by Almas Adilbek on 10/5/14.
// Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

#import "UIView+Ext.h"


@implementation UIView (Ext)

+(UIView *)cellSelectionBackground {
    UIView *selectionBg = [[UIView alloc] initWithFrame:CGRectZero];
    [selectionBg setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2]];
    return selectionBg;
}

+ (UIView *)headerViewWithTitle:(NSString *)title
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [ASize screenWidth], 1)];
    view.backgroundColor = [UIColor colorWithHue:0 saturation:0 brightness:0 alpha:0.15];

    CGFloat padding = 5;

    UILabel *headerTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kViewControllerPadding, padding, view.width - 2 * kViewControllerPadding, 1)];
    headerTitleLabel.backgroundColor = [UIColor clearColor];
    headerTitleLabel.font = [UIFont robotoBold:14];
    headerTitleLabel.textColor = [UIColor whiteColor];
    headerTitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    headerTitleLabel.numberOfLines = 0;
    headerTitleLabel.text = title;
    [headerTitleLabel sizeToFit];

    [view addSubview:headerTitleLabel];
    view.height = headerTitleLabel.bottom + padding;

    return view;
}


@end