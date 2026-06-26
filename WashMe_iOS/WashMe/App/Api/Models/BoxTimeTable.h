
#define kBoxTimeTableAvailableSign @"+"
#define kBoxTimeTableBusySign @"-"

@interface BoxTimeTable : NSObject {
    NSArray *slots;
    NSString *uid;
}

@property (nonatomic, copy) NSArray *slots;
@property (nonatomic, copy) NSString *uid;
@property(nonatomic, assign) NSInteger intervalMinutes;

+ (BoxTimeTable *)instanceFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;

@end
