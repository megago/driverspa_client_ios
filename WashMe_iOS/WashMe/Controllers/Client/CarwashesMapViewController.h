//
// Created by Almas Adilbek on 9/19/14.
// Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GoogleMaps/GoogleMaps.h>

@interface CarwashesMapViewController : UIViewController <GMSMapViewDelegate>

@property(nonatomic, strong) NSArray *carwashes;
@property(nonatomic, assign) BOOL annotationsEnabled;
// Plain container from the storyboard; the GMSMapView is created in code (device only,
// so the simulator — where GoogleMaps' Metal renderer crashes — shows a placeholder).
@property(nonatomic, strong) IBOutlet UIView *mapContainer;
@property(nonatomic, strong) GMSMapView *mapView;

@end