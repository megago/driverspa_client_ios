//
// Created by Almas Adilbek on 9/28/14.
// Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

#import "FeedbackCell.h"
#import "AMRatingControl.h"
#import "UIFont+Custom.h"
#import "CarwashComplex.h"
#import "CarwashReview.h"

#define kPadding 20
#define kFeedbackMessageWidth [ASize screenWidth] - 2 * kPadding
#define kFeedbackMessageFont [UIFont robotoRegular:14]
#define kFeedbackMessageY 25
#define kCellBottomPadding 10

@implementation FeedbackCell {

    AMRatingControl *amRatingControl;
    UILabel *feedbackLabel;
    UIView *line;
}

-(id)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if(self) {

        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        amRatingControl = [[AMRatingControl alloc] initWithLocation:CGPointMake(kPadding, 0)
                                                         emptyImage:[UIImage imageWithName:@"star-small-empty"]
                                                         solidImage:[UIImage imageWithName:@"star-small-rated"]
                                                       andMaxRating:5];
        amRatingControl.userInteractionEnabled = NO;
        [self addSubview:amRatingControl];

        feedbackLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        feedbackLabel.backgroundColor = [UIColor clearColor];
        feedbackLabel.font = kFeedbackMessageFont;
        feedbackLabel.textColor = [UIColor whiteColor];
        feedbackLabel.lineBreakMode = NSLineBreakByWordWrapping;
        feedbackLabel.numberOfLines = 0;
        feedbackLabel.x = kPadding;
        feedbackLabel.y = kFeedbackMessageY;
        [self addSubview:feedbackLabel];

        line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [ASize screenWidth], 1)];
        [line setBackgroundColor:[UIColor whiteColor]];
        line.alpha = 0.2;
        [self addSubview:line];

    }
    return self;
}

- (void)setFeedback:(CarwashReview *)review
{
    [amRatingControl setRating:[review.mark integerValue]];
    amRatingControl.y = 8;

    feedbackLabel.width = kFeedbackMessageWidth;
    feedbackLabel.text = review.text;
    [feedbackLabel sizeToFit];

    line.y = feedbackLabel.bottom + kCellBottomPadding;
}

+ (CGFloat)cellHeight:(CarwashReview *)review {
    CGSize size = [review.text sizeWithFont:kFeedbackMessageFont constrainedToSize:CGSizeMake(kFeedbackMessageWidth, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    return size.height + kFeedbackMessageY + kCellBottomPadding;
}


@end