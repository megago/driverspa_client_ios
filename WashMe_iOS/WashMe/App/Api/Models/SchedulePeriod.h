#import "ModelObject.h"


@interface SchedulePeriod : ModelObject {

    NSNumber *from;
    NSNumber *to;

}

@property (nonatomic, copy) NSNumber *from;
@property (nonatomic, copy) NSNumber *to;

+ (SchedulePeriod *)instanceFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;

- (NSString *)workingTime;

@end
