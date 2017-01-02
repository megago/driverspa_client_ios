#import "CarwashBook.h"
#import "ApiUtils.h"
#import "NSDate+Ext.h"
#import "IdTitleObject.h"
#import "CarwashRefs.h"
#import "Cache.h"
#import "Carwash.h"
#import "NSString+Ext.h"

@implementation CarwashBook

@synthesize boxId, cartype, carwash, clientKey, duration, endTime, finishTime, carwashBookId, price, resourceUri, services, startTime, status, time, client, discount, comment;

+ (CarwashBook *)instanceFromDictionary:(NSDictionary *)aDictionary {

    CarwashBook *instance = [[CarwashBook alloc] init];
    [instance setAttributesFromDictionary:aDictionary];
    return instance;

}

- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary {

    if (![aDictionary isKindOfClass:[NSDictionary class]]) {
        return;
    }

    objectData = aDictionary;

    self.boxId = [self stringValueForKey:@"box_id"];
    self.cartype = [self numberValueForKey:@"cartype"];
    self.carwash = [self stringValueForKey:@"carwash"];
    self.client = [self stringValueForKey:@"client"];
    self.clientKey = [self stringValueForKey:@"client_key"];
    self.duration = [self numberValueForKey:@"duration"];
    self.endTime = [self stringValueForKey:@"end_time"];
    self.finishTime = [self stringValueForKey:@"finish_time"];
    self.carwashBookId = [self stringValueForKey:@"id"];
    self.price = [self numberValueForKey:@"price"];
    self.resourceUri = [self stringValueForKey:@"resource_uri"];
    self.startTime = [self stringValueForKey:@"start_time"];
    self.status = [self stringValueForKey:@"status"];
    self.time = [self stringValueForKey:@"time"];
    self.time = [self.time stringByReplacingOccurrencesOfString:@"+00:00" withString:@""];
    self.services = [self arrayValueForKey:@"services"];
    self.carwashName = [self stringValueForKey:@"carwash_name"];
    self.discount = [self numberValueForKey:@"discount"];
    self.comment = [self stringValueForKey:@"comment"];
    
    self.ts = [self stringValueForKey:@"ts"];
    self.ts = [self.ts stringByReplacingOccurrencesOfString:@"+00:00" withString:@""];

    objectData = nil;

}

- (NSString *)localizedPrettyDate {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd/MM/yyyy в HH:mm"];
    return [df stringFromDate:[self localBookDate]];
}

- (NSString *)servicesTitles
{
    CarwashRefs *carwashRefs = [Cache carwashRefs];
    NSDictionary *serviceDictionary = [carwashRefs servicesDictionary];
    NSMutableArray *array = [NSMutableArray array];
    for(id serviceId in self.services) {
        IdTitleObject *obj = serviceDictionary[serviceId];
        [array addObject:obj.title];
    }
    return [array componentsJoinedByString:@", "];
}

- (NSString *)carTypeTitle
{
    CarwashRefs *carwashRefs = [Cache carwashRefs];
    NSDictionary *serviceDictionary = [carwashRefs carTypesDictionary];
    IdTitleObject *obj = serviceDictionary[self.cartype];
    return obj.title;
}

- (NSDate *)tsDate {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    return [df dateFromString:self.ts];
}


- (NSDate *)bookDate {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    return [df dateFromString:self.time];
}

- (NSDate *)localBookDate
{
    NSDate *date = [NSDate dateFromDefaultFormat:self.time];

    NSTimeInterval timeZoneSeconds = [[NSTimeZone localTimeZone] secondsFromGMT];
    return  [date dateByAddingTimeInterval:timeZoneSeconds];
}

- (NSString *)localizedBookDate
{
    NSDate *date = [self bookDate];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd.MM.yyyy"];
    return [df stringFromDate:date];
}

- (NSString *)bookTime
{
    NSDate *date = [self bookDate];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"HH:mm"];
    return [df stringFromDate:date];
}

- (NSString *)localBookTime
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"HH:mm"];
    return [df stringFromDate:[self localBookDate]];
}

- (NSString *)localizedDaysAgo
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitDay
                                               fromDate:[self localBookDate]
                                                 toDate:[NSDate date]
                                                options:0];
    NSString *str = [NSString stringWithFormat:@"%ld", components.day];
    NSString *lastChar = [str substringFromIndex:[str length] - 1];
    
    if ([lastChar isEqualToString:@"0"]) {
        return @"Сегодня";
    } else if ([lastChar isEqualToString:@"1"]) {
        return [NSString stringWithFormat:@"%ld день назад", components.day];
    } else if ([lastChar isEqualToString:@"2"] || [lastChar isEqualToString:@"3"] || [lastChar isEqualToString:@"4"]){
        return [NSString stringWithFormat:@"%ld дня назад", components.day];
    }
    return [NSString stringWithFormat:@"%ld дней назад", components.day];
}

- (NSString *)localizedPrice {
    return [NSString stringWithFormat:@"%@ тг.", [NSString numberFormattedNumberText:self.price]];
}

- (NSString *)localizedCarNumber {
    NSString *s = self.clientKey;
    NSRange r1 = [s rangeOfString:@"("];
    NSRange r2 = [s rangeOfString:@")"];
    NSRange rSub = NSMakeRange(r1.location + r1.length, r2.location - r1.location - r1.length);
    NSString *sub = [s substringWithRange:rSub];
    s = [s stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"(%@)", sub] withString:@""];
    return s;
}

- (BOOL)isPending {
    return [self.status isEqual:kBookStatusPending];
}

- (BOOL)isApproved {
    return [self.status isEqual:kBookStatusApproved];
}

- (BOOL)isFinished {
    return [self.status isEqual:kBookStatusFinished];
}

- (BOOL)isRejected {
    return [self.status isEqual:kBookStatusRejected];
}

- (BOOL)isStarted {
    return [self.status isEqual:kBookStatusStarted];
}

- (BOOL)isCancelled
{
    return [self.status isEqual:kBookStatusCancelled];
}

- (BOOL)isNoCome {
    return [self.status isEqual:kBookStatusNoCome];
}

- (NSString *)localizedStatus {
    if([self isPending]) {
        return @"Ожидает подтверждения";
    } else if([self isRejected]) {
        return @"Отменён администратором";
    } else if([self isFinished]) {
        return @"Завершен";
    } else if([self isApproved]) {
        return @"Услуга подтверждена";
    } else if([self isStarted]) {
        return @"В процессе";
    } else if([self isNoCome]) {
        return @"Клиент не явился";
    } else if([self isCancelled]) {
        return @"Отменён клиентом";
    }
    return @"";
}

- (NSString *)localizedAdminStatus {
    if([self isPending]) {
        return @"Ожидает";
    } else if([self isRejected]) {
        return @"Отклонен";
    } else if([self isFinished]) {
        return @"Завершен";
    } else if([self isApproved]) {
        return @"Одобрен";
    } else if([self isStarted]) {
        return @"В процессе";
    } else if([self isNoCome]) {
        return @"Клиент не явился";
    } else if([self isCancelled]) {
        return @"Отменён клиентом";
    }
    return @"";
}

@end
