//
// Created by Almas Adilbek on 9/20/14.
// Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "CarwashMapView.h"

@implementation CarwashMapView {
    GMSMapView *mapView_;
}

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    self = [super initWithFrame:CGRectMake(0, 0, [ASize screenWidth] - 2 * 20, 110)];
    if(self) {
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:coordinate.latitude
                                                                longitude:coordinate.longitude
                                                                     zoom:13];
        mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
        mapView_.frame = self.bounds;
        mapView_.delegate = self;
        [self addSubview:mapView_];

        // Marker
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.position = CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude);
        UIImage *iconImage = [UIImage imageWithName:@"icon-map-carwash"];
        marker.icon = iconImage;
        marker.groundAnchor = CGPointMake(0.5, 1);
        marker.map = mapView_;
        mapView_.userInteractionEnabled = NO;
    }
    return self;
}

@end