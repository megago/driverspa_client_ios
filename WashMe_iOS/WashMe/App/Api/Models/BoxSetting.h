#import "ModelObject.h"


@interface BoxSetting : ModelObject {

    NSString *bookingType;
    NSString *uid;

}

@property (nonatomic, copy) NSString *bookingType;
@property (nonatomic, copy) NSString *uid;

+ (BoxSetting *)instanceFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;

@end
