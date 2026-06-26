#import <CoreLocation/CoreLocation.h>
#import "ModelObject.h"


@interface City : ModelObject {

    NSString *code;
    CLLocationDegrees latitude;
    CLLocationDegrees longitude;
    NSString *title;

}

@property (nonatomic, copy) NSString *code;
@property (nonatomic, assign) CLLocationDegrees latitude;
@property (nonatomic, assign) CLLocationDegrees longitude;
@property (nonatomic, copy) NSString *title;

+ (City *)instanceFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;

- (CLLocationCoordinate2D)location;
- (BOOL)isCity:(City *)city;

@end
