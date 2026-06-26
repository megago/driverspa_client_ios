//
//  SimpleDetailsCell.h
//  WashMe
//
//  Created by Almas Adilbek on 11/25/14.
//  Copyright (c) 2014 Almas Adilbek. All rights reserved.
//



#import "SimpleCell.h"

@interface SimpleDetailsCell : SimpleBaseCell

+ (CGFloat)cellHeight:(NSString *)title details:(NSString *)details;

- (void)setTitle:(NSString *)title details:(NSString *)detailsText;

@end
