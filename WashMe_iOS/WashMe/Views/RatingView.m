//
//  RatingView.m
//  WashMe
//
//  Created by Almas Adilbek on 9/16/14.
//  Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

#import "RatingView.h"
#import "UIImage+Extensions.h"
#import "UIFont+Custom.h"

@implementation RatingView {
    UILabel *ratingLabel;
}

-(id)init {
    self = [super initWithFrame:CGRectMake(0, 0, 30, 15)];
    if(self)
    {
        UIImageView *bg = [[UIImageView alloc] initWithFrame:self.bounds];
        bg.image = [[UIImage imageWithName:@"border-button-pattern"] stretchableImageWithLeftCapWidth:6 topCapHeight:6];
        [self addSubview:bg];

        UIImageView *starImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-rating-star"]];
        starImageView.x = self.width - starImageView.width - 3;
        starImageView.y = (CGFloat) ((self.height - starImageView.height) * 0.5);
        [self addSubview:starImageView];

        ratingLabel = [[UILabel alloc] initWithFrame:CGRectMake(2, 0, 12, self.height)];
        ratingLabel.backgroundColor = [UIColor clearColor];
        ratingLabel.font = [UIFont robotoRegular:10];
        ratingLabel.textColor = [UIColor whiteColor];
        ratingLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:ratingLabel];

    }
    return self;
}

-(void)setRating:(NSInteger)rating {
    _rating = rating;
    ratingLabel.text = [NSString stringWithFormat:@"%ld", (long)rating];
}

@end
