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
#import "User.h"
#import "CarwashComplex.h"
#import "UIViewController+NavigationBar.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "UserApi.h"
#import "NotificationsHelper.h"

// Nearest city must be within this distance (km) for GPS auto-selection, mirroring
// the Android CityChooseActivity.MAX_CITY_DISTANCE_KM behaviour.
#define kMaxCityDistanceKm 100

@interface SelectCityViewController ()

@end

@implementation SelectCityViewController {
    RowButtonCheckmarkView *selectedRow;

    // "My location" (GPS) row and its subviews we mutate at runtime.
    UIView *myLocationRow;
    UILabel *myLocationTitle;
    UIImageView *myLocationCheckmark;

    NSMutableArray<RowButtonCheckmarkView *> *cityRows;
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
    
    City *city = (City *)view.userData;

    // Apply the city immediately and dismiss — never block the UI. The global
    // SVProgressHUD mask (Clear) intercepts all touches, so a stalled network save
    // behind it would freeze every button. Persist to the profile in the background.
    [UserSettings setCurrentCity:city];
    [self.delegate changeCurrentCity:city];

    if (_isModal) {
        [UserApi updateProfileWithName:[User currentUser].firstName lastname:nil cars:[User currentUser].cars city:city success:^(id response) {
            User *user = [User instanceFromDictionary:response];
            [User setAuthorizedUserData:response withMobile:user.mobile];
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationUserProfileUpdated object:nil];
        } failure:nil];
        [self dismissViewController];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
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
    
    RowButtonView *myLocationRow = [[RowButtonView alloc] initWithIcon:@"ic_gps_24dp" title:@"Мое местоположение" target:self selector:@selector(requestMylocationCity)];
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
        if ([User isAuthorized]){
            if ([UserSettings isAdmin]){
                NSLog(@"%@ - %@",[UserSettings currentCity].code, city.code);
                if ([[UserSettings currentCity].code isEqual:city.code]){
                    row.isChecked = YES;
                    selectedRow = row;
                }
            } else {
                if([[User currentUser].city.code isEqual:city.code]) {
                    row.isChecked = YES;
                    selectedRow = row;
                }
            }
        }
        nextY = row.bottom;
    }

    [sv setContentSizeHeight:nextY + 10];
}

-(void)configUI
{
    [super configUI];
    [self setBlueBackground];
    [self setNavigationTitle:@"Выбор города"];
    if (_isModal){
        [self setNavigationBarTransparent];
        [self setNavigationCloseAtLeft:NO];
    } else {
        [self setBackButtonInNavigation];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc {
    [self unsubscribeFromNotifications];
}

@end
