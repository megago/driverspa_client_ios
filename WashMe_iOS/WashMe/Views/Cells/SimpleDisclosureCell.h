//
//  SimpleDisclosureCell.h
//  WashMe
//
//  Created by Almas Adilbek on 10/25/14.
//  Copyright (c) 2014 Almas Adilbek. All rights reserved.
//



#import "SimpleCell.h"
@class CarwashBook;

@interface SimpleDisclosureCell : SimpleCell

- (void)setCarwashBook: (CarwashBook *)carwashBook;
+ (CGFloat)cellHeight: (CarwashBook *)book;

@end
