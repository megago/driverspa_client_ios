//
// Created by Almas Adilbek on 9/7/14.
// Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface InputTextField : UIView {

}

@property(nonatomic, strong) UITextField *textField;

-(id)initWithWidth:(CGFloat)width;
-(id)initWithWidth:(CGFloat)width height:(CGFloat)height;

@property(nonatomic, strong) id userData;

-(NSString *)value;

-(void)setValue:(NSString *)value;
-(void)setPlaceholder:(NSString *)placeholder;
-(void)enabled:(BOOL)enabled;

-(void)setRightText:(NSString *)text;

-(void)focus;
-(void)blur;

@end