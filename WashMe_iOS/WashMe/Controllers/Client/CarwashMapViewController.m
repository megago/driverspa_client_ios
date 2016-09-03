//
//  CarwashMapViewController.m
//  WashMe
//
//  Created by Ivan Korotkikh on 30.07.16.
//  Copyright © 2016 Almas Adilbek. All rights reserved.
//

#import "CarwashMapViewController.h"
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

@implementation CarwashMapViewController{
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
    self.annotationsEnabled = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configUI];
    
    [[LocationHelper sharedInstance] requestLocation:^(CLLocation *currentLocation) {
        [self createAnnotations];
        
        // My location icon
        GMSMarker *myMarker = [GMSMarker markerWithPosition:CLLocationCoordinate2DMake([[LocationHelper sharedInstance] latitude], [[LocationHelper sharedInstance] longitude])];
        myMarker.icon = [UIImage imageNamed:@"mylocation-annotation"];
        myMarker.groundAnchor = CGPointMake(0.5, 1);
        myMarker.tappable = NO;
        myMarker.map = mapView_;
        
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:[[LocationHelper sharedInstance] latitude]
                                                                longitude:[[LocationHelper sharedInstance] longitude]
                                                                     zoom:13];
        [mapView_ animateToCameraPosition:camera];
    } failed:^(INTULocationStatus status) {
        [self createAnnotations];
    }];
}

-(void)viewWillAppear:(BOOL)animated {
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
}

-(void)viewWillDisappear:(BOOL)animated {
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}

-(void)viewDidDisappear:(BOOL)animated {
    
}

-(void)viewDidAppear:(BOOL)animated {
    if(!mapView_) {
        
    }
}

#pragma mark -
#pragma mark ACtions

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
        marker.map = mapView_;
        ++index;
    }
    
//    if(!self.annotationsEnabled) {
//        Carwash *carwash = self.carwashes[0];
//        if(carwash) {
//            GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:carwash.lat
//                                                                    longitude:carwash.lon
//                                                                         zoom:13];
//            [mapView_ animateToCameraPosition:camera];
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
        CarwashComplex *carwash = self.carwashes[(NSUInteger) [marker.userData integerValue]];
        
        CarwashViewController *v = [[CarwashViewController alloc] init];
        v.carwash = carwash;
        [self.navigationController pushViewController:v animated:YES];
    }
}

#pragma mark -

-(void)configUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:[[LocationHelper sharedInstance] latitude]
                                                            longitude:[[LocationHelper sharedInstance] longitude]
                                                                 zoom:12];
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView_.delegate = self;
    mapView_.myLocationEnabled = YES;
    mapView_.settings.myLocationButton = YES;
    self.view = mapView_;
    
    // Close Button
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton addTarget:self action:@selector(closeMap) forControlEvents:UIControlEventTouchUpInside];
    UIImage *iconImage = [UIImage imageNamed:@"icon-map-close.png"];
    [closeButton setBackgroundImage:iconImage forState:UIControlStateNormal];
    closeButton.frame = CGRectMake([ASize screenWidth] - iconImage.size.width - 10, 10, iconImage.size.width, iconImage.size.height);
    [self.view addSubview:closeButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc {
    
}

@end
