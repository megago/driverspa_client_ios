//
//  NavigationDropdownMenuView.h
//  WashMe
//
//  Created by Almas Adilbek on 2/21/15.
//  Copyright (c) 2015 Almas Adilbek. All rights reserved.
//


@class REMenu;
@class City;

@protocol NavigationDropdownMenuViewDelegate<NSObject>
- (void)navigationDropdownMenuViewNearbyTapped;
- (void)navigationDropdownMenuViewCityTapped:(City *)city;
@end

@interface NavigationDropdownMenuView : UIView

@property(nonatomic, weak) id <NavigationDropdownMenuViewDelegate> delegate;
@property(nonatomic, strong) REMenu *menu;

- (void)setTitle:(NSString *)title;
- (void)addInView:(UIView *)view;

@end
