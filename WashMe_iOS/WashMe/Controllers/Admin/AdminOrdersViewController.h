//
//  AdminOrdersViewController.h
//  WashMe
//
//  Created by Almas Adilbek on 11/18/14.
//  Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

#import "AdminBookViewController.h"

typedef NS_ENUM(NSUInteger, AdminOrdersFilter) {
    AdminOrdersInProcessing,
    AdminOrdersTimeDayToday,
    AdminOrdersAll,
};

@interface AdminOrdersViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, AdminBookViewControllerDelegate>

@end
