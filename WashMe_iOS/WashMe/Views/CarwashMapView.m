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
    return [self initWithCoordinate:coordinate andIconName:@"icon-map-carwash"];
}

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate andIconName:(NSString *)iconName
{
    self = [super initWithFrame:CGRectMake(0, 0, [ASize screenWidth] - 2 * 20, 110)];
    if(self) {
#if TARGET_OS_SIMULATOR
        // GoogleMaps' Metal renderer crashes on the iOS simulator; show a placeholder.
        [self addSimulatorMapPlaceholder];
#else
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
        marker.icon = [UIImage imageWithName:iconName];
        marker.groundAnchor = CGPointMake(0.5, 1);
        marker.map = mapView_;
        mapView_.userInteractionEnabled = NO;
#endif
    }
    return self;
}

#if TARGET_OS_SIMULATOR
- (void)addSimulatorMapPlaceholder
{
    UIView *placeholder = [[UIView alloc] initWithFrame:self.bounds];
    placeholder.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    placeholder.backgroundColor = [UIColor colorWithWhite:0.85 alpha:1.0];

    UILabel *label = [[UILabel alloc] initWithFrame:placeholder.bounds];
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor darkGrayColor];
    label.font = [UIFont systemFontOfSize:12];
    label.text = @"Карта (доступна на устройстве)";
    [placeholder addSubview:label];
    [self addSubview:placeholder];
}
#endif

@end
