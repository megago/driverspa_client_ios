//
//  AdminBookViewController.h
//  WashMe
//
//  Created by Almas Adilbek on 1/4/15.
//  Copyright (c) 2015 Almas Adilbek. All rights reserved.
//



#import "ScrollViewControllerOld.h"

@class CarwashBook;

@protocol AdminBookViewControllerDelegate<NSObject>
- (void)adminBookViewControllerBookStatusChanged:(CarwashBook *)book;
@end

@interface AdminBookViewController : ScrollViewControllerOld

@property(nonatomic, weak) id <AdminBookViewControllerDelegate> delegate;
@property(nonatomic, strong) CarwashBook *book;

@end
