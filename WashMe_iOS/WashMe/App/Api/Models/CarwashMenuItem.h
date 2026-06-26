#import "ModelObject.h"


@interface CarwashMenuItem : ModelObject {

    NSNumber *price;
    NSNumber *time;
    NSNumber *type;

}

@property (nonatomic, copy) NSNumber *price;
@property (nonatomic, copy) NSNumber *time;
@property (nonatomic, copy) NSNumber *type;

+ (CarwashMenuItem *)instanceFromDictionary:(NSDictionary *)aDictionary;
+ (CarwashMenuItem *)instanceWithType:(NSNumber *)itemType price:(NSNumber *)itemPrice;
+ (CarwashMenuItem *)instanceWithType:(NSNumber *)itemType price:(NSNumber *)itemPrice time:(NSNumber *)theTime;

- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;

- (NSDictionary *)dictionaryValue;

@end
