//
//  SetCarwashCoordinateViewController.h
//  WashMe
//
//  Created by Almas Adilbek on 10/22/14.
//  Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

#import <GoogleMaps/GoogleMaps.h>

@protocol SetCarwashCoordinateViewControllerDelegate;

@interface SetCarwashCoordinateViewController : UIViewController <GMSMapViewDelegate>

@property(nonatomic, assign) CLLocationCoordinate2D coordinate;
@property(nonatomic, weak) id <SetCarwashCoordinateViewControllerDelegate> delegate;

@end


@protocol SetCarwashCoordinateViewControllerDelegate<NSObject>
-(void)setCarwashCoordinateViewControllerCoordinateDidSet:(CLLocationCoordinate2D)coordinate;
@end