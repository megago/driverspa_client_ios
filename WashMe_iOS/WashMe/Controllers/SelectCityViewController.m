//
//  SelectCityViewController.m
//  WashMe
//
//  Created by Ivan Korotkikh on 23.10.16.
//  Copyright © 2016 Almas Adilbek. All rights reserved.
//

#import "SelectCityViewController.h"
#import "City.h"
#import "RowButtonView.h"
#import "RowButtonCheckmarkView.h"
#import "UIViewController+Ext.h"
#import "UILabel+Components.h"
#import "UIView+Ext.h"
#import "UserSettings.h"
#import "LocationHelper.h"

@interface SelectCityViewController ()

@end

@implementation SelectCityViewController {
    RowButtonCheckmarkView *selectedRow;
}

-(id)init {
    self = [super init];
    if(self) {
        [self initVars];
    }
    return self;
}

-(void)initVars {}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self subscribeForNotifications];
    [self configUI];
    [self buildUI];
}

- (void)requestMylocationCity {
    [[LocationHelper sharedInstance] requestLocation:^(CLLocation *currentLocation) {
        [UserSettings defineCurrentCity];
    } failed:^(INTULocationStatus status) {
        [UserSettings defineCurrentCity];
    }];
}

- (void)cityInfoTapped:(RowButtonView *)view
{
//    RowButtonCheckmarkView *row = (RowButtonCheckmarkView *)view;
//    if([row isChecked]) {
//        [[CreateCarwashDraft sharedInstance] addAdditionalInfo:row.userData];
//    } else {
//        [[CreateCarwashDraft sharedInstance] removeAdditionalInfo:row.userData];
//    }
    
    [self.delegate changeCurrentCity:view.userData];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Notifications

- (void) subscribeForNotifications
{
    [self unsubscribeFromNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(cityChangedNotification:)
                                                 name:kNotificationCityChanged
                                               object:nil];
    
    
}

- (void) unsubscribeFromNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name: kNotificationCityChanged
                                                  object:nil];
}

- (void)cityChangedNotification:(NSNotification *)notification {
    City *city = [notification object];
    if(city) {
        [self.delegate changeCurrentCity:city];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark -

- (void)buildUI
{
    CGFloat nextY = 10;
    
    RowButtonView *myLocationRow = [[RowButtonView alloc] initWithIcon:@"icon-favorite" title:@"Мое местоположение" target:self selector:@selector(requestMylocationCity)];
    myLocationRow.y = nextY;
    [sv addSubview:myLocationRow];
    nextY = myLocationRow.bottom;
    
    UIView *citiesTitleView = [UIView headerViewWithTitle:@"Города"];
    citiesTitleView.y = myLocationRow.bottom;
    [sv addSubview:citiesTitleView];
    nextY = citiesTitleView.bottom;

    __weak SelectCityViewController *wSelf = self;
    for(City *city in _cities)
    {
        RowButtonCheckmarkView *row = [[RowButtonCheckmarkView alloc] initWithTitle:city.title onTap:^(RowButtonView *rowButtonView) {
            [wSelf cityInfoTapped:rowButtonView];
        }];
        row.userData = city;
        row.centerX = sv.centerX;
        row.y = nextY;
        [sv addSubview:row];
        
        // Check if already set
        if([UserSettings currentCity].code == city.code) {
            row.isChecked = YES;
            selectedRow = row;
        }
        
        nextY = row.bottom;
    }

    [sv setContentSizeHeight:nextY + 10];
}

-(void)configUI
{
    [super configUI];
    [self setBlueBackground];
    [self setBackButtonInNavigation];
    [self setNavigationTitle:@"Выбор города"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc {
    [self unsubscribeFromNotifications];
}

@end
