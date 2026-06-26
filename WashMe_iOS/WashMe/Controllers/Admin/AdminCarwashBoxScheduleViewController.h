//
//  AdminCarwashBoxScheduleViewController.h
//  WashMe
//
//  Created by Almas Adilbek on 3/28/15.
//  Copyright (c) 2015 Almas Adilbek. All rights reserved.
//

#import "ScrollViewControllerOld.h"
#import "BoxesGridView.h"

@class BoxSetting;
@class CarwashComplex;
@class BookObject;

@interface AdminCarwashBoxScheduleViewController : ScrollViewControllerOld <BoxesGridViewDelegate>

@property(nonatomic, strong) BoxSetting *currentBox;
@property(nonatomic, strong) CarwashComplex *currentCarwash;
@property(nonatomic, strong) BookObject *bookObject;

@end
