#import <CoreLocation/CoreLocation.h>
#import "ModelObject.h"

@class ImageBundle;
@class City;


@interface Carwash : ModelObject {
}

@property (nonatomic, assign, getter=isPublic) BOOL public;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *carwashId;
@property (nonatomic, assign) BOOL isWorking;
@property (nonatomic, assign) BOOL isBookable;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSArray *payoptions;
@property (nonatomic, copy) NSNumber *rating;
@property (nonatomic, copy) NSString *resourceUri;
@property (nonatomic, assign) CGFloat lat;
@property (nonatomic, assign) CGFloat lon;
@property (nonatomic, strong) NSArray *carwashImages;
@property (nonatomic, strong) NSNumber *price;

+ (Carwash *)instanceFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;

- (long)distanceInMeters;
- (CLLocationCoordinate2D)coordinate;
- (NSString *)distanceToText;

- (City *)cityObject;

@end
