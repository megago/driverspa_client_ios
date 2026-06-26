//
// Created by Almas Adilbek on 9/27/14.
// Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ButtonView : UIView

@property(nonatomic, strong) UIView *selectionView;
@property(nonatomic, assign) CGFloat selectionAlpha;
@property(nonatomic, strong) UIButton *button;

- (id)initWithTarget:(id)target_ selector:(SEL)tapSelector;

@property(nonatomic, weak) id target;

@end