#import "EventNotification.h"

@implementation EventNotification

@synthesize eventNotificationId, text, ts, type;

+ (EventNotification *)instanceFromDictionary:(NSDictionary *)aDictionary {

    EventNotification *instance = [[EventNotification alloc] init];
    [instance setAttributesFromDictionary:aDictionary];
    return instance;

}

- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary {

    if (![aDictionary isKindOfClass:[NSDictionary class]]) {
        return;
    }

    objectData = aDictionary;

    self.eventNotificationId = [self stringValueForKey:@"id"];
    self.text = [self stringValueForKey:@"text"];
    if(self.text.length == 0) self.text = @"Нет сообщения";

    NSDictionary *attrs = objectData[@"attrs"];
    self.type = [self stringValueFrom:attrs forKey:@"type"];

    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    self.ts = [self stringValueForKey:@"ts"];
    self.date = [df dateFromString:self.ts];

    objectData = nil;

}


@end
