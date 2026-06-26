//
//  SimpleCell.m
//  WashMe
//
//  Created by Almas Adilbek on 10/15/14.
//  Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

#import "SimpleCell.h"
#import "UIView+Ext.h"
#import "UIFont+Custom.h"



@implementation SimpleCell {

}

-(id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if(self) {

        titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = kTitleFont;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        titleLabel.numberOfLines = 0;
        titleLabel.x = kPaddingTitleLeft;
        [self.contentView addSubview:titleLabel];

    }
    return self;
}

-(void)setTitle:(NSString *)title
{
    CGFloat h = [SimpleCell cellHeight:title];

    titleLabel.text = title;
    titleLabel.width = [SimpleCell titleWidth];
    [titleLabel sizeToFit];
    titleLabel.centerY = (CGFloat) (h * 0.5);

    line.y = h;
}

+ (CGFloat)cellHeight:(NSString *)title {
    CGSize size = [title sizeWithFont:kTitleFont constrainedToSize:CGSizeMake([SimpleCell titleWidth], CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    return size.height + 2 * kTitlePaddingTop;
}


@end
