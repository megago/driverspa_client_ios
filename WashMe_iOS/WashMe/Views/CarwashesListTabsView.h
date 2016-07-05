//
//  CarwashesListTabsView.h
//  WashMe
//
//  Created by Almas Adilbek on 9/15/14.
//  Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

@protocol CarwashTypeTabsViewDelegate;

enum CarwashesListType {
    CarwashListFavorites = 0,
    CarwashListNearest = 1,
    CarwashListFree = 2
};

@interface CarwashesListTabsView : UIView

@property(nonatomic, assign) NSUInteger selectedTabIndex;
@property(nonatomic, weak) id <CarwashTypeTabsViewDelegate> delegate;

@end


@protocol CarwashTypeTabsViewDelegate<NSObject>
- (void)carwashTypeTabsViewTabSelected:(NSUInteger)tabIndex;
@end