#import "BoxSetting.h"

@implementation BoxSetting

@synthesize bookingType, uid;

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

}


@end
