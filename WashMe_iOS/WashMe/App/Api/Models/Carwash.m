#import "Carwash.h"
#import "LocationHelper.h"
#import "ImageBundle.h"
#import "NSString+Ext.h"
#import "City.h"
#import "CompanyCarwashRefs.h"
#import "Cache.h"
#import "CarwashRefs.h"
#import "CompanyDiscount.h"

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
    
    NSDictionary *discount = (NSDictionary *)[self idValueForKey:@"active_company_campaign"];
    self.discount = [CompanyDiscount instanceFromDictionary:discount];
    
//    CompanyDiscount *testDiscount = [CompanyDiscount new];
//    testDiscount.discountId = @"18b37afb-0bdc-48dd-90bc-d7f01541c8ac";
//    testDiscount.discountValue = [NSNumber numberWithInteger:20];
//    testDiscount.discountType = @"online";
//    testDiscount.discountDescription = @"test akcia vsem vsem vsem jirtamiz";
//    testDiscount.startDate = [NSDate date];
//    testDiscount.endDate = [[NSDate date] dateByAddingTimeInterval:60*60*60];
//    self.discount = testDiscount;

    objectData = nil;
}

#pragma mark -
#pragma mark NSCoding

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        self.public = [decoder decodeBoolForKey:@"public"];
        self.address = [decoder decodeObjectForKey:@"address"];
        self.city = [decoder decodeObjectForKey:@"city"];
        self.carwashId = [decoder decodeObjectForKey:@"carwashId"];
        self.isWorking = [decoder decodeBoolForKey:@"isWorking"];
        self.isBookable = [decoder decodeBoolForKey:@"isBookable"];
        self.name = [decoder decodeObjectForKey:@"name"];
        //self.payoptions = [decoder decodeObjectForKey:@"payoptions"];
        self.rating = [decoder decodeObjectForKey:@"rating"];
        self.resourceUri = [decoder decodeObjectForKey:@"resourceUri"];
        self.lat = [decoder decodeFloatForKey:@"lat"];
        self.lon = [decoder decodeFloatForKey:@"lon"];
        self.carwashImages = [decoder decodeObjectForKey:@"carwashImages"];
        self.price = [decoder decodeObjectForKey:@"price"];
        self.status = [decoder decodeObjectForKey:@"status"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    
    [encoder encodeBool:self.public forKey:@"public"];
    [encoder encodeObject:self.address forKey:@"address"];
    [encoder encodeObject:self.city forKey:@"city"];
    [encoder encodeObject:self.carwashId forKey:@"carwashId"];
    [encoder encodeBool:self.isWorking forKey:@"isWorking"];
    [encoder encodeBool:self.isBookable forKey:@"isBookable"];
    [encoder encodeObject:self.name forKey:@"name"];
    //[encoder encodeObject:self.payoptions forKey:@"payoptions"];
    [encoder encodeObject:self.rating forKey:@"rating"];
    [encoder encodeObject:self.resourceUri forKey:@"resourceUri"];
    [encoder encodeFloat:self.lat forKey:@"lat"];
    [encoder encodeFloat:self.lon forKey:@"lon"];
    [encoder encodeObject:self.carwashImages forKey:@"carwashImages"];
    [encoder encodeObject:self.price forKey:@"price"];
    [encoder encodeObject:self.status forKey:@"status"]; 
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
    if([CLLocationManager locationServicesEnabled] &&
       [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied)
    {
        long meters = [self distanceInMeters];
        if(meters < 1000) return [@"~" stringByAppendingString:[NSString stringWithFormat:@"%li м", meters]];
        
        CGFloat kilometers = (CGFloat) (meters * 0.001);
        
        return [@"~" stringByAppendingString:[NSString stringWithFormat:@"%@ км", [[NSString stringWithFormat:@"%.02f", kilometers] formattedNumberText]]];
    }
    return nil;
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
