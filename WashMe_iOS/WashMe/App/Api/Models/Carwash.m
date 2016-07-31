#import "Carwash.h"
#import "LocationHelper.h"
#import "ImageBundle.h"
#import "NSString+Ext.h"
#import "City.h"
#import "CompanyCarwashRefs.h"
#import "Cache.h"
#import "CarwashRefs.h"

@implementation Carwash

@synthesize address, city, carwashId, isWorking, name, payoptions, rating, resourceUri, lon, lat;

+ (Carwash *)instanceFromDictionary:(NSDictionary *)aDictionary {

    Carwash *instance = [[Carwash alloc] init];
    [instance setAttributesFromDictionary:aDictionary];
    return instance;

}

- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary {

    if (![aDictionary isKindOfClass:[NSDictionary class]]) {
        return;
    }

    objectData = aDictionary;

    self.public = [self boolValueForKey:@"is_public"];
    self.address = [self stringValueForKey:@"address"];
    self.city = [self stringValueForKey:@"city"];
    self.carwashId = [self stringValueForKey:@"id"];
    self.isWorking = [[self stringValueForKey:@"is_working"] boolValue];
    self.isBookable = [[self stringValueForKey:@"is_bookable"] boolValue];
    self.name = [self stringValueForKey:@"name"];
    self.rating = [self numberValueForKey:@"rating"];
    self.resourceUri = [self stringValueForKey:@"resource_uri"];
    self.price = [self numberValueForKey:@"price"];
    self.status = [self stringValueForKey:@"status"];

    NSArray *lonlat = [self arrayValueForKey:@"lonlat"];
    self.lon = [lonlat[0] floatValue];
    self.lat = [lonlat[1] floatValue];

    self.payoptions = [self arrayValueForKey:@"payoptions"];

    // Images
    NSArray *images = [self arrayValueForKey:@"images"];
    NSMutableArray *populatedImages = [NSMutableArray array];
    for(NSDictionary *image in images) {
        [populatedImages addObject:[ImageBundle instanceFromDictionary:image]];
    }
    self.carwashImages = populatedImages;

    objectData = nil;
}

#pragma mark -
#pragma mark Distance

- (long)distanceInMeters {
    return [LocationHelper metersBetweenMeAndPlace:[self coordinate]];
}

- (CLLocationCoordinate2D)coordinate {
    return CLLocationCoordinate2DMake(self.lat, self.lon);
}

- (NSString *)distanceToText {
    long meters = [self distanceInMeters];
    if(meters < 1000) return [NSString stringWithFormat:@"%li м", meters];

    CGFloat kilometers = (CGFloat) (meters * 0.001);

    return [NSString stringWithFormat:@"%@ км", [[NSString stringWithFormat:@"%.02f", kilometers] formattedNumberText]];
}

- (City *)cityObject
{
    NSArray *cities = [[Cache companyCarwashRefs] cities];
    for(City *city1 in cities) {
        if([city1.code isEqual:self.city]) {
            return city1;
        }
    }
    return nil;
}


@end
