#import "CompanyCarwashRefs.h"
#import "IdTitleObject.h"
#import "ApiUtils.h"

@implementation CompanyCarwashRefs

@synthesize additionalInfo, cities, contactType, payoptions;

+ (CompanyCarwashRefs *)instanceFromDictionary:(NSDictionary *)aDictionary {

    CompanyCarwashRefs *instance = [[CompanyCarwashRefs alloc] init];
    [instance setAttributesFromDictionary:aDictionary];
    return instance;

}

- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary {

    if (![aDictionary isKindOfClass:[NSDictionary class]]) {
        return;
    }

    [super setAttributesFromDictionary:aDictionary];

    self.additionalInfo = [ApiUtils responseArrayToIdTitleObjectsArray:aDictionary[@"additional_info"]];
    self.payoptions = [ApiUtils responseArrayToIdTitleObjectsArray:aDictionary[@"payoptions"]];

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


}


@end
