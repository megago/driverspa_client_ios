//
// Created by Almas Adilbek on 8/3/14.
// Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

#import "UIView+Animation.h"
#import "NSObject+PWObject.h"

#define kFadeBottomTopSpeed 0.5
#define kFadeInSpeed 0.5

@implementation UIView (Animation)

- (void)fadeBottomTop:(Completed)completion
{
    [self fadeBottomTopToAlpha:1 completed:completion];
}

- (void)fadeBottomTopToAlpha:(CGFloat)alpha completed:(Completed)completion {
    self.alpha = 0;
    CGFloat y = self.y;
    self.y += 20;
    [UIView animateWithDuration:kFadeBottomTopSpeed animations:^{
        self.y = y;
        self.alpha = alpha;
    } completion:completion];
}


-(void)fadeBottomTop:(Completed)completion delay:(float)delay
{
    self.alpha = 0;
    CGFloat y = self.y;
    self.y += 20;
    [UIView animateWithDuration:kFadeInSpeed delay:delay
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.y = y;
                         self.alpha = 1;
                     } completion:completion];
}

-(void)fadeIn:(Completed)completion
{
    [self fadeInToAlpha:1 completed:completion];
}

- (void)fadeInToAlpha:(CGFloat)alpha completed:(Completed)completion {
    [UIView animateWithDuration:kFadeInSpeed animations:^{
        self.alpha = alpha;
    } completion:completion];
}


-(void)fadeIn:(Completed)completion delay:(float)delay
{
    [UIView animateWithDuration:kFadeInSpeed delay:delay
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.alpha = 1;
                     } completion:completion];
}

-(void)fadeIn:(Completed)completion delay:(float)delay duration:(float)duration
{
    [UIView animateWithDuration:duration delay:delay
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.alpha = 1;
                     } completion:completion];
}

- (void)bounce:(Completed)completion
{
    self.transform = CGAffineTransformMakeScale(0.5, 0.5);
    [UIView animateWithDuration:1 animations:^{
        self.transform = CGAffineTransformMakeScale(1.15, 1.15);
        self.alpha = 1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            self.transform = CGAffineTransformMakeScale(1, 1);
        } completion:completion];
    }];
}

- (void)bounceFast:(Completed)completion delay:(CGFloat)delay
{
    [self performBlock:^{
        self.transform = CGAffineTransformMakeScale(0.5, 0.5);
        [UIView animateWithDuration:0.35 animations:^{
            self.transform = CGAffineTransformMakeScale(1.15, 1.15);
            self.alpha = 1;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3 animations:^{
                self.transform = CGAffineTransformMakeScale(1, 1);
            } completion:completion];
        }];
    } afterDelay:delay];
}


@end