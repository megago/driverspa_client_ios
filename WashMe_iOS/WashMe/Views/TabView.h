//
// Created by Almas Adilbek on 9/13/14.
// Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TabView : UIView

@property(nonatomic, assign) NSInteger index;

- (id)initWithTitle:(NSString *)title width:(CGFloat)width height:(CGFloat)height target:(id)target selector:(SEL)_selector;

-(void)selected:(BOOL)selected;

@end