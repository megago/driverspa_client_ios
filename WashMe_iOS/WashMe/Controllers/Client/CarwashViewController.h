//
// Created by Almas Adilbek on 9/18/14.
// Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FeedbacksViewController.h"
#import "ScrollViewControllerOld.h"
#import "MWPhotoBrowser.h"
#import "CirclePictureView.h"

@class Carwash;

@protocol CarwashViewControllerDelegate

@end

@interface CarwashViewController : ScrollViewControllerOld <FeedbacksViewControllerDelegate, CarwashPictureViewDelegate, MWPhotoBrowserDelegate>

@property(nonatomic, weak) id <CarwashViewControllerDelegate> delegate;
@property(nonatomic, strong) Carwash *carwash;

@end