//
//  ScrollViewController.h
//  Zenge
//
//  Created by Almas Adilbek on 1/12/16.
//  Copyright (c) 2016 Zenge. All rights reserved.
//



#import "ScrollViewContentView.h"

@interface ScrollViewController : UIViewController

@property(nonatomic, strong) UIScrollView *contentScrollView;
@property(nonatomic, strong) ScrollViewContentView *contentView;

@property(nonatomic, strong) NSLayoutConstraint *contentScrollViewTopConstraint;
@property(nonatomic, strong) NSLayoutConstraint *contentScrollViewBottomConstraint;

- (void)configUI;

@end
