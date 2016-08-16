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
#import "AMRatingControl.h"

#define kPadding 10
#define kCarwashTitleFont [UIFont robotoRegular:16]
#define kCarwashAddressFont [UIFont robotoRegular:14]
#define kCarwashTitleWidth ([ASize screenWidth] - 30)

#define kCarwashTitleFontOffline [UIFont robotoItalic:16]
#define kCarwashAddressFontOffline [UIFont robotoItalic:14]

@implementation CarwashCell {
    AMRatingControl *amRatingControl;
    UILabel *titleLabel;
    UILabel *addressLabel;
    UILabel *priceLabel;
    UILabel *distanceLabel;
    UIView *line;
    CarwashStatusView *carwashStatusView;
    //RatingView *ratingView;
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
        
        
        amRatingControl = [[AMRatingControl alloc] initWithLocation:CGPointMake(kPadding, kPadding)
                                                         emptyImage:[UIImage imageWithName:@"star-new-empty"]
                                                         solidImage:[UIImage imageWithName:@"star-new-rated"]
                                                       andMaxRating:5];
        amRatingControl.starWidthAndHeight = 12;
        amRatingControl.starSpacing = 1;
        amRatingControl.userInteractionEnabled = NO;
        [self addSubview:amRatingControl];
        
        //ratingView = [[RatingView alloc] init];
        //[self addSubview:ratingView];
        
        carwashStatusView = [[CarwashStatusView alloc] init];
        carwashStatusView.x = [ASize screenWidth] - carwashStatusView.frame.size.width - 3 * kPadding;
        carwashStatusView.y = kPadding;
        [self addSubview:carwashStatusView];
        
        

        titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        titleLabel.numberOfLines = 0;
        [self addSubview:titleLabel];
        
        addressLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        addressLabel.backgroundColor = [UIColor clearColor];
        addressLabel.textColor = [UIColor colorWithWhite:1.f alpha:0.5f];
        addressLabel.lineBreakMode = NSLineBreakByWordWrapping;
        addressLabel.numberOfLines = 0;
        [self addSubview:addressLabel];

        priceLabel= [[UILabel alloc] initWithFrame:CGRectZero];
        priceLabel.backgroundColor = [UIColor clearColor];
        priceLabel.textColor = [UIColor whiteColor];
        [self addSubview:priceLabel];

        //distanceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        //distanceLabel.backgroundColor = [UIColor clearColor];
        //distanceLabel.font = [UIFont robotoThin:14];
        //distanceLabel.textColor = [UIColor whiteColor];
        //[self addSubview:distanceLabel];

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
    NSString *carwashName = [NSString stringWithFormat:@"Автомойка %@", carwash.name];
    carwashName = [carwashName stringByReplacingOccurrencesOfString:@"Автомойка Автомойка" withString:@"Автомойка"];
    
    //[ratingView setRating:[carwash.rating integerValue]];
    //ratingView.x = kPadding;
    //ratingView.y = kPadding;
    [amRatingControl setRating:[carwash.rating integerValue]];
    
    if ([carwash.status isEqualToString:@"approved"]){
        [carwashStatusView setIsAvailable: YES];
    } else {
        [carwashStatusView setIsAvailable: NO];
    }
    
    titleLabel.font = [carwash.status isEqualToString:@"approved"] ? kCarwashTitleFont : kCarwashTitleFontOffline;
    titleLabel.width = kCarwashTitleWidth;
    titleLabel.x = kPadding;
    titleLabel.y = amRatingControl.bottom + 5;
    titleLabel.text = carwashName;
    [titleLabel sizeToFit];

    addressLabel.font = [carwash.status isEqualToString:@"approved"] ? kCarwashAddressFont : kCarwashAddressFontOffline;
    addressLabel.width = kCarwashTitleWidth;
    addressLabel.x = kPadding;
    addressLabel.y = titleLabel.bottom;
    addressLabel.text = carwash.address.length > 0 ? carwash.address : @" ";
    [addressLabel sizeToFit];

    NSInteger price = [carwash.price integerValue];
    priceLabel.font = [carwash.status isEqualToString:@"approved"] ? kCarwashAddressFont : kCarwashAddressFontOffline;
    priceLabel.width = kCarwashTitleWidth;
    priceLabel.x = kPadding;
    priceLabel.y = addressLabel.bottom + 5;
    priceLabel.text = price > 0 ? [NSString stringWithFormat:@"Кузов-салон от %@ ₸", [NSString integerFormattedNumberText:price]] : @"";
    [priceLabel sizeToFit];

    //distanceLabel.width = 150;
    //distanceLabel.text = [carwash distanceToText];
    //[distanceLabel sizeToFit];
    //distanceLabel.y = priceLabel.y;
    //distanceLabel.x = [ASize screenWidth] - distanceLabel.width - 34;

    line.y = (CGFloat) ([[self class] cellHeightWithCarwashName:carwash.name andAddress:carwash.address] - 0.5);
}

+ (CGFloat)cellHeightWithCarwashName:(NSString *)name andAddress:(NSString *)address
{
    CGSize sizeName = [name sizeWithFont:kCarwashTitleFontOffline constrainedToSize:CGSizeMake(kCarwashTitleWidth, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    CGSize sizeAddress = [name sizeWithFont:kCarwashAddressFontOffline constrainedToSize:CGSizeMake(kCarwashTitleWidth, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    return sizeName.height + sizeName.height + 2 * kPadding + 36;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    UIColor *color = carwashStatusView.backgroundColor;
    [super setSelected:selected animated:animated];
    
    if (selected){
        carwashStatusView.backgroundColor = color;
    }
}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    UIColor *color = carwashStatusView.backgroundColor;
    [super setHighlighted:highlighted animated:animated];
    
    if (highlighted){
        carwashStatusView.backgroundColor = color;
    }
}

@end
