//
// Created by Almas Adilbek on 9/20/14.
// Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <GoogleMaps/GoogleMaps.h>


@interface CarwashMapView : UIView <GMSMapViewDelegate>

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate;
- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate andIconName:(NSString *)iconName;

@end
