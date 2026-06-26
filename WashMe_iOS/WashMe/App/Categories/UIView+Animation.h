//
// Created by Almas Adilbek on 8/3/14.
// Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^Completed)(BOOL finished);

@interface UIView (Animation)


- (void)fadeBottomTop:(Completed)completion;
- (void)fadeBottomTopToAlpha:(CGFloat)alpha completed:(Completed)completion;
- (void)fadeBottomTop:(Completed)completion delay:(float)delay;
- (void)fadeIn:(Completed)completion;
- (void)fadeInToAlpha:(CGFloat)alpha completed:(Completed)completion;
- (void)fadeIn:(Completed)completion delay:(float)delay;
- (void)fadeIn:(Completed)completion delay:(float)delay duration:(float)duration;

- (void)bounce:(Completed)completion;
- (void)bounceFast:(Completed)completion delay:(CGFloat)delay;

@end