//
//  CarwashesBaseViewController.h
//  WashMe
//
//  Created by Almas Adilbek on 4/13/16.
//  Copyright (c) 2016 Almas Adilbek. All rights reserved.
//



#import "SearchFilterViewController.h"

@class FilterManager;

@interface CarwashesBaseViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) UITableView *list;

@property(nonatomic, strong) NSMutableArray *carwashes;
@property(nonatomic, assign) NSInteger page;
@property(nonatomic, strong) FilterManager *filterManager;
@property(nonatomic, assign) BOOL allowInfiniteLoading;

- (void)initVars;
- (void)configUI;
- (void)loadCarwashes:(BOOL)loadMore;
- (void)tapNavigationMenuButton;
- (void)setTabBarVisible:(BOOL)visible animated:(BOOL)animated completion:(void (^)(BOOL))completion;
- (void)dealloc;

@end
