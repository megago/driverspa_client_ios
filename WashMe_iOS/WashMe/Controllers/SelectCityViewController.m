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

    // Guards the async GPS request so the loading HUD can never stick and freeze
    // the UI (its mask blocks all touches). Only one request runs at a time, and
    // whichever of the callback / timeout fires first wins.
    BOOL locationRequestInProgress;
}

// Hard cap on how long the GPS spinner may stay up before we give up.
#define kLocationRequestTimeout 6.0

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

#pragma mark -
#pragma mark GPS ("My location")

- (void)requestMylocationCity {
    if(locationRequestInProgress) {
        return;
    }
    locationRequestInProgress = YES;

    [SVProgressHUD showWithStatus:@"Определение местоположения"];

    // Safety net: never let the masked HUD outlive the request. If neither callback
    // arrives in time we bail out ourselves instead of freezing the screen.
    [self performSelector:@selector(locationRequestTimedOut) withObject:nil afterDelay:kLocationRequestTimeout];

    __weak SelectCityViewController *wSelf = self;
    [[LocationHelper sharedInstance] requestLocation:^(CLLocation *currentLocation) {
        [wSelf handleLocation:currentLocation];
    } failed:^(INTULocationStatus status) {
        [wSelf handleLocation:nil];
    }];
}

- (void)locationRequestTimedOut {
    if(!locationRequestInProgress) {
        return;
    }
    [self handleLocation:nil];
}

// Distance-aware GPS selection, mirroring Android's onLocationResponseReceived():
// pick the nearest city, use it when within kMaxCityDistanceKm, otherwise ask the
// user to choose manually.
- (void)handleLocation:(CLLocation *)location {
    // Whichever fires first (real callback or timeout) wins; ignore the rest so we
    // never dismiss/re-run twice.
    if(!locationRequestInProgress) {
        return;
    }
    locationRequestInProgress = NO;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(locationRequestTimedOut) object:nil];

    [SVProgressHUD dismiss];

    CGFloat distanceMeters = CGFLOAT_MAX;
    City *nearest = location ? [UserSettings nearestCityToCoordinate:location.coordinate distanceMeters:&distanceMeters] : nil;

    if(!nearest) {
        [self showAlertMessage:@"Не могу определить местоположение"];
        [self setMyLocationChecked:NO title:nil];
        [UserSettings setCityFoundByGPS:NO];
        return;
    }

    CGFloat distanceKm = distanceMeters / 1000.0;
    if(distanceKm <= kMaxCityDistanceKm) {
        [self uncheckAllCityRows];
        [self setMyLocationChecked:YES title:nearest.title];
        [self applyCity:nearest foundByGPS:YES];
    } else {
        NSString *msg = [NSString stringWithFormat:@"Вы находитесь в %ld км от ближайшего города (%@). Выберите город вручную.", (long)round(distanceKm), nearest.title];
        [self showAlertMessage:msg];
        [self setMyLocationChecked:NO title:nil];
        [UserSettings setCityFoundByGPS:NO];
    }
}

#pragma mark -
#pragma mark Selection

- (void)cityInfoTapped:(RowButtonView *)view
{
    City *city = (City *)view.userData;

    // Manual choice: check this row, clear the GPS "my location" checkmark.
    [self uncheckAllCityRows];
    if([view isKindOfClass:[RowButtonCheckmarkView class]]) {
        RowButtonCheckmarkView *row = (RowButtonCheckmarkView *)view;
        row.isChecked = YES;
        selectedRow = row;
    }
    [self setMyLocationChecked:NO title:nil];

    [self applyCity:city foundByGPS:NO];
}

