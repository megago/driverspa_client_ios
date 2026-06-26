//
// Created by Almas Adilbek on 9/13/14.
// Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

#import "TabView.h"
#import "UIImage+Extensions.h"
#import "ViewFrameAccessor.h"
#import "UIFont+Custom.h"


@implementation TabView {
    UIButton *button;
}

-(id)initWithTitle:(NSString *)title width:(CGFloat)width height:(CGFloat)height target:(id)target selector:(SEL)_selector
{
    self = [super initWithFrame:CGRectMake(0, 0, width, height)];
    if(self) {
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = self.bounds;
        [button addTarget:target action:_selector forControlEvents:UIControlEventTouchUpInside];
        [button.titleLabel setFont:[UIFont robotoRegular:16]];
        [button setTitle:title forState:UIControlStateNormal];

        UIView *highlightView = [[UIView alloc] initWithFrame:button.bounds];
        highlightView.backgroundColor = [UIColor whiteColor];
        highlightView.alpha = 0.2;
        highlightView.opaque = NO;

        [button setBackgroundImage:[UIImage imageWithView:highlightView] forState:UIControlStateHighlighted];
        [button setBackgroundImage:[UIImage imageWithView:highlightView] forState:UIControlStateSelected];
        [self addSubview:button];
    }
    return self;
}

- (void)selected:(BOOL)selected {
    [button setSelected:selected];
}

-(void)setIndex:(NSInteger)index {
    _index = index;
    button.tag = index;
}


@end