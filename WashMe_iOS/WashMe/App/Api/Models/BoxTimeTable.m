#import "BoxTimeTable.h"

@implementation BoxTimeTable

@synthesize slots, uid;

+ (BoxTimeTable *)instanceFromDictionary:(NSDictionary *)aDictionary {

    BoxTimeTable *instance = [[BoxTimeTable alloc] init];
    [instance setAttributesFromDictionary:aDictionary];
    return instance;

}

- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary {

    if (![aDictionary isKindOfClass:[NSDictionary class]]) {
        return;
    }

    self.slots = aDictionary[@"slots"];
    self.uid = aDictionary[@"uid"];

    self.intervalMinutes = (24 * 60) / self.slots.count;
}


@end
