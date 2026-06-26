#import "ModelObject.h"
#import "UserApi.h"

@class Carwash;
@class CarwashComplex;

#define kBookStatusFinished @"finished"
#define kBookStatusPending @"pending"
#define kBookStatusApproved @"approved"
#define kBookStatusRejected @"rejected"
#define kBookStatusStarted @"started"
#define kBookStatusCancelled @"canceled"
#define kBookStatusNoCome @"nocome"

@interface CarwashBook : ModelObject {

}

@property (nonatomic, copy) NSString *boxId;
@property (nonatomic, copy) NSNumber *cartype;
@property (nonatomic, copy) NSString *carwash;
@property (nonatomic, copy) NSString *client;
@property (nonatomic, copy) NSString *clientKey;
@property (nonatomic, copy) NSNumber *duration;
@property (nonatomic, copy) NSString *endTime;
@property (nonatomic, copy) NSString *finishTime;
@property (nonatomic, copy) NSString *carwashBookId;
@property (nonatomic, copy) NSNumber *price;
@property (nonatomic, copy) NSString *resourceUri;
@property (nonatomic, copy) NSArray *services;
@property (nonatomic, copy) NSString *startTime;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *carwashName;
@property (nonatomic, copy) NSString *ts;
@property (nonatomic, copy) NSNumber *discount;
@property (nonatomic, copy) NSString *comment;

@property (nonatomic, copy) NSString *groupMenuName;
@property (nonatomic, copy) NSArray *groupMenuServices;
@property (nonatomic, copy) NSArray *groupServices;
//@property (nonatomic, copy) NSArray *groupMenu;

+ (CarwashBook *)instanceFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;

- (NSString *)localizedPrettyDate;
- (NSString *)servicesTitles;
- (NSString *)goupServicesTitles;
- (NSString *)groupsTitlesArCarwash:(CarwashComplex *)carwash;

- (NSString *)carTypeTitle;

- (NSDate *)tsDate;
- (NSDate *)bookDate;
- (NSDate *)localBookDate;
- (NSString *)localizedBookDate;
- (NSString *)bookTime;
- (NSString *)localBookTime;
- (NSString *)localizedDaysAgo;

- (NSString *)localizedPrice;

- (NSString *)localizedCarNumber;

- (BOOL)isPending;
- (BOOL)isApproved;
- (BOOL)isFinished;
- (BOOL)isRejected;
- (BOOL)isStarted;
- (BOOL)isCancelled;
- (BOOL)isNoCome;

- (NSString *)localizedStatus;
- (NSString *)localizedAdminStatus;

@end
