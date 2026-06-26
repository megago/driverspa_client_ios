//
// Created by Almas Adilbek on 9/7/14.
// Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol TabsViewDelegate;

@interface TabsView : UIView

@property(nonatomic, weak) id <TabsViewDelegate> delegate;

- (id)initWithTitle:(NSArray *)titles height:(CGFloat)height;

@end

@protocol TabsViewDelegate<NSObject>
-(void)tabsViewTabTappedWithIndex:(NSInteger)index;
@end