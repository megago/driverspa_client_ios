#import <UIActionSheet+Blocks/UIActionSheet+Blocks.h>
#import "ModelObject.h"

@class City;


@interface User : ModelObject {
}

@property (nonatomic, copy) NSString *companyName;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSArray *images;
@property (nonatomic, assign) BOOL isCompany;
@property (nonatomic, copy) NSString *lastLogin;
@property (nonatomic, copy) NSString *lastName;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *resourceUri;
@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *cityCode;
@property (nonatomic, strong) NSArray *cars;

+ (User *)instanceFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;

+ (User *)currentUser;

+ (void)storeUserMobile:(NSString *)_mobile;
+ (NSString *)lastLoggedInUserMobile;

+ (void)storeTokenInKeychain:(NSString *)_token forMobile:(NSString *)_mobile;
+ (NSString *)authorizedTokenWithMobile:(NSString *)_mobile;
- (NSString *)authorizedToken;

+ (void)setAuthorizedUserData:(NSDictionary *)userData withMobile:(NSString *)_mobile;
+ (void)clearAuthorizedUserDataWithMobile:(NSString *)_mobile;
+ (NSDictionary *)authorizedUserDataWithMobile:(NSString *)_mobile;
+ (void)updateUserDataAttribute:(id)obj forAttributeName:(NSString *)attrName;

+ (BOOL)isAuthorized;
+ (void)setRegistrationProfileEntered:(NSString *)mobile;
+ (void)setRegistrationProfileEntered:(NSString *)mobile status:(BOOL)status;

+ (BOOL)isRegistrationProfileEntered:(NSString *)mobile;

+ (BOOL)login;
- (void)logout;
- (void)logoutQuestion:(UIActionSheetCompletionBlock)block;

- (NSString *)fio;
- (City *)city;

// Attribute names
+ (NSString *)imagesKey;

@end
