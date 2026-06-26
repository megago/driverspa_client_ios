//
//  UserBookingsViewController.h
//  WashMe
//
//  Created by Almas Adilbek on 10/12/14.
//  Copyright (c) 2014 Almas Adilbek. All rights reserved.
//



#import "ScrollViewControllerOld.h"
#import "UserBookViewController.h"

#define kUserBookEditedNotification @"kUserBookEditedNotification"

@interface UserBookingsViewController : ScrollViewControllerOld <UITableViewDelegate, UITableViewDataSource, ClientBookViewControllerDelegate>

@end
