#import "ModelObject.h"

@interface CarwashVisits : ModelObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *carNumber;
@property (nonatomic, copy) NSString *carMark;
@property (nonatomic, copy) NSString *profileImageUrl;
@property (nonatomic, copy) NSNumber *finishedBooksCount;
@property (nonatomic, copy) NSNumber *rejectedByClientBooksCount;
@property (nonatomic, copy) NSNumber *nocomeBookCount;
@property (nonatomic, copy) NSDate   *lastFinishedBookDate;
@property (nonatomic, assign) BOOL   isRegistered;

+ (CarwashVisits *)instanceFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;

@end
