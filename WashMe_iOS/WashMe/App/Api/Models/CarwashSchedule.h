#import "ModelObject.h"


@interface CarwashSchedule : ModelObject {

}

@property (nonatomic, copy) NSString *comment;
@property (nonatomic, copy) NSArray *fri;
@property (nonatomic, copy) NSArray *mon;
@property (nonatomic, copy) NSArray *sat;
@property (nonatomic, copy) NSArray *sun;
@property (nonatomic, copy) NSArray *thu;
@property (nonatomic, copy) NSArray *tue;
@property (nonatomic, copy) NSArray *wed;

+ (CarwashSchedule *)instanceFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;

- (NSArray *)todaySchedules;

@end
