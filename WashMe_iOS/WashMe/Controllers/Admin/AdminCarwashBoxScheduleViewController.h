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

@interface AdminCarwashBoxScheduleViewController : ScrollViewControllerOld <BoxesGridViewDelegate>

@property(nonatomic, assign) NSInteger boxIndex;
@property(nonatomic, strong) BoxSetting *boxSetting;
@property(nonatomic, copy) NSString *carwashId;

@end
