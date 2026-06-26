//
//  SearchFilterViewController.h
//  WashMe
//
//  Created by Almas Adilbek on 3/30/16.
//  Copyright (c) 2016 Almas Adilbek. All rights reserved.
//



#import "ScrollViewController.h"

@class FilterManager;

@protocol SearchFilterViewControllerDelegate<NSObject>
- (void)SearchFilterViewControllerSearchWithFilter:(FilterManager *)filterManager;
@end

@interface SearchFilterViewController : ScrollViewController

@property(nonatomic, weak) id <SearchFilterViewControllerDelegate> delegate;
@property(nonatomic, strong) FilterManager *filterManager;

@end
