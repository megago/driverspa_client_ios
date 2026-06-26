#import "ModelObject.h"
#import "BaseRefs.h"


@interface CarwashRefs : BaseRefs {

    NSArray *additionalInfo;
    NSArray *cities;
    NSArray *contactType;
    NSArray *payoptions;

}

@property (nonatomic, copy) NSArray *additionalInfo;
@property (nonatomic, copy) NSArray *cities;
@property (nonatomic, copy) NSArray *contactType;
@property (nonatomic, copy) NSArray *payoptions;

+ (CarwashRefs *)instanceFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;

+(NSArray *)serviceObjectsWithServiceIds:(NSArray *)ids;

@end
