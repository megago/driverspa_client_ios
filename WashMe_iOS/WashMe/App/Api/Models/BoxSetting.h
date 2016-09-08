#import "ModelObject.h"


@interface BoxSetting : ModelObject {

    NSString *bookingType;
    NSString *uid;
    NSString *boxName;
    
}

@property (nonatomic, copy) NSString *bookingType;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *boxName;

+ (BoxSetting *)instanceFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;

@end
