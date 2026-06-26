//
//  UIView+Gestures.h
//  Zenge
//
//  Created by Almas Adilbek on 12/5/15.
//  Copyright © 2015 Zenge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Gestures)

- (void)tapGesture:(id)target selector:(SEL)sel;
- (void)tapGesture:(id)target selector:(SEL)sel tapsRequired:(NSUInteger)numberOfTaps;

- (void)addSwipeGesture:(UISwipeGestureRecognizerDirection)direction target:(id)target selector:(SEL)_selector;

@end
