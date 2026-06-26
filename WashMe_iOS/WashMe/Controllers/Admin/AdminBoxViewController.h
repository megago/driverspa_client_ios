//
//  AdminBoxViewController.h
//  WashMe
//
//  Created by Almas Adilbek on 3/17/15.
//  Copyright (c) 2015 Almas Adilbek. All rights reserved.
//



@class CarwashComplex;

@interface AdminBoxViewController : UIViewController

@property(nonatomic, assign) NSInteger boxIndex;
@property(nonatomic, strong) CarwashComplex *carwashComplex;

@end
