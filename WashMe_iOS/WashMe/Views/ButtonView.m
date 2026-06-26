//
// Created by Almas Adilbek on 9/27/14.
// Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

#import "ButtonView.h"

#define kFadeInOutDuration 0.5

@implementation ButtonView {
    SEL onTapSelector;
}

- (id)initWithTarget:(id)target_ selector:(SEL)tapSelector
{
    self = [super initWithFrame:CGRectMake(0, 0, 1, 1)];
    if(self) {

        self.target = target_;
        onTapSelector = tapSelector;

        self.selectionAlpha = 0.2;

        self.selectionView = [[UIView alloc] initWithFrame:self.bounds];
        _selectionView.backgroundColor = [UIColor whiteColor];
        _selectionView.alpha = 0;
        [self addSubview:_selectionView];

        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button addTarget:self action:@selector(tapped) forControlEvents:UIControlEventTouchUpInside];
        [_button addTarget:self action:@selector(tappedUpOutside) forControlEvents:UIControlEventTouchUpOutside];
        [_button addTarget:self action:@selector(touchDown) forControlEvents:UIControlEventTouchDown];
        [_button addTarget:self action:@selector(tappedUpOutside) forControlEvents:UIControlEventTouchCancel];
        [self addSubview:_button];
    }
    return self;
}

#pragma mark -
#pragma mark Override

-(void)setWidth:(CGFloat)width {
    CGRect f = self.frame;
    f.size.width = width;
    self.frame = f;

    _button.frame = self.bounds;
    _selectionView.frame = self.bounds;
}

-(void)setHeight:(CGFloat)height {
    CGRect f = self.frame;
    f.size.height = height;
    self.frame = f;

    _button.frame = self.bounds;
    _selectionView.frame = self.bounds;
}

#pragma mark -
#pragma mark Actions

- (void)touchDown {
    [self fadeIn:nil];
}

- (void)tappedUpOutside {
    [self fadeOut:nil];
}

- (void)tapped {
    if(_selectionView.alpha == 0) {
        [self fadeIn:^(BOOL finished) {
            [self fadeOut:nil];
        }];
    } else {
        [self fadeOut:nil];
    }

    if(onTapSelector) {
        [self.target performSelector:onTapSelector];
    }
}

-(void)fadeIn:(void (^)(BOOL finished))completion {
    [UIView animateWithDuration:kFadeInOutDuration animations:^{
        _selectionView.alpha = _selectionAlpha;
    } completion:completion];
}

-(void)fadeOut:(void (^)(BOOL finished))completion {
    [UIView animateWithDuration:kFadeInOutDuration animations:^{
        _selectionView.alpha = 0;
    } completion:completion];
}


@end