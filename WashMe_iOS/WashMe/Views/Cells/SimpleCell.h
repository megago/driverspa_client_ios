//
//  SimpleCell.h
//  WashMe
//
//  Created by Almas Adilbek on 10/15/14.
//  Copyright (c) 2014 Almas Adilbek. All rights reserved.
//



#import "SimpleBaseCell.h"

@interface SimpleCell : SimpleBaseCell

- (void)setTitle:(NSString *)title;
+ (CGFloat)cellHeight:(NSString *)title;


@end
