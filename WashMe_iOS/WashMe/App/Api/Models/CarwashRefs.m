#import "CarwashRefs.h"
#import "IdTitleObject.h"
#import "ApiUtils.h"
#import "Cache.h"
#import "City.h"

@implementation CarwashRefs

@synthesize additionalInfo, cities, contactType, payoptions;

+ (CarwashRefs *)instanceFromDictionary:(NSDictionary *)aDictionary {

    CarwashRefs *instance = [[CarwashRefs alloc] init];
    [instance setAttributesFromDictionary:aDictionary];
    return instance;

}

- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary {

    if (![aDictionary isKindOfClass:[NSDictionary class]]) {
        return;
    }

    [super setAttributesFromDictionary:aDictionary];

    NSArray *citiesArray = aDictionary[@"cities"];
    if(citiesArray) {
        NSMutableArray * array = [NSMutableArray array];
        for(NSDictionary *item in citiesArray) {
            [array addObject:[City instanceFromDictionary:item]];
        }
        self.cities = array;
    }

//    NSArray *receivedAdditionalInfo = aDictionary[@"additional_info"];
//    if ([receivedAdditionalInfo isKindOfClass:[NSArray class]]) {
//
//        NSMutableArray *populatedAdditionalInfo = [NSMutableArray arrayWithCapacity:[receivedAdditionalInfo count]];
//        for (NSDictionary *item in receivedAdditionalInfo) {
//            if ([item isKindOfClass:[NSDictionary class]]) {
//                #warning This array can contain members of varying types. Since your preference is set to not merge array (and thus set) models, which type to use for a given member is ambiguous, so no assignment occurs here. Sample assignments have been provided.
//            }
//        }
//
//        self.additionalInfos = populatedAdditionalInfo;
//
//    }
//
//    NSArray *receivedCarType = aDictionary[@"car_type"];
//    if ([receivedCarType isKindOfClass:[NSArray class]]) {
//
//        NSMutableArray *populatedCarType = [NSMutableArray array];
//        for (NSDictionary *item in receivedCarType) {
//            if ([item isKindOfClass:[NSDictionary class]]) {
//                #warning This array can contain members of varying types. Since your preference is set to not merge array (and thus set) models, which type to use for a given member is ambiguous, so no assignment occurs here. Sample assignments have been provided.
//            }
//        }
//
//        self.carType = populatedCarType;
//
//    }
//
//    NSArray *receivedCities = aDictionary[@"cities"];
//    if ([receivedCities isKindOfClass:[NSArray class]]) {
//
//        NSMutableArray *populatedCities = [NSMutableArray array];
//        for (NSDictionary *item in receivedCities) {
//            if ([item isKindOfClass:[NSDictionary class]]) {
//                #warning This array can contain members of varying types. Since your preference is set to not merge array (and thus set) models, which type to use for a given member is ambiguous, so no assignment occurs here. Sample assignments have been provided.
//            }
//        }
//
//        self.cities = populatedCities;
//
//    }
//
//    NSArray *receivedContactType = [aDictionary objectForKey:@"contact_type"];
//    if ([receivedContactType isKindOfClass:[NSArray class]]) {
//
//        NSMutableArray *populatedContactType = [NSMutableArray array];
//        for (NSDictionary *item in receivedContactType) {
//            if ([item isKindOfClass:[NSDictionary class]]) {
//                #warning This array can contain members of varying types. Since your preference is set to not merge array (and thus set) models, which type to use for a given member is ambiguous, so no assignment occurs here. Sample assignments have been provided.
//            }
//        }
//
//        self.contactType = populatedContactType;
//
//    }
//
//    NSArray *receivedPayoptions = aDictionary[@"payoptions"];
//    if ([receivedPayoptions isKindOfClass:[NSArray class]]) {
//
//        NSMutableArray *populatedPayoptions = [NSMutableArray array];
//        for (NSDictionary *item in receivedPayoptions) {
//            if ([item isKindOfClass:[NSDictionary class]]) {
//                #warning This array can contain members of varying types. Since your preference is set to not merge array (and thus set) models, which type to use for a given member is ambiguous, so no assignment occurs here. Sample assignments have been provided.
//            }
//        }
//
//        self.payoptions = populatedPayoptions;
//
//    }

}

+ (NSArray *)serviceObjectsWithServiceIds:(NSArray *)ids
{
    NSDictionary *servicesDictionary = [[Cache carwashRefs] servicesDictionary];
    if(servicesDictionary) {
        NSMutableArray *serviceObjects = [NSMutableArray array];
        for(id serviceId in ids) {
            [serviceObjects addObject:servicesDictionary[serviceId]];
        }
        return serviceObjects;
    }
    return @[];
}


@end
