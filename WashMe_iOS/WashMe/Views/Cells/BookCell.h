//
//  BookCell.h
//  WashMe
//
//  Created by Ivan Korotkikh on 06.08.16.
//  Copyright © 2016 Almas Adilbek. All rights reserved.
//

#import "SimpleBaseCell.h"

@class CarwashBook;
@interface BookCell : SimpleBaseCell

- (void)setCarwashBook: (CarwashBook *)carwashBook;
+ (CGFloat)cellHeight: (CarwashBook *)book;

@end
