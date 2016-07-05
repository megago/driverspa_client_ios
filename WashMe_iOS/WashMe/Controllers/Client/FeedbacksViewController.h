//
// Created by Almas Adilbek on 9/27/14.
// Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AddFeedbackViewController.h"

@class CarwashComplex;

@protocol FeedbacksViewControllerDelegate;

@interface FeedbacksViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, AddFeedbackViewControllerDelegate>

@property(nonatomic, weak) id <FeedbacksViewControllerDelegate> delegate;
@property(nonatomic, strong) CarwashComplex *carwash;

@end

@protocol FeedbacksViewControllerDelegate;

@protocol FeedbacksViewControllerDelegate<NSObject>
-(void)feedbacksViewControllerCarwashFeedbacksUpdated:(CarwashComplex *)updatedCarwash;
@end