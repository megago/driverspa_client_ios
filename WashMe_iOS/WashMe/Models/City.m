#import "City.h"
#import "NSObject+PropertyUtils.h"

@implementation City

@synthesize code, latitude, longitude, title;

+ (City *)instanceFromDictionary:(NSDictionary *)aDictionary {

    City *instance = [[City alloc] init];
    [instance setAttributesFromDictionary:aDictionary];
    return instance;

}

- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary {

    if (![aDictionary isKindOfClass:[NSDictionary class]]) {
        return;
    }

    objectData = aDictionary;

    self.code = [self stringValueForKey:@"code"];
    self.title = [self stringValueForKey:@"title"];

    NSArray *coordinates = aDictionary[@"lonlat"];
    if(coordinates && coordinates.count == 2) {
        self.longitude = [coordinates[0] floatValue];
        self.latitude = [coordinates[1] floatValue];
    }

    objectData = nil;

}

- (CLLocationCoordinate2D)location {
    return CLLocationCoordinate2DMake(self.latitude, self.longitude);
}

- (BOOL)isCity:(City *)city {
    return [self.code isEqual:city.code];
}

@end
