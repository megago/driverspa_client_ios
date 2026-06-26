//
//  AAButton.m
//  AstanaKzNationalControl
//
//  Created by Almas Adilbek on 5/3/13.
//  Copyright (c) 2013 Astana.kz. All rights reserved.
//

#import "AAButton.h"

@interface AAButton()
-(UIImage *)imageWithNameExt:(NSString *)imageName;

-(void)tapped:(id)sender;
@end

@implementation AAButton {
    AAButtonOnClick onClickBlock;
}

@synthesize button;

- (id)initWithWidth:(float)width onTap:(AAButtonOnClick)block {
    return [self initWithFrame:CGRectMake(0, 0, width, 40) onTap:block];
}

- (id)initWithFrame:(CGRect)frame onTap:(AAButtonOnClick)block
{
    self = [super initWithFrame:frame];
    if (self) {
        onClickBlock = block;
        
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = self.bounds;
        [button addTarget:self action:@selector(tapped:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];

        button.titleLabel.numberOfLines = 0;
        button.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        button.titleLabel.textAlignment = NSTextAlignmentCenter;

        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
        
    }
    return self;
}

-(void)setImageWithPattern:(NSString *)patternName forState:(UIControlState)state {
    [self setImageWithPattern:patternName leftWidth:15 topHeight:15 forState:state];
}

-(void)setImageWithPattern:(NSString *)patternName leftWidth:(int)leftWidth topHeight:(int)topHeight forState:(UIControlState)state {
    [button setBackgroundImage:[[self imageWithNameExt:patternName] stretchableImageWithLeftCapWidth:leftWidth topCapHeight:topHeight] forState:state];
}

-(void)setTitle:(NSString *)title forState:(UIControlState)state {
    [button setTitle:title forState:state];
}

-(void)setTitleColor:(UIColor *)color forState:(UIControlState)state {
    [button setTitleColor:color forState:state];
}

-(void)setTitleFont:(UIFont *)font {
    button.titleLabel.font = font;
}

-(void)setTitleShadowColor:(UIColor *)color forState:(UIControlState)state {
    [button setTitleShadowColor:color forState:state];
}

-(void)setTitleShadowOffset:(CGSize)offset {
    button.titleLabel.shadowOffset = offset;
}

-(void)setHeight:(CGFloat)height {
    CGRect f = self.frame;
    f.size.height = height;
    self.frame = f;

    button.height = height;
}

#pragma mark -
#pragma mark Action

-(void)tapped:(id)sender {
    onClickBlock(self);
}

#pragma mark -
#pragma mark Helper

-(UIImage *)imageWithNameExt:(NSString *)imageName {
    return [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imageName ofType:nil]];
}


@end
