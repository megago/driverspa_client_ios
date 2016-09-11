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

@interface AdminCarwashBoxScheduleViewController : ScrollViewControllerOld <BoxesGridViewDelegate>

//@property(nonatomic, assign) NSInteger boxIndex;
//@property(nonatomic, copy) NSString *carwashId;

@property(nonatomic, strong) BoxSetting *currentBox;
@property(nonatomic, strong) CarwashComplex *currentCarwash;

@end
