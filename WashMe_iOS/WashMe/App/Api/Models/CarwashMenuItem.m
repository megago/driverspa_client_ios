#import "CarwashMenuItem.h"

@implementation CarwashMenuItem

@synthesize price, time, type;

+ (CarwashMenuItem *)instanceFromDictionary:(NSDictionary *)aDictionary {

    CarwashMenuItem *instance = [[CarwashMenuItem alloc] init];
    [instance setAttributesFromDictionary:aDictionary];
    return instance;

}

+ (CarwashMenuItem *)instanceWithType:(NSNumber *)itemType price:(NSNumber *)itemPrice {
    return [self instanceWithType:itemType price:itemPrice time:nil];
}

+ (CarwashMenuItem *)instanceWithType:(NSNumber *)itemType price:(NSNumber *)itemPrice time:(NSNumber *)theTime
{
    CarwashMenuItem *instance = [[CarwashMenuItem alloc] init];
    instance.type = itemType;
    instance.price = itemPrice;
    instance.time = theTime ? theTime : @0;
    return instance;
}


- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary {

    if (![aDictionary isKindOfClass:[NSDictionary class]]) {
        return;
    }

    self.price = aDictionary[@"price"];
    self.time = aDictionary[@"time"];
    self.type = aDictionary[@"type"];

}

- (NSDictionary *)dictionaryValue {
    return @{@"type":self.type, @"price":self.price, @"time":self.time};
}

#pragma mark -
#pragma mark NSCoding

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        self.price = [decoder decodeObjectForKey:@"price"];
        self.time = [decoder decodeObjectForKey:@"time"];
        self.type = [decoder decodeObjectForKey:@"type"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.price forKey:@"price"];
    [encoder encodeObject:self.time forKey:@"time"];
    [encoder encodeObject:self.type forKey:@"type"];
}

@end
