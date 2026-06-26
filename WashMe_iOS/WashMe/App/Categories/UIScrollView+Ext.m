//
// Created by Almas Adilbek on 10/5/14.
// Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

#import "UIScrollView+Ext.h"
#import "UIFont+Custom.h"


@implementation UIScrollView (Ext)

- (UILabel *)setNavigationSubtitle:(NSString *)subtitle
{
    UILabel *subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, (CGFloat) (self.width * 0.8), 1)];
    subtitleLabel.backgroundColor = [UIColor clearColor];
    subtitleLabel.font = [UIFont robotoRegular:14];
    subtitleLabel.textColor = [UIColor whiteColor];
    subtitleLabel.textAlignment = NSTextAlignmentCenter;
    subtitleLabel.numberOfLines = 0;
    subtitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    subtitleLabel.text = subtitle;
    [subtitleLabel sizeToFit];
    subtitleLabel.centerX = self.centerX;
    [self addSubview:subtitleLabel];
    return subtitleLabel;
}

@end