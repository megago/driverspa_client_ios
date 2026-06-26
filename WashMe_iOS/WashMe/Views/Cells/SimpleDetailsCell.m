//
//  SimpleDetailsCell.m
//  WashMe
//
//  Created by Almas Adilbek on 11/25/14.
//  Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

#import "SimpleDetailsCell.h"

#define kDetailsLabelFont [UIFont robotoRegular:14]
#define kTitleDetailsSpacing 1

@implementation SimpleDetailsCell {
    UILabel *detailsLabel;
}

-(id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if(self) {

        titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        titleLabel.y = kTitlePaddingTop;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = kTitleFont;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        titleLabel.numberOfLines = 0;
        titleLabel.x = kPaddingTitleLeft;
        [self.contentView addSubview:titleLabel];

        detailsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        detailsLabel.backgroundColor = [UIColor clearColor];
        detailsLabel.font = kDetailsLabelFont;
        detailsLabel.textColor = [UIColor whiteColor];
        detailsLabel.lineBreakMode = NSLineBreakByWordWrapping;
        detailsLabel.numberOfLines = 0;
        detailsLabel.x = kPaddingTitleLeft;
        [self.contentView addSubview:detailsLabel];

    }
    return self;
}

-(void)setTitle:(NSString *)title details:(NSString *)detailsText
{
    titleLabel.text = title;
    titleLabel.width = [[self class] titleWidth];
    [titleLabel sizeToFit];

    detailsLabel.text = detailsText;
    detailsLabel.width = [[self class] titleWidth];
    [detailsLabel sizeToFit];
    detailsLabel.y = titleLabel.bottom + kTitleDetailsSpacing;

    CGFloat h = [[self class] cellHeight:title details:detailsText];
    line.y = h;
}

+ (CGFloat)cellHeight:(NSString *)title details:(NSString *)details {
    CGSize titleSize = [title sizeWithFont:kTitleFont constrainedToSize:CGSizeMake([[self class] titleWidth], CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    CGSize detailsSize = [details sizeWithFont:kDetailsLabelFont constrainedToSize:CGSizeMake([[self class] titleWidth], CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];

    return titleSize.height + detailsSize.height + 2 * kTitlePaddingTop;
}

@end
