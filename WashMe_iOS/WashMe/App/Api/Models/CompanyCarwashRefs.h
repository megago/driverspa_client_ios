#import "ModelObject.h"
#import "BaseRefs.h"


@interface CompanyCarwashRefs : BaseRefs {

    NSArray *additionalInfo;
    NSArray *cities;
    NSArray *contactType;
    NSArray *payoptions;

}

@property (nonatomic, copy) NSArray *additionalInfo;
@property (nonatomic, copy) NSArray *cities;
@property (nonatomic, copy) NSArray *contactType;
@property (nonatomic, copy) NSArray *payoptions;

+ (CompanyCarwashRefs *)instanceFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;

@end
