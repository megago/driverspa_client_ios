//
//  TitleInputFieldView.h
//  WashMe
//
//  Created by Almas Adilbek on 10/25/14.
//  Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

#import "InputTextField.h"

@interface TitleInputFieldView : UIView

@property(nonatomic, strong) InputTextField *inputTextField;

- (id)initWithTitle:(NSString *)title fieldPlaceholder:(NSString *)placeholder;
- (id)initWithTitle:(NSString *)title fieldPlaceholder:(NSString *)placeholder width:(CGFloat)width;

@property(nonatomic, strong) id userData;

-(NSString *)value;

-(void)setValue:(NSString *)value;
-(void)enabled:(BOOL)enabled;
- (void)setTitleFont:(UIFont *)font;

-(void)setRightText:(NSString *)text;

-(void)focus;

@end
