//
//  ScrollViewController.m
//  Zenge
//
//  Created by Almas Adilbek on 1/12/16.
//  Copyright (c) 2016 Zenge. All rights reserved.
//

#import <PureLayout/ALView+PureLayout.h>
#import "ScrollViewController.h"
#import "UIView+ConcisePureLayout.h"
#import "NSArray+ConcisePureLayout.h"
#import "ScrollViewContentView.h"

@interface ScrollViewController ()
@end

@implementation ScrollViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configUI];
}

#pragma mark -

-(void)configUI
{
    self.view.backgroundColor = [UIColor whiteColor];

    self.contentScrollView = [UIScrollView newAutoLayoutView];
    _contentScrollView.showsHorizontalScrollIndicator = NO;
    _contentScrollView.showsVerticalScrollIndicator = NO;
    _contentScrollView.alwaysBounceVertical = YES;
    [self.view addSubview:_contentScrollView];
    NSArray *constraints = [_contentScrollView autoPinEdgesToSuperviewEdges];
    self.contentScrollViewTopConstraint = [constraints topConstraint];
    self.contentScrollViewBottomConstraint = [constraints bottomConstraint];

    self.contentView = [ScrollViewContentView newAutoLayoutView];
    [_contentScrollView addSubview:_contentView];
    [_contentView autoPinEdgesToSuperviewEdges];
    [_contentView aa_sameWidthWith:self.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc {

}

@end
