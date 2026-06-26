#import "ModelObject.h"


@interface EventNotification : ModelObject {

    NSString *eventNotificationId;
    NSString *text;
    NSString *ts;
    NSString *type;
    NSDate *date;

}

@property (nonatomic, copy) NSString *eventNotificationId;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *ts;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSDate *date;

+ (EventNotification *)instanceFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;

@end
