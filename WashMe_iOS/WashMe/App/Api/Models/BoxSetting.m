#import "BoxSetting.h"

@implementation BoxSetting

@synthesize bookingType, uid, boxName;

+ (BoxSetting *)instanceFromDictionary:(NSDictionary *)aDictionary {

    BoxSetting *instance = [[BoxSetting alloc] init];
    [instance setAttributesFromDictionary:aDictionary];
    return instance;

}

- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary {

    if (![aDictionary isKindOfClass:[NSDictionary class]]) {
        return;
    }

    self.bookingType = [aDictionary objectForKey:@"booking_type"];
    self.uid = [aDictionary objectForKey:@"uid"];
    self.boxName = [aDictionary objectForKey:@"box_name"];
}

- (NSString *)localizedBoxType {
    if ([self.bookingType isEqual:@"online"]){
        return @"Онлайн";
    } else if ([self.bookingType isEqual:@"offline"]) {
        return @"Офлайн";
    }
    return nil;
}

#pragma mark -
#pragma mark NSCoding

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        self.bookingType = [decoder decodeObjectForKey:@"bookingType"];
        self.uid = [decoder decodeObjectForKey:@"uid"];
        self.boxName = [decoder decodeObjectForKey:@"boxName"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.bookingType forKey:@"bookingType"];
    [encoder encodeObject:self.uid forKey:@"uid"];
    [encoder encodeObject:self.boxName forKey:@"boxName"];
}

@end
