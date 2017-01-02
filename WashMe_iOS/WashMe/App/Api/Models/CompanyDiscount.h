#import "ModelObject.h"

@interface CompanyDiscount : ModelObject
@property (nonatomic, copy)   NSString *discountId;
@property (nonatomic, assign) NSNumber *discountValue;
@property (nonatomic, copy)   NSString *discountType;
@property (nonatomic, copy)   NSString *discountDescription;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;

+ (CompanyDiscount *)instanceFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;

@end
