#import "ModelObject.h"
#import "Carwash.h"

@class CarwashSchedule;

@interface CarwashComplex : Carwash {

}

@property (nonatomic, strong) NSArray *additionalInfos;
@property (nonatomic, copy) NSArray *boxSettings;
@property (nonatomic, copy) NSArray *cartypes;
@property (nonatomic, copy) NSArray *contacts;
@property (nonatomic, copy) NSString *carwashId;
@property (nonatomic, copy) NSArray *payoptions;
@property (nonatomic, strong) NSArray *reviews;
@property (nonatomic, strong) CarwashSchedule *schedule;
@property (nonatomic, copy) NSArray *services;
@property (nonatomic, strong) NSDictionary *menu;

+ (CarwashComplex *)instanceFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;

- (NSString *)contactsMobilePhone;
- (NSString *)contactsWebsiteAlias;
- (NSString *)contactsWebsite;
- (NSString *)contactsEmail;

- (NSString *)boxNameById:(NSString *)uid;

+ (CarwashComplex *)cashedCarwash;

+ (void)setAuthorizedCarwashData:(CarwashComplex *)carwashData withMobile:(NSString *)_mobile;
+ (CarwashComplex *)authorizedCarwashDataWithMobile:(NSString *)_mobile;
+ (void)clearAuthorizedCarwashDataWithMobile:(NSString *)_mobile;

@end
