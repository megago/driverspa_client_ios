//
//  BookResultViewController.h
//  WashMe
//
//  Created by Almas Adilbek on 10/9/14.
//  Copyright (c) 2014 Almas Adilbek. All rights reserved.
//



#import "ScrollViewControllerOld.h"

@class CarwashBook;
@class CarwashComplex;
@class BookObject;

@interface BookResultViewController : ScrollViewControllerOld

@property(nonatomic, strong) CarwashBook *carwashBook;
@property(nonatomic, strong) BookObject *bookObject;

@end
