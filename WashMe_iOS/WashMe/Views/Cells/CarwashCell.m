//
//  CarwashCell.m
//  WashMe
//
//  Created by Almas Adilbek on 9/15/14.
//  Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

#import "CarwashCell.h"
#import "UIFont+Custom.h"
#import "CarwashStatusView.h"
#import "RatingView.h"
#import "Carwash.h"
#import "LocationHelper.h"
#import "UIView+Ext.h"
#import "NSString+Ext.h"

#define kPadding 10
#define kCarwashTitleFont [UIFont robotoRegular:16]
#define kCarwashTitleWidth ([ASize screenWidth] - 110)

@implementation CarwashCell {
    UILabel *titleLabel;
    UILabel *priceLabel;
    UILabel *distanceLabel;
    UIView *line;
    CarwashStatusView *carwashStatusView;
    RatingView *ratingView;
}

-(id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.backgroundColor = [UIColor clearColor];
        UIImageView *disclosureIndicator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-disclosure-indicator-white"]];
        self.accessoryView = disclosureIndicator;
        self.selectedBackgroundView = [UIView cellSelectionBackground];

        titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = kCarwashTitleFont;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        titleLabel.numberOfLines = 0;
        titleLabel.x = kPadding;
        titleLabel.y = kPadding;
        [self addSubview:titleLabel];

        carwashStatusView = [[CarwashStatusView alloc] init];
        carwashStatusView.y = titleLabel.y + 4;
        [self addSubview:carwashStatusView];

        priceLabel= [[UILabel alloc] initWithFrame:CGRectZero];
        priceLabel.backgroundColor = [UIColor clearColor];
        priceLabel.font = [UIFont robotoThin:14];
        priceLabel.textColor = [UIColor whiteColor];
        priceLabel.x = kPadding;
        [self addSubview:priceLabel];

        ratingView = [[RatingView alloc] init];
        [self addSubview:ratingView];

        distanceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        distanceLabel.backgroundColor = [UIColor clearColor];
        distanceLabel.font = [UIFont robotoThin:14];
        distanceLabel.textColor = [UIColor whiteColor];
        [self addSubview:distanceLabel];

        line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [ASize screenWidth] - 2 * kPadding, 0.5)];
        line.x = kPadding;
        [line setBackgroundColor:[UIColor whiteColor]];
        line.alpha = 0.2;
        [self addSubview:line];

    }
    return self;
}

- (void)setCarwash:(Carwash *)carwash
{
    titleLabel.width = kCarwashTitleWidth;
    titleLabel.text = carwash.name;
    [titleLabel sizeToFit];

    carwashStatusView.x = titleLabel.right + 6;
    [carwashStatusView setIsAvailable:carwash.isBookable];

    NSInteger price = [carwash.price integerValue];
    priceLabel.width = 150;
    priceLabel.text = price > 0 ? [NSString stringWithFormat:@"от %@ тг.", [NSString integerFormattedNumberText:price]] : @"";
    [priceLabel sizeToFit];
    priceLabel.y = titleLabel.bottom + 5;

    [ratingView setRating:[carwash.rating integerValue]];
    ratingView.x = price > 0 ? priceLabel.right + 9 : priceLabel.x;
    ratingView.y = priceLabel.y + 1;

    distanceLabel.width = 150;
    distanceLabel.text = [carwash distanceToText];
    [distanceLabel sizeToFit];
    distanceLabel.y = priceLabel.y;
    distanceLabel.x = [ASize screenWidth] - distanceLabel.width - 34;

    line.y = (CGFloat) ([[self class] cellHeight:carwash.name] - 0.5);
}

+ (CGFloat)cellHeight:(NSString *)model
{
    CGSize size = [model sizeWithFont:kCarwashTitleFont constrainedToSize:CGSizeMake(kCarwashTitleWidth, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    return size.height + 2 * kPadding + 20;
}


@end
