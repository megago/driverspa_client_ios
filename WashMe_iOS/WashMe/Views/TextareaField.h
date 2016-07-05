//
// Created by Almas Adilbek on 10/1/14.
// Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LPlaceholderTextView.h"

@interface TextareaField : UIView

@property(nonatomic, strong) LPlaceholderTextView *textarea;

- (id)initWithWidth:(CGFloat)width height:(CGFloat)height;

-(NSString *)value;
- (void)focus;

@end