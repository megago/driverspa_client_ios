//
//  BookAdminCell.h
//  WashMe
//
//  Created by Ivan Korotkikh on 21.08.16.
//  Copyright © 2016 Almas Adilbek. All rights reserved.
//

#import "SimpleDisclosureCell.h"
@class CarwashBook;

@interface BookAdminCell : SimpleDisclosureCell

- (void)setCarwashBook: (CarwashBook *)carwashBook;
+ (CGFloat)cellHeight: (CarwashBook *)book;

@end
