//
//  AAButton.h
//  AstanaKzNationalControl
//
//  Created by Almas Adilbek on 5/3/13.
//  Copyright (c) 2013 Astana.kz. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^AAButtonOnClick)(UIView *_self);

@interface AAButton : UIView {
    UIButton *button;
}

@property (nonatomic, strong) UIButton *button;

- (id)initWithWidth:(float)width onTap:(AAButtonOnClick)block;
- (id)initWithFrame:(CGRect)frame onTap:(AAButtonOnClick)block;

- (void)setImageWithPattern:(NSString *)patternName forState:(UIControlState)state;
- (void)setImageWithPattern:(NSString *)patternName leftWidth:(int)leftWidth topHeight:(int)topHeight forState:(UIControlState)state;
- (void)setTitle:(NSString *)title forState:(UIControlState)state;
- (void)setTitleFont:(UIFont *)font;
- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state;
- (void)setTitleShadowColor:(UIColor *)color forState:(UIControlState)state;
- (void)setTitleShadowOffset:(CGSize)offset;

@end
