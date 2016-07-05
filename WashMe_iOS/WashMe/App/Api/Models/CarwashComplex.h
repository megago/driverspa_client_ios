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

+ (Carwash *)instanceFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;

-(NSString *)contactsMobilePhone;
- (NSString *)contactsWebsiteAlias;
- (NSString *)contactsWebsite;
- (NSString *)contactsEmail;

@end
