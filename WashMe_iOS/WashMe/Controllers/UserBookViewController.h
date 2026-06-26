//
//  UserBookViewController.h
//  WashMe
//
//  Created by Almas Adilbek on 11/8/14.
//  Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

#import "ScrollViewControllerOld.h"

@protocol ClientBookViewControllerDelegate<NSObject>
@optional
- (void)clientBookViewControllerBookCanceled:(NSString *)bookId;
@end

@class CarwashBook;

@interface UserBookViewController : ScrollViewControllerOld

@property(nonatomic, weak) id <ClientBookViewControllerDelegate> delegate;
@property(nonatomic, strong) CarwashBook *book;

@property (nonatomic, assign) BOOL afterNotification;
@property (nonatomic, strong) NSString *bookId;
@property (nonatomic, strong) NSString *message;

@end
