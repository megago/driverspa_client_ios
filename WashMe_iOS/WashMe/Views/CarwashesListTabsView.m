//
//  CarwashesListTabsView.m
//  WashMe
//
//  Created by Almas Adilbek on 9/15/14.
//  Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

#import "CarwashesListTabsView.h"
#import "UIFont+Custom.h"
#import "AAButton.h"
#import "AAButton+Styles.h"

#define kPadding 0

@implementation CarwashesListTabsView {
    NSMutableArray *tabs;
}

-(id)init
{
    self = [super initWithFrame:CGRectMake(0, 0, [ASize screenWidth], 30)];
    if(self)
    {
        _selectedTabIndex = 0;

        tabs = [[NSMutableArray alloc] init];
        NSArray *titles = @[@"Избранные", @"Ближайшие", @"Все мойки"];
//        NSArray *titles = @[@"Избранные", @"Ближайшие", @"Свободные", @"Акции"];

        __weak CarwashesListTabsView *wSelf = self;
        CGFloat buttonWidth = self.width / 3.0f;

        NSUInteger index = 0;
        for(NSString *tabTitle in titles)
        {
            AAButton *tabButton = [[AAButton alloc] initWithWidth:buttonWidth onTap:^(UIView *_self) {
                [wSelf tabTapped:(AAButton *) _self];
            }];
            tabButton.tag = index;
            tabButton.height = self.height;
            [tabButton noBorderStyleButtonWithTitle:tabTitle];
            [tabButton setTitleFont:[UIFont robotoCondensedLight:16]];
            [tabButton.button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            [self addSubview:tabButton];

            [self positionTab:tabButton withIndex:index];

            [tabs addObject:tabButton];

            ++index;
        }

        UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipped:)];
        swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
        [self addGestureRecognizer:swipeLeft];

        UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipped:)];
        swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
        [self addGestureRecognizer:swipeRight];
    }
    return self;
}

- (void)swipped:(UISwipeGestureRecognizer *)gesture
{
    NSUInteger tabIndex = _selectedTabIndex;
    if(gesture.direction == UISwipeGestureRecognizerDirectionLeft) {
        tabIndex += 1;
        if(tabIndex > tabs.count - 1) tabIndex = tabs.count - 1;
    } else {
        tabIndex = tabIndex - 1;
        if(tabIndex < 0) tabIndex = 0;
    }

    [self setSelectedTabIndex:tabIndex];
    [self.delegate carwashTypeTabsViewTabSelected:_selectedTabIndex];
}

-(void)positionTab:(AAButton *)button withIndex:(NSInteger)index
{
    if(_selectedTabIndex == 0) return;
    if(_selectedTabIndex == tabs.count - 1) return;

    CGFloat buttonX;
    if(index < _selectedTabIndex - 1) {
        buttonX = -300;
    } else if(_selectedTabIndex - 1 == index) {
        buttonX = (CGFloat) (kPadding + button.width * 0.5);
    } else if(index == _selectedTabIndex) {
        buttonX = (CGFloat) (self.width * 0.5);
    } else if(index == _selectedTabIndex + 1) {
        buttonX = (CGFloat) (self.width - button.width * 0.5 - kPadding);
    } else {
        buttonX = 1000;
    }

    [UIView animateWithDuration:0.25 animations:^{
        button.centerX = buttonX;
    } completion:^(BOOL finished) {

    }];
}

-(void)setSelectedTabIndex:(NSUInteger)selectedTabIndex
{
    _selectedTabIndex = selectedTabIndex;

    NSUInteger i = 0;
    for(AAButton *tabButton in tabs) {
        if(i == _selectedTabIndex) {
            [UIView animateWithDuration:0.25 animations:^{
                tabButton.alpha = 1;
            }];
        } else {
            [UIView animateWithDuration:0.25 animations:^{
                tabButton.alpha = 0.5;
            }];
        }
        [self positionTab:tabButton withIndex:i];
        ++i;
    }
}

-(void)tabTapped:(AAButton *)button
{
    NSUInteger index = (NSUInteger) button.tag;
    if(index != _selectedTabIndex) {
        self.selectedTabIndex = index;
        [self.delegate carwashTypeTabsViewTabSelected:_selectedTabIndex];
    }
}


@end
