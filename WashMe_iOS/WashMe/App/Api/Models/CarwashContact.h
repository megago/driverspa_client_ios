#import "ModelObject.h"


@interface CarwashContact : ModelObject {

    NSString *alias;
    id comment;
    NSString *type;
    NSString *value;

}

@property (nonatomic, copy) NSString *alias;
@property (nonatomic, strong) NSString *comment;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *value;

+ (CarwashContact *)instanceFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;

- (BOOL)isEmail;
- (BOOL)isWebsite;
- (BOOL)isPhone;

@end
