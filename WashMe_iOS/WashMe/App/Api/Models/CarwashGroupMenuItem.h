#import "ModelObject.h"

@interface CarwashGroupMenuItem : ModelObject {
    NSString *uid;
    NSString *name;
    NSArray *services;
    NSArray *prices;
}

@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSArray *services;
@property (nonatomic, copy) NSArray *prices;

+ (CarwashGroupMenuItem *)instanceFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;

@end
