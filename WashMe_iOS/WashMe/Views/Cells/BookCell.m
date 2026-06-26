//
//  BookCell.m
//  WashMe
//
//  Created by Ivan Korotkikh on 06.08.16.
//  Copyright © 2016 Almas Adilbek. All rights reserved.
//

#import "BookCell.h"
#import "CarwashBook.h"
#import "UIView+Ext.h"

#define  kBookTimeWidth 60

@interface BookCell () {
    UILabel *clientLabel;
    UILabel *statusLabel;
    UILabel *timeLabel;
    UILabel *daysAgoLabel;
}

@end

@implementation BookCell

-(id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if(self) {
        self.backgroundColor = [UIColor clearColor];
        UIImageView *disclosureIndicator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-disclosure-indicator-white"]];
        self.accessoryView = disclosureIndicator;
        self.selectedBackgroundView = [UIView cellSelectionBackground];
        
        timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        timeLabel.y = kTitlePaddingTop;
        timeLabel.backgroundColor = [UIColor clearColor];
        timeLabel.font = kTitleFont;
        timeLabel.textColor = [UIColor whiteColor];
        timeLabel.lineBreakMode = NSLineBreakByWordWrapping;
        timeLabel.numberOfLines = 1;
        timeLabel.x = kPaddingTitleLeft;
        [self addSubview:timeLabel];
        
        daysAgoLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        daysAgoLabel.y = kTitlePaddingTop;
        daysAgoLabel.backgroundColor = [UIColor clearColor];
        daysAgoLabel.font = kTitleFont;
        daysAgoLabel.textColor = [UIColor colorWithWhite:1.f alpha:0.5f];
        daysAgoLabel.lineBreakMode = NSLineBreakByWordWrapping;
        daysAgoLabel.numberOfLines = 0;
        daysAgoLabel.x = kPaddingTitleLeft;
        [self addSubview:daysAgoLabel];

        titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        titleLabel.y = kTitlePaddingTop;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = kTitleFont;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        titleLabel.numberOfLines = 1;
        titleLabel.x = 2 * kPaddingTitleLeft + kBookTimeWidth;
        [self addSubview:titleLabel];
        
        clientLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        clientLabel.backgroundColor = [UIColor clearColor];
        clientLabel.font = kTitleFont;
        clientLabel.textColor = [UIColor whiteColor];
        clientLabel.lineBreakMode = NSLineBreakByWordWrapping;
        clientLabel.numberOfLines = 1;
        clientLabel.x = 2 * kPaddingTitleLeft + kBookTimeWidth;
        [self addSubview:clientLabel];
        
        statusLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        statusLabel.backgroundColor = [UIColor clearColor];
        statusLabel.font = kTitleFont;
        statusLabel.textColor = [UIColor colorWithWhite:1.f alpha:0.5f];
        statusLabel.lineBreakMode = NSLineBreakByWordWrapping;
        statusLabel.numberOfLines = 1;
        statusLabel.x = 2 * kPaddingTitleLeft + kBookTimeWidth;
        [self addSubview:statusLabel];
        
    }
    return self;
}

-(void)setCarwashBook:(CarwashBook *)book
{
    titleLabel.text = book.carwashName;
    [titleLabel sizeToFit];
    
    clientLabel.text = book.clientKey;
    clientLabel.y = titleLabel.bottom;
    [clientLabel sizeToFit];
    
    statusLabel.text = [book localizedStatus];
    statusLabel.y = clientLabel.bottom;
    [statusLabel sizeToFit];
    
    timeLabel.text = [book localBookTime];
    [timeLabel sizeToFit];
    timeLabel.width = kBookTimeWidth;
    
    daysAgoLabel.text = [book localizedDaysAgo];
    [daysAgoLabel sizeToFit];
    daysAgoLabel.width = kBookTimeWidth;
    daysAgoLabel.y = timeLabel.bottom;
    daysAgoLabel.height = clientLabel.height + statusLabel.height;
    
    if (book.isApproved || book.isPending) {
        self.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.5f];
    } else {
        self.backgroundColor = [UIColor clearColor];
    }
}

+ (CGFloat)cellHeight: (CarwashBook *)book {
    CGSize titleSize = [book.carwashName sizeWithFont:kTitleFont constrainedToSize:CGSizeMake([[self class] titleWidth], CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    CGSize clientSize = [book.clientKey sizeWithFont:kTitleFont constrainedToSize:CGSizeMake([[self class] titleWidth], CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    
    CGSize statusSize = [[book localizedStatus] sizeWithFont:kTitleFont constrainedToSize:CGSizeMake([[self class] titleWidth], CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    
    return titleSize.height + clientSize.height + statusSize.height + 2 * kTitlePaddingTop;
}

@end
