//
//  BookSetCarViewController.h
//  WashMe
//
//  Created by Almas Adilbek on 10/5/14.
//  Copyright (c) 2014 Almas Adilbek. All rights reserved.
//



#import "ScrollViewControllerOld.h"
#import "BookingCarwashServicesViewController.h"
#import "CarTypesTabbarView.h"

@class CarwashComplex;
@class BookObject;

@interface BookSetCarViewController : ScrollViewControllerOld <WashParamsViewControllerDelegate, CarTypesTabbarViewDelegate>

@property(nonatomic, strong) CarwashComplex *carwash;
@property(nonatomic, strong) BookObject *bookObject;
@property(nonatomic, assign, getter=isEditMode) BOOL editMode;

@end
