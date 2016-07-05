#import "SchedulePeriod.h"

@implementation SchedulePeriod

@synthesize from, to;

+ (SchedulePeriod *)instanceFromDictionary:(NSDictionary *)aDictionary {

    SchedulePeriod *instance = [[SchedulePeriod alloc] init];
    [instance setAttributesFromDictionary:aDictionary];
    return instance;

}

- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary {

    if (![aDictionary isKindOfClass:[NSDictionary class]]) {
        return;
    }

    objectData = aDictionary;

    self.from = [self numberValueForKey:@"fr"];
    self.to = [self numberValueForKey:@"to"];

    objectData = nil;
}

- (NSString *)workingTime
{
    NSInteger from_ = [self.from integerValue];
    NSInteger to_ = [self.to integerValue];

    NSInteger fromHour = (NSInteger) floor(from_ / 60);
    NSInteger fromMinutes = (from_ % 60);

    NSInteger toHour = (NSInteger) floor(to_ / 60);
    NSInteger toMinutes = (to_ % 60);

    NSString *fromHourStr = [NSString stringWithFormat:@"%@%i", fromHour < 10 ? @"0":@"", fromHour];
    NSString *fromMinutesStr = [NSString stringWithFormat:@"%@%i", fromMinutes < 10 ? @"0":@"", fromMinutes];

    NSString *toHourStr = [NSString stringWithFormat:@"%@%i", toHour < 10 ? @"0":@"", toHour];
    NSString *toMinutesStr = [NSString stringWithFormat:@"%@%i", toMinutes < 10 ? @"0":@"", toMinutes];

    return [NSString stringWithFormat:@"%@:%@ - %@:%@", fromHourStr, fromMinutesStr, toHourStr, toMinutesStr];
}


@end
