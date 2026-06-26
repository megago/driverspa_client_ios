//
//  TitleValueView.h
//  Puzzle
//
//  Created by Almas Adilbek on 6/20/14.
//  Copyright (c) 2014 Crystal Spring. All rights reserved.
//



@interface TitleValueView : UIView

-(id)initWithTitle:(NSString *)title value:(NSString *)value width:(CGFloat)width;
- (void)setValue:(NSString *)value;
- (NSString *)value;

@end
