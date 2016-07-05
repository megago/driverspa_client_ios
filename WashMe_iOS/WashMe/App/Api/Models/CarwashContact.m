#import "CarwashContact.h"

@implementation CarwashContact

@synthesize alias, comment, type, value;

+ (CarwashContact *)instanceFromDictionary:(NSDictionary *)aDictionary {

    CarwashContact *instance = [[CarwashContact alloc] init];
    [instance setAttributesFromDictionary:aDictionary];
    return instance;

}

- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary {

    if (![aDictionary isKindOfClass:[NSDictionary class]]) {
        return;
    }

    objectData = aDictionary;

    self.alias = [self stringValueForKey:@"alias"];
    self.comment = [self stringValueForKey:@"comment"];
    self.type = [self stringValueForKey:@"type"];
    self.value = [self stringValueForKey:@"value"];

    objectData = nil;
}

- (BOOL)isEmail {
    return [self.type isEqual:@"email"];
}

- (BOOL)isWebsite {
    return [self.type isEqual:@"website"];
}

- (BOOL)isPhone {
    return [self.type isEqual:@"phone"];
}


@end
