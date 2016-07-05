//
//  LocationHelper.m
//  AstanaGuide
//
//  Created by Almas Adilbek on 09/04/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "LocationHelper.h"

static LocationHelper *_sharedInstance = nil;

@implementation LocationHelper {
    NSInteger locationRequestID;
}

@synthesize longitude, latitude;

-(id)init {
    self = [super init];
    if (self) {

    }
    return self;
}

+(LocationHelper *)sharedInstance {
    if(!_sharedInstance) {
        _sharedInstance = [[LocationHelper alloc] init];
    }
    return _sharedInstance;
}

- (void)requestLocation:(LocationHelperLocationSuccess)locationSuccess failed:(LocationHelperLocationFailed)locationFailed
{
    __weak __typeof(self) weakSelf = self;

    INTULocationManager *locMgr = [INTULocationManager sharedInstance];
    locationRequestID = [locMgr requestLocationWithDesiredAccuracy:INTULocationAccuracyRoom
                                                                timeout:0.25
                                                   delayUntilAuthorized:YES
                                                                  block:^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, INTULocationStatus status) {

                                                                      __typeof(weakSelf) strongSelf = weakSelf;
                                                                      LocationHelperLocationSuccess strongLocationSuccess = locationSuccess;
                                                                      LocationHelperLocationFailed strongLocationFailed = locationFailed;


                                                                      if (status == INTULocationStatusSuccess) {
                                                                          // achievedAccuracy is at least the desired accuracy (potentially better)
//                                                                          strongSelf.statusLabel.text = [NSString stringWithFormat:@"Location request successful! Current Location:\n%@", currentLocation];
                                                                          [strongSelf onLocationChange:currentLocation];
                                                                          strongLocationSuccess(currentLocation);
                                                                      }
                                                                      else if (status == INTULocationStatusTimedOut) {
                                                                          // You may wish to inspect achievedAccuracy here to see if it is acceptable, if you plan to use currentLocation
//                                                                          strongSelf.statusLabel.text = [NSString stringWithFormat:@"Location request timed out. Current Location:\n%@", currentLocation];
                                                                          [strongSelf onLocationChange:currentLocation];
                                                                          strongLocationSuccess(currentLocation);
                                                                      }
                                                                      else {
                                                                          // An error occurred
                                                                          if (status == INTULocationStatusServicesNotDetermined) {
//                                                                              strongSelf.statusLabel.text = @"Error: User has not responded to the permissions alert.";
                                                                          } else if (status == INTULocationStatusServicesDenied) {
//                                                                              strongSelf.statusLabel.text = @"Error: User has denied this app permissions to access device location.";
                                                                          } else if (status == INTULocationStatusServicesRestricted) {
//                                                                              strongSelf.statusLabel.text = @"Error: User is restricted from using location services by a usage policy.";
                                                                          } else if (status == INTULocationStatusServicesDisabled) {
//                                                                              strongSelf.statusLabel.text = @"Error: Location services are turned off for all apps on this device.";
                                                                          } else {
//                                                                              strongSelf.statusLabel.text = @"An unknown error occurred.\n(Are you using iOS Simulator with location set to 'None'?)";
                                                                          }
                                                                          strongLocationFailed(status);
                                                                      }

                                                                      locationRequestID = NSNotFound;
                                                                  }];
}


+(BOOL)isCurrentLocationEnabled {
    return [CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied;
}

+(CLLocationCoordinate2D)myLocationCoordinate {
    return CLLocationCoordinate2DMake([self sharedInstance].latitude, [self sharedInstance].longitude);
}

+ (long)metersBetweenMeAndPlace:(CLLocationCoordinate2D)place
{
    return [self metersBetweenPlace1:[LocationHelper myLocationCoordinate] andPlace2:place];
}


-(void)onLocationChange:(CLLocation *)location {
    LocationHelper *instance = [LocationHelper sharedInstance];
    instance.longitude = location.coordinate.longitude;
    instance.latitude = location.coordinate.latitude;
    NSLog(@"Location changed: %@", location);
}

+(long)metersBetweenPlace1:(CLLocationCoordinate2D)place1 andPlace2:(CLLocationCoordinate2D)place2
{
    // Haversine formula
    int R = 6371;  // earth's mean radius in km
    double dLat = [self toRadian:(place2.latitude - place1.latitude)];
    double dLon = [self toRadian:(place2.longitude - place1.longitude)];

    double a = pow(sin(dLat / 2), 2) + cos([self toRadian:place1.latitude]) * cos([self toRadian:place2.latitude]) * pow(sin(dLon / 2), 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    double d = R * c;

    return (long)floor(d * 1000);
}

#pragma mark -
#pragma mark CLLocationManager

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    self.latitude = newLocation.coordinate.latitude;
    self.longitude = newLocation.coordinate.longitude;
    NSLog(@"Location updated: %f, %f", latitude, longitude);
}

#pragma mark -

+(double)toRadian:(CLLocationDegrees)value {
    return M_PI * value / 180;
}

#pragma mark - Dealloc

- (void)dealloc {
    _sharedInstance = nil;
}


@end
