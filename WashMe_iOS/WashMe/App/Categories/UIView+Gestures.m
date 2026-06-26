//
//  UIView+Gestures.m
//  Zenge
//
//  Created by Almas Adilbek on 12/5/15.
//  Copyright © 2015 Zenge. All rights reserved.
//

#import "UIView+Gestures.h"

@implementation UIView (Gestures)

- (void)tapGesture:(id)target selector:(SEL)sel {
    [self tapGesture:target selector:sel tapsRequired:1];
}

- (void)tapGesture:(id)target selector:(SEL)sel tapsRequired:(NSUInteger)numberOfTaps
{
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:target action:sel];
    tapGes.numberOfTapsRequired = numberOfTaps;
    [self addGestureRecognizer:tapGes];
}

- (void)addSwipeGesture:(UISwipeGestureRecognizerDirection)direction target:(id)target selector:(SEL)_selector {
    UISwipeGestureRecognizer *ges1 = [[UISwipeGestureRecognizer alloc] initWithTarget:target action:_selector];
    ges1.direction = direction;
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:ges1];
}


@end
