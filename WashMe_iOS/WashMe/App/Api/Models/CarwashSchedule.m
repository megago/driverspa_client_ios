#import <TMCache/TMCache.h>
#import "CarwashSchedule.h"
#import "SchedulePeriod.h"
#import "NSDate+Utilities.h"
#import "NSDate+Ext.h"

@implementation CarwashSchedule

@synthesize comment, fri, mon, sat, sun, thu, tue, wed;

+ (CarwashSchedule *)instanceFromDictionary:(NSDictionary *)aDictionary {

    CarwashSchedule *instance = [[CarwashSchedule alloc] init];
    [instance setAttributesFromDictionary:aDictionary];
    return instance;

}

- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary {

    if (![aDictionary isKindOfClass:[NSDictionary class]]) {
        return;
    }

    objectData = aDictionary;

    self.comment = [self stringValueForKey:@"comment"];

    self.mon = [self weekDayScheduleToArray:[self arrayValueForKey:@"mon"]];
    self.sat = [self weekDayScheduleToArray:[self arrayValueForKey:@"sat"]];
    self.sun = [self weekDayScheduleToArray:[self arrayValueForKey:@"sun"]];
    self.fri = [self weekDayScheduleToArray:[self arrayValueForKey:@"fri"]];
    self.thu = [self weekDayScheduleToArray:[self arrayValueForKey:@"thu"]];
    self.tue = [self weekDayScheduleToArray:[self arrayValueForKey:@"tue"]];
    self.wed = [self weekDayScheduleToArray:[self arrayValueForKey:@"wed"]];

    objectData = nil;

}

- (NSArray *)todaySchedules {
    NSInteger weekDay = [[NSDate date] weekDayOrdinal];
    switch (weekDay) {
        case 1: return self.mon;
        case 2: return self.tue;
        case 3: return self.wed;
        case 4: return self.thu;
        case 5: return self.fri;
        case 6: return self.sat;
        case 7: return self.sun;
        default:break;
    }
    return @[];
}

#pragma mark -
#pragma mark NSCoding

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        self.comment = [decoder decodeObjectForKey:@"comment"];
        self.fri = [decoder decodeObjectForKey:@"fri"];
        self.mon = [decoder decodeObjectForKey:@"mon"];
        self.sat = [decoder decodeObjectForKey:@"sat"];
        self.sun = [decoder decodeObjectForKey:@"sun"];
        self.thu = [decoder decodeObjectForKey:@"thu"];
        self.tue = [decoder decodeObjectForKey:@"tue"];
        self.wed = [decoder decodeObjectForKey:@"wed"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.comment forKey:@"comment"];
    [encoder encodeObject:self.fri forKey:@"fri"];
    [encoder encodeObject:self.mon forKey:@"mon"];
    [encoder encodeObject:self.sat forKey:@"sat"];
    [encoder encodeObject:self.sun forKey:@"sun"];
    [encoder encodeObject:self.thu forKey:@"thu"];
    [encoder encodeObject:self.tue forKey:@"tue"];
    [encoder encodeObject:self.wed forKey:@"wed"];
}

#pragma mark -
#pragma mark Helper

-(NSArray *)weekDayScheduleToArray:(NSArray *)received {
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *item in received) {
        [array addObject:[SchedulePeriod instanceFromDictionary:item]];
    }
    return array;
}

//#pragma mark -
//#pragma mark User cache
//
//+ (void)setAuthorizedCarwashSheduleData:(CarwashSchedule *)carwashSheduleData withMobile:(NSString *)_mobile
//{
//    [[TMCache sharedCache] setObject:(id)carwashSheduleData forKey:[self carwashScheduleDataCacheKeyWithMobile:_mobile]];
//}
//
//+ (CarwashSchedule *)authorizedCarwashScheduleDataWithMobile:(NSString *)_mobile {
//    id object = [[TMCache sharedCache] objectForKey:[self carwashScheduleDataCacheKeyWithMobile:_mobile]];
//    return object ? object : nil;
//}
//
//+ (void)clearAuthorizedCarwashSheduleDataWithMobile:(NSString *)_mobile {
//    [[TMCache sharedCache] removeObjectForKey:[self carwashScheduleDataCacheKeyWithMobile:_mobile]];
//}
//
//+ (NSString *)carwashScheduleDataCacheKeyWithMobile:(NSString *)_mobile {
//    _mobile = [_mobile stringByReplacingOccurrencesOfString:@"+" withString:@""];
//    return [NSString stringWithFormat:@"cachedCarwashScheduleObject_%@", _mobile];
//}

@end