// Persist the chosen city and leave the screen. Apply immediately and dismiss —
// never block the UI. The global SVProgressHUD mask (Clear) intercepts all touches,
// so a stalled network save behind it would freeze every button. Persist to the
// profile in the background.
- (void)applyCity:(City *)city foundByGPS:(BOOL)byGPS {
    [UserSettings setCurrentCity:city];
    [UserSettings setCityFoundByGPS:byGPS];
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

- (void)uncheckAllCityRows {
    for(RowButtonCheckmarkView *row in cityRows) {
        row.isChecked = NO;
    }
    selectedRow = nil;
}

- (void)setMyLocationChecked:(BOOL)checked title:(NSString *)title {
    myLocationCheckmark.hidden = !checked;
    myLocationTitle.text = title.length ? title : @"Мое местоположение";
}

- (void)showAlertMessage:(NSString *)message {
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    [ac addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:ac animated:YES completion:nil];
}

// Currently effective city, matching the original checkmark resolution: admins and
// unauthorized users read the locally stored city, regular users read their profile.
- (City *)effectiveCurrentCity {
    if([User isAuthorized] && ![UserSettings isAdmin]) {
        City *profileCity = [User currentUser].city;
        if(profileCity) {
            return profileCity;
        }
    }
    return [UserSettings currentCity];
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
    cityRows = [NSMutableArray array];

    CGFloat nextY = 10;

    myLocationRow = [self buildMyLocationRow];
    myLocationRow.centerX = sv.centerX;
    myLocationRow.y = nextY;
    [sv addSubview:myLocationRow];
    nextY = myLocationRow.bottom;

    UIView *citiesTitleView = [UIView headerViewWithTitle:@"Города"];
    citiesTitleView.y = nextY;
    [sv addSubview:citiesTitleView];
    nextY = citiesTitleView.bottom;

    City *current = [self effectiveCurrentCity];
    BOOL foundByGPS = [UserSettings isCityFoundByGPS];

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
        [cityRows addObject:row];

        // A city row is checked only when the current city was picked manually
        // (not resolved by GPS — in that case the "my location" row is checked).
        if(!foundByGPS && current && [current.code isEqual:city.code]) {
            row.isChecked = YES;
            selectedRow = row;
        }
        nextY = row.bottom;
    }

    // Restore the "my location" checkmark when the city came from GPS.
    if(foundByGPS && current) {
        [self setMyLocationChecked:YES title:current.title];
    } else {
        [self setMyLocationChecked:NO title:nil];
    }

    [sv setContentSizeHeight:nextY + 10];
}

// Custom GPS row: icon + title + "определить город по GPS" subtitle + a checkmark
// on the right, matching the Android header_city_choose layout.
- (UIView *)buildMyLocationRow {
    CGFloat width = kContentWidth;
    CGFloat height = 58;
    UIView *row = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(requestMylocationCity)];
    [row addGestureRecognizer:tap];

    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 1)];
    topLine.backgroundColor = [UIColor whiteColor];
    topLine.alpha = 0.1;
    [row addSubview:topLine];

    UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageWithName:@"ic_gps_24dp"]];
    icon.center = CGPointMake(22, height / 2);
    [row addSubview:icon];

    myLocationTitle = [[UILabel alloc] initWithFrame:CGRectMake(45, 10, width - 45 - 40, 20)];
    myLocationTitle.backgroundColor = [UIColor clearColor];
    myLocationTitle.font = [UIFont robotoBold:16];
    myLocationTitle.textColor = [UIColor whiteColor];
    myLocationTitle.lineBreakMode = NSLineBreakByTruncatingTail;
    myLocationTitle.text = @"Мое местоположение";
    [row addSubview:myLocationTitle];

    UILabel *subtitle = [[UILabel alloc] initWithFrame:CGRectMake(45, myLocationTitle.bottom + 1, width - 45 - 40, 16)];
    subtitle.backgroundColor = [UIColor clearColor];
    subtitle.font = [UIFont robotoRegular:12];
    subtitle.textColor = [UIColor colorWithRed:0.62 green:0.80 blue:1.0 alpha:1.0];
    subtitle.text = @"Определить город по GPS";
    [row addSubview:subtitle];

    myLocationCheckmark = [[UIImageView alloc] initWithImage:[UIImage imageWithName:@"icon-checkmark"]];
    myLocationCheckmark.x = width - myLocationCheckmark.width - kRowButtonViewSidePadding;
    myLocationCheckmark.centerY = height / 2;
    myLocationCheckmark.hidden = YES;
    [row addSubview:myLocationCheckmark];

    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, height - 1, width, 1)];
    bottomLine.backgroundColor = [UIColor whiteColor];
    bottomLine.alpha = 0.1;
    [row addSubview:bottomLine];

    return row;
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
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(locationRequestTimedOut) object:nil];
    [self unsubscribeFromNotifications];
}

@end
