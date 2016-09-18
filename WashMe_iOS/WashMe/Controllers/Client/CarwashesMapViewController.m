//
// Created by Almas Adilbek on 9/19/14.
// Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "CarwashesMapViewController.h"
#import "UIViewController+Ext.h"
#import "Carwash.h"
#import "LocationHelper.h"
#import "CarwashStatusView.h"
#import "CarwashViewController.h"
#import "CarwashMarkerInfoWindowView.h"
#import "ALView+PureLayout.h"
#import "CarwashApi.h"
#import "UIViewController+NoContent.h"
#import "CarwashComplex.h"
#import "UIViewController+NavigationBar.h"

@interface CarwashesMapViewController ()
@end

@implementation CarwashesMapViewController {
    GMSMapView *mapView_;
}

-(id)init {
    self = [super init];
    if(self) {
        [self initVars];
    }
    return self;
}

-(void)initVars {
    //self.annotationsEnabled = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.annotationsEnabled = YES;
    [self configUI];
    [self loadCarwaches];
}

-(void)viewWillAppear:(BOOL)animated {
    [self setTabBarVisible:YES animated:YES completion:nil];
    //[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
}

-(void)viewWillDisappear:(BOOL)animated {
    //[[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}

-(void)viewDidDisappear:(BOOL)animated {

}

-(void)viewDidAppear:(BOOL)animated {
    if(!mapView_) {

    }
}

#pragma mark -
#pragma mark ACtions

- (void)loadCarwaches {
    //[SVProgressHUD showWithStatus:@"Загрузка"];
    [Toast showHudLoading];
    [CarwashApi getComplexCarwashes:^(NSArray *response) {
        
        //[SVProgressHUD dismiss];
        self.carwashes = response;
        [self requestLocation];
        
    } failure:^(NSInteger code, NSString *message) {
        [SVProgressHUD dismiss];
    }];
}

- (void)requestLocation
{
    [[LocationHelper sharedInstance] requestLocation:^(CLLocation *currentLocation) {
        [self createAnnotations];
        
        // My location icon
        GMSMarker *myMarker = [GMSMarker markerWithPosition:CLLocationCoordinate2DMake([[LocationHelper sharedInstance] latitude], [[LocationHelper sharedInstance] longitude])];
        myMarker.icon = [UIImage imageNamed:@"mylocation-annotation"];
        myMarker.groundAnchor = CGPointMake(0.5, 1);
        myMarker.tappable = NO;
        myMarker.map = _mapView;
        
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:[[LocationHelper sharedInstance] latitude]
                                                                longitude:[[LocationHelper sharedInstance] longitude]
                                                                     zoom:13];
        [_mapView animateToCameraPosition:camera];
    } failed:^(INTULocationStatus status) {
        [self createAnnotations];
    }];
}

- (void)closeMap {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)createAnnotations
{
    NSUInteger index = 0;
    for(CarwashComplex *carwash in self.carwashes)
    {
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.position = CLLocationCoordinate2DMake(carwash.lat, carwash.lon);
        if ([carwash.status isEqualToString:@"approved"]){
            marker.icon = [UIImage imageWithName:@"carwash-annotation-online2"];
        } else {
            marker.icon = [UIImage imageWithName:@"carwash-annotation-offline"];
        }
        marker.userData = @(index);
        marker.map = _mapView;
        ++index;
    }

//    if(!self.annotationsEnabled) {
//        Carwash *carwash = self.carwashes[0];
//        if(carwash) {
//            GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:carwash.lat
//                                                                    longitude:carwash.lon
//                                                                         zoom:13];
//            [_mapView animateToCameraPosition:camera];
//        }
//    }
}

#pragma mark -
#pragma mark GMSMapView

-(UIView *)mapView:(GMSMapView *) aMapView markerInfoWindow:(GMSMarker*) marker
{
    CarwashComplex *carwash = self.carwashes[(NSUInteger) [marker.userData integerValue]];
    CarwashMarkerInfoWindowView *markerView = [CarwashMarkerInfoWindowView newAutoLayoutView];
    markerView.carwash = carwash;
    return markerView;
}

-(void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker
{
    if(self.annotationsEnabled) {
        __weak CarwashesMapViewController * weakSelft = self;
        [self setTabBarVisible:NO animated:YES completion:^(BOOL finished) {
            CarwashComplex *carwash = weakSelft.carwashes[(NSUInteger) [marker.userData integerValue]];
            
            CarwashViewController *v = [[CarwashViewController alloc] init];
            v.carwash = carwash;
            v.hidesBottomBarWhenPushed = YES;
            [weakSelft.navigationController pushViewController:v animated:YES];
        }];
    }
}

#pragma mark -

-(void)configUI
{
    [self setNavigationTitle:@"На карте"];
    [self setBlueBackground];
    [self showMenuButton];
    [self setNavigationBarTransparent];

    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:[[LocationHelper sharedInstance] latitude]
                                                            longitude:[[LocationHelper sharedInstance] longitude]
                                                                 zoom:12];
    _mapView.camera = camera;
    _mapView.delegate = self;
    _mapView.myLocationEnabled = YES;
    _mapView.settings.myLocationButton = YES;

    // Close Button
//    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [closeButton addTarget:self action:@selector(closeMap) forControlEvents:UIControlEventTouchUpInside];
//    UIImage *iconImage = [UIImage imageNamed:@"icon-map-close.png"];
//    [closeButton setBackgroundImage:iconImage forState:UIControlStateNormal];
//    closeButton.frame = CGRectMake([ASize screenWidth] - iconImage.size.width - 10, 10, iconImage.size.width, iconImage.size.height);
//    [self.view addSubview:closeButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc {

}

@end