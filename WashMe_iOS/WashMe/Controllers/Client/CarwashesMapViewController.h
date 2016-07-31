//
// Created by Almas Adilbek on 9/19/14.
// Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GoogleMaps/GoogleMaps.h>

@interface CarwashesMapViewController : UIViewController <GMSMapViewDelegate>

@property(nonatomic, strong) NSArray *carwashes;
@property(nonatomic, assign) BOOL annotationsEnabled;
@property(nonatomic, strong) IBOutlet GMSMapView *mapView;

@end