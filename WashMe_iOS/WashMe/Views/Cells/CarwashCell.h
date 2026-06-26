//
//  CarwashCell.h
//  WashMe
//
//  Created by Almas Adilbek on 9/15/14.
//  Copyright (c) 2014 Almas Adilbek. All rights reserved.
//



@class Carwash;

@interface CarwashCell : UITableViewCell

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;
- (void)setCarwash:(Carwash *)carwash;

+ (CGFloat)cellHeightWithCarwashName:(NSString *)name andAddress:(NSString *)address;

@end
