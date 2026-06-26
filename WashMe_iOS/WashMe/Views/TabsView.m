//
// Created by Almas Adilbek on 9/7/14.
// Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

#import "TabsView.h"
#import "TabView.h"
#import "ViewFrameAccessor.h"

@implementation TabsView {
    NSUInteger tabsCount;
}

-(id)initWithTitle:(NSArray *)titles height:(CGFloat)height
{
    self = [super initWithFrame:CGRectMake(0, 0, [ASize screenWidth], height)];
    if(self)
    {
        tabsCount = titles.count;
        CGFloat w = [ASize screenWidth] / titles.count;

        CGFloat rightX = 0;
        for (NSUInteger i = 0; i < titles.count; i++) {
            TabView *tab = [[TabView alloc] initWithTitle:titles[i] width:w height:height target:self selector:@selector(tabTapped:)];
            tab.index = i;
            tab.x = rightX;
            rightX = tab.right;
            [self addSubview:tab];
        }
    }
    return self;
}

- (void)tabTapped:(UIButton *)tabTapped {
    for (id subview in self.subviews) {
        if([subview isKindOfClass:[TabView class]]) {
            [(TabView *)subview selected:NO];
        }
    }
    [tabTapped setSelected:YES];

    [self.delegate tabsViewTabTappedWithIndex:tabTapped.tag];
}

@end