//
// Created by Almas Adilbek on 10/25/14.
// Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

#import "UILabel+Components.h"


@implementation UILabel (Components)

+ (UILabel *)headerTitle:(NSString *)title
{
    UILabel *headerTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kViewControllerPadding, 0, [ASize screenWidth] - 2 * kViewControllerPadding, 1)];
    headerTitleLabel.backgroundColor = [UIColor clearColor];
    headerTitleLabel.font = [UIFont robotoRegular:14];
    headerTitleLabel.textColor = [UIColor whiteColor];
    headerTitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    headerTitleLabel.numberOfLines = 0;
    headerTitleLabel.text = title;
    [headerTitleLabel sizeToFit];
    return headerTitleLabel;
}

@end