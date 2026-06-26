//
// Created by Almas Adilbek on 10/1/14.
// Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ScrollViewControllerOld.h"

@class Carwash;

@protocol AddFeedbackViewControllerDelegate;

@interface AddFeedbackViewController : ScrollViewControllerOld

@property(nonatomic, weak) id <AddFeedbackViewControllerDelegate> delegate;
@property(nonatomic, strong) Carwash *carwash;

@end


@protocol AddFeedbackViewControllerDelegate<NSObject>
-(void)addFeedbackViewControllerFeedbackSent;
@end