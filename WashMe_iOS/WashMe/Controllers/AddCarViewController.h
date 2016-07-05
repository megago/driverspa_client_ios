//
//  AddCarViewController.h
//  WashMe
//
//  Created by Almas Adilbek on 3/30/16.
//  Copyright (c) 2016 Almas Adilbek. All rights reserved.
//



#import "ScrollViewController.h"
#import "CarTypesTabbarView.h"
#import "Car.h"

@protocol AddCarViewControllerDelegate<NSObject>
- (void)AddCarViewControllerCarAdded:(Car *)car;
@end

@interface AddCarViewController : ScrollViewController <CarTypesTabbarViewDelegate>

@property(nonatomic, weak) id <AddCarViewControllerDelegate> delegate;

@end
