//
// Created by Almas Adilbek on 9/28/14.
// Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CarwashReview;


@interface FeedbackCell : UITableViewCell

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;
- (void)setFeedback:(CarwashReview *)review;

+(CGFloat)cellHeight:(CarwashReview *)review;

@end