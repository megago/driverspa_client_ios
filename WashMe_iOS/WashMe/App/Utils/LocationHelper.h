//
//  LocationHelper.h
//  AstanaGuide
//
//  Created by Almas Adilbek on 09/04/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "INTULocationManager.h"

typedef void (^LocationHelperLocationSuccess)(CLLocation *currentLocation);
typedef void (^LocationHelperLocationFailed)(INTULocationStatus status);

@interface LocationHelper : NSObject<CLLocationManagerDelegate> {
    CLLocationDegrees longitude;
    CLLocationDegrees latitude;
}

@property (nonatomic, assign) CLLocationDegrees longitude;
@property (nonatomic, assign) CLLocationDegrees latitude;

+(LocationHelper *)sharedInstance;

- (void)requestLocation:(LocationHelperLocationSuccess)locationSuccess failed:(LocationHelperLocationFailed)locationFailed;

+(BOOL)isCurrentLocationEnabled;
+(CLLocationCoordinate2D)myLocationCoordinate;

+(long)metersBetweenMeAndPlace:(CLLocationCoordinate2D)place;
+(long)metersBetweenPlace1:(CLLocationCoordinate2D)place1 andPlace2:(CLLocationCoordinate2D)place2;

@end
