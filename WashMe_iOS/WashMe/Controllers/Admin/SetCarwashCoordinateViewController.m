//
//  SetCarwashCoordinateViewController.m
//  WashMe
//
//  Created by Almas Adilbek on 10/22/14.
//  Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "SetCarwashCoordinateViewController.h"
#import "UIViewController+Ext.h"
#import "LocationHelper.h"

@interface SetCarwashCoordinateViewController ()
@end

@implementation SetCarwashCoordinateViewController {
    GMSMapView *mapView_;
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
    [self configUI];

    [Toast showHudLoading];
    [[LocationHelper sharedInstance] requestLocation:^(CLLocation *currentLocation) {
        [Toast hideHud];
        [self createMap];
    } failed:^(INTULocationStatus status) {
        [Toast hideHud];
        [self.navigationController popViewControllerAnimated:YES];
        [UIHelper showAlertTryAgain];
    }];
}

- (void)createMap
{
    CLLocationCoordinate2D location;

    if(CLLocationCoordinate2DIsValid(_coordinate)) {
        location = CLLocationCoordinate2DMake(_coordinate.latitude, _coordinate.longitude);
    } else {
        location = CLLocationCoordinate2DMake([[LocationHelper sharedInstance] latitude], [[LocationHelper sharedInstance] longitude]);
    }

    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:location.latitude
                                                            longitude:location.longitude
                                                                 zoom:14];
    mapView_ = [GMSMapView mapWithFrame:CGRectMake(0, 64, [ASize screenWidth], [ASize screenHeightWithoutStatusBarAndNavigationBar] - 44) camera:camera];
    mapView_.delegate = self;
    mapView_.myLocationEnabled = YES;
    mapView_.settings.myLocationButton = YES;
    [self.view addSubview:mapView_];

    // My location icon
    GMSMarker *myMarker = [GMSMarker markerWithPosition:location];
    myMarker.icon = [UIImage imageNamed:@"mylocation-annotation"];
    myMarker.groundAnchor = CGPointMake(0.5, 1);
    [myMarker setDraggable:YES];
    myMarker.map = mapView_;
}

#pragma mark -
#pragma mark GMSMapView

-(void)mapView:(GMSMapView *)mapView didEndDraggingMarker:(GMSMarker *)marker {
    [self.delegate setCarwashCoordinateViewControllerCoordinateDidSet:marker.position];
}

#pragma mark -

-(void)configUI
{
    [self setBlueBackground];
    [self setBackButton];
    [self setNavigationTitle:@"Укажите на карте"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc {

}

@end