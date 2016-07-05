//
// Created by Almas Adilbek on 9/27/14.
// Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kRowButtonViewSidePadding 10

@class RowButtonView;

typedef void(^RowButtonViewOnTapBlock)(id rowButtonView);

@interface RowButtonView : UIView

@property(nonatomic, strong) id userData;

- (id)initWithTitle:(NSString *)title target:(id)target selector:(SEL)_selector;
- (id)initWithIcon:(NSString *)iconName title:(NSString *)title target:(id)target selector:(SEL)_selector;
- (id)initWithWidth:(CGFloat)width icon:(NSString *)iconName title:(NSString *)title target:(id)target selector:(SEL)_selector;

- (id)initWithTitle:(NSString *)title onTap:(RowButtonViewOnTapBlock)block;
- (id)initWithIcon:(NSString *)iconName title:(NSString *)title onTap:(RowButtonViewOnTapBlock)block;
- (id)initWithWidth:(CGFloat)width icon:(NSString *)iconName title:(NSString *)title onTap:(RowButtonViewOnTapBlock)block;

- (void)removeTopLine;
- (void)setTitle:(NSString *)title;

- (void)setIcon:(NSString *)iconName;

@end