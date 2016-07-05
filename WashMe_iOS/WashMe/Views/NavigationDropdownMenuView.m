//
//  NavigationDropdownMenuView.m
//  WashMe
//
//  Created by Almas Adilbek on 2/21/15.
//  Copyright (c) 2015 Almas Adilbek. All rights reserved.
//

#import <REMenu/REMenu.h>
#import <INTULocationManager/INTULocationManager.h>
#import "NavigationDropdownMenuView.h"
#import "Cache.h"
#import "CarwashRefs.h"
#import "City.h"
#import "UserSettings.h"

@implementation NavigationDropdownMenuView {
    UILabel *titleLabel;
    UIImageView *arrow;
    NSArray *cities;
    UIControl *control;
}

- (id)init {
    self = [super initWithFrame:CGRectMake(0, 20, 1, 44)];
    if(self) {

        // Current city
        City *currentCity = [UserSettings currentCity];

        titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.textColor = [UIColor whiteColor];
        [self addSubview:titleLabel];

        arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-menu-arrow.png"]];
        arrow.alpha = 0.8;
        [self addSubview:arrow];

        control = [[UIControl alloc] initWithFrame:CGRectZero];
        control.height = self.height;
        [control addTarget:self action:@selector(tap) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:control];
        
        [self setTitle:(currentCity ? currentCity.title : @"Выберите город")];
    }
    return self;
}

- (void)setTitle:(NSString *)title
{
    titleLabel.text = title;
    [titleLabel sizeToFit];
    titleLabel.centerY = (CGFloat) (self.height * 0.5);

    arrow.x = titleLabel.right + 7;
    arrow.centerY = self.middleY + 1;
    
    control.width = titleLabel.width + 10;
    self.bounds = control.bounds;

    self.width = arrow.right;
    self.centerX = (CGFloat) ([ASize screenWidth] * 0.5);
}

- (void)addInView:(UIView *)view {
    [view addSubview:self];
}

#pragma mark -
#pragma mark Actions

- (void)tap
{
    if(!self.superview) return;

    if(!_menu)
    {
        NSMutableArray * menuItems = [NSMutableArray array];

        REMenuItem *nearbyItem = [[REMenuItem alloc] initWithTitle:@"Ближайшие мойки"
                                                          subtitle:@"ближайшие мойки вокруг Вас"
                                                             image:nil
                                                  highlightedImage:nil
                                                            action:^(REMenuItem *item) {
                                                                [self nearbyTapped:item];
                                                            }];
        [menuItems addObject:nearbyItem];

        [Cache carwashRefs:^(id obj) {

            CarwashRefs *refs = (CarwashRefs *)obj;
            cities = refs.cities;

            NSInteger index = 0;
            for(City *city in cities)
            {
                REMenuItem *cityItem = [[REMenuItem alloc] initWithTitle:city.title
                                                                  subtitle:[NSString stringWithFormat:@"мойки города %@", city.title]
                                                                     image:nil
                                                          highlightedImage:nil
                                                                    action:^(REMenuItem *item) {
                                                                        [self cityTapped:item];
                                                                    }];
                cityItem.tag = index++;
                [menuItems addObject:cityItem];
            }

            self.menu = [[REMenu alloc] initWithItems:menuItems];

            // Customization
            _menu.backgroundColor = [UIColor fromRGB:0x26558D];
            _menu.separatorColor = [UIColor fromRGB:0x204878];
            _menu.separatorHeight = 1;
            _menu.textColor = [UIColor whiteColor];
            _menu.subtitleFont = [UIFont systemFontOfSize:12];
            _menu.font = [UIFont boldSystemFontOfSize:16];
            _menu.subtitleTextColor = [UIColor whiteColor];
            _menu.subtitleTextShadowOffset = CGSizeZero;
            _menu.subtitleTextOffset = CGSizeMake(0, -5);
            _menu.borderColor = [UIColor clearColor];
            _menu.highlightedBackgroundColor = [UIColor fromRGB:0x23456e];
            _menu.subtitleHighlightedTextShadowOffset = CGSizeZero;
            _menu.highlightedSeparatorColor = _menu.separatorColor;
            _menu.highlightedTextColor = [UIColor whiteColor];
            _menu.subtitleHighlightedTextColor = [UIColor whiteColor];
            _menu.itemHeight = 55;

            [self openMenu];

        }];

    } else if(!_menu.isOpen && !_menu.isAnimating) {
        [self openMenu];
    } else if(_menu.isOpen && !_menu.isAnimating) {
        [_menu close];
    }
}

- (void)openMenu {
    [self.menu showFromRect:CGRectMake(0, 64, [ASize screenWidth], [ASize screenHeight]) inView:self.superview];
}

- (void)cityTapped:(REMenuItem *)item {
    City *city = cities[item.tag];
    [self setTitle:city.title];

    [self.delegate navigationDropdownMenuViewCityTapped:city];
}

- (void)nearbyTapped:(REMenuItem *)item
{
    [self setTitle:item.title];

    // Check if location is allowed
    if(![CLLocationManager locationServicesEnabled] || [CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied) {
        [UIHelper showAlertWithMessageTitle:@"Отказано в доступе Местонахождения" message:@"Чтобы снова включить, пожалуйста, перейдите в настройки и включите сервис Местонахождение для этого приложения."];
        return;
    }
    [self.delegate navigationDropdownMenuViewNearbyTapped];
}

@end
