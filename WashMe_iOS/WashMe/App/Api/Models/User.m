#import <TMCache/TMCache.h>
#import "User.h"
#import "SSKeychain.h"
#import "NSObject+Json.h"
#import "NSString+Ext.h"
#import "BookmarksHelper.h"
#import "ImageBundle.h"
#import "ApiUtils.h"
#import "UIActionSheet+Blocks.h"
#import "AppDelegate.h"
#import "UserSettings.h"
#import "NSArray+ObjectiveSugar.h"
#import "Car.h"
#import "City.h"
#import "Cache.h"
#import "CarwashRefs.h"
#import "CarwashComplex.h"

@implementation User

#define kAuthorizationService @"authorization"
#define kUserMobileKey @"userMobile"

static User *_user = nil;

@synthesize companyName, email, firstName, userId, images, isCompany, lastLogin, lastName, mobile, resourceUri, token, username, avatar, cityCode, cars;

+ (User *)currentUser {
    if(!_user) {
        _user = [[User alloc] init];
    }
    return _user;
}

+ (User *)instanceFromDictionary:(NSDictionary *)aDictionary {
    _user = [self currentUser];
    [_user setAttributesFromDictionary:aDictionary];
    return _user;
}

- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary {

    if (![aDictionary isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    objectData = aDictionary;

    self.userId = [self stringValueForKey:@"id"];
    self.mobile = [self stringValueForKey:@"mobile"];
    self.firstName = [self stringValueForKey:@"first_name"];
    self.lastName = [self stringValueForKey:@"last_name"];
    self.username = [self stringValueForKey:@"username"];
    self.email = [self stringValueForKey:@"email"];
    self.token = [self stringValueForKey:@"token"];
    self.avatar = [self stringValueForKey:@"avatar"];
    self.cityCode = [self stringValueForKey:@"city"];
    self.companyName = [self stringValueForKey:@"company_name"];
    self.resourceUri = [self stringValueForKey:@"resource_uri"];
    self.isCompany = [self boolValueForKey:@"is_company"];
    self.lastLogin = [self stringValueForKey:@"last_login"];

    self.images = [ApiUtils responseImagesToImageBundles:[self arrayValueForKey:[User imagesKey]]];

    // Cars
    NSArray *carsArray = [self arrayValueForKey:@"cars"];
    NSMutableArray * carsObjects = [NSMutableArray array];
    [carsArray each:^(id object) {
        [carsObjects addObject:[Car instanceFromDictionary:object]];
    }];
    self.cars = carsObjects;

    objectData = nil;
}

#pragma mark -
#pragma mark Defaults

+ (void)storeUserMobile:(NSString *)_mobile {
    [[NSUserDefaults standardUserDefaults] setValue:_mobile forKey:kUserMobileKey];
}

+ (NSString *)lastLoggedInUserMobile {
    return [[NSUserDefaults standardUserDefaults] stringForKey:kUserMobileKey];
}

#pragma mark -
#pragma mark Token

+ (void)storeTokenInKeychain:(NSString *)_token forMobile:(NSString *)_mobile {
    [SSKeychain setPassword:_token forService:kAuthorizationService account:_mobile];
}

+ (NSString *)authorizedTokenWithMobile:(NSString *)_mobile {
    NSString *_token = [SSKeychain passwordForService:kAuthorizationService account:_mobile];
    return _token;
}

- (NSString *)authorizedToken {
    return [User authorizedTokenWithMobile:self.mobile];
}

#pragma mark -
#pragma mark User cache

+ (void)setAuthorizedUserData:(NSDictionary *)userData withMobile:(NSString *)_mobile
{
    // Hide token
    NSMutableDictionary *mutableUserData = [NSMutableDictionary dictionaryWithDictionary:userData];
    mutableUserData[@"token"] = @"";

    [[TMCache sharedCache] setObject:[mutableUserData JSONRepresentation] forKey:[self userdataCacheKeyWithMobile:_mobile]];
}

+ (NSDictionary *)authorizedUserDataWithMobile:(NSString *)_mobile {
    id object = [[TMCache sharedCache] objectForKey:[self userdataCacheKeyWithMobile:_mobile]];
    return object ? [object JSONValue] : nil;
}

+ (void)clearAuthorizedUserDataWithMobile:(NSString *)_mobile {
    [[TMCache sharedCache] removeObjectForKey:[self userdataCacheKeyWithMobile:_mobile]];
}

/**
* Update user object cached data's attribute with name
*/
+ (void)updateUserDataAttribute:(id)obj forAttributeName:(NSString *)attrName {
    if([User isAuthorized]) {
        NSString *mobile = [[User currentUser] mobile];
        NSDictionary *userData = [self authorizedUserDataWithMobile:mobile];
        if(userData) {
            NSMutableDictionary *mutableUserData = [userData mutableCopy];
            mutableUserData[attrName] = obj;

            [self setAuthorizedUserData:mutableUserData withMobile:mobile];
        }
    }
}

+ (NSString *)userdataCacheKeyWithMobile:(NSString *)_mobile {
    _mobile = [_mobile stringByReplacingOccurrencesOfString:@"+" withString:@""];
    return [NSString stringWithFormat:@"cachedUserObject_%@", _mobile];
}

#pragma mark -
#pragma mark Methods

+ (BOOL)isAuthorized {
    NSString *_mobile = [User lastLoggedInUserMobile];
    if(_mobile) {
        NSString *_token = [User authorizedTokenWithMobile:_mobile];
        if(_token) {
            NSDictionary *userData = [User authorizedUserDataWithMobile:_mobile];
            if(userData) {
                return YES;
            }
        }
    }
    return NO;
}

+ (void)setRegistrationProfileEntered:(NSString *)mobile {
    [self setRegistrationProfileEntered:mobile status:YES];
}

+ (void)setRegistrationProfileEntered:(NSString *)mobile status:(BOOL)status {
    [[NSUserDefaults standardUserDefaults] setBool:status forKey:[NSString stringWithFormat:@"isRegistrationProfileEntered_%@", mobile]];
}

+ (BOOL)isRegistrationProfileEntered:(NSString *)mobile {
    return [[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"isRegistrationProfileEntered_%@", mobile]];
}

+ (BOOL)login
{
    if([self isAuthorized])
    {
        NSString *_mobile = [User lastLoggedInUserMobile];

        NSDictionary *userData = [User authorizedUserDataWithMobile:_mobile];

        // Instantiate user singleton object
        [User instanceFromDictionary:userData];
        [[User currentUser] setToken:[[User currentUser] authorizedToken]];

        // Load initial data
        if([UserSettings isAdmin]) {
            // Load company
        } else {
            [BookmarksHelper loadBookmarks];
        }

        return YES;
    }
    return NO;
}

- (void)logout {
    _user = nil;
    [User setRegistrationProfileEntered:self.mobile status:NO];
    [User clearAuthorizedUserDataWithMobile:self.mobile];
    [CarwashComplex clearAuthorizedCarwashDataWithMobile:self.mobile];
    [SSKeychain deletePasswordForService:kAuthorizationService account:self.mobile];
}

- (void)logoutQuestion:(UIActionSheetCompletionBlock)block
{
    NSString *fio = [[User currentUser] fio];
    NSString *question = fio.length > 0 ? [NSString stringWithFormat:@"%@, выйти из учетной записи?", fio] : @" Выйти из учетной записи?";
    [UIActionSheet showInView:[UIHelper delegateWindow] withTitle:question cancelButtonTitle:@"Отмена" destructiveButtonTitle:@"Выйти" otherButtonTitles:nil tapBlock:block];
}

- (NSString *)fio {
    return [[NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName] trim];
}

- (City *)city {
    return [[Cache carwashRefs].cities detect:^BOOL(City *object) {
        return [object.code isEqual:self.cityCode];
    }];
}


+ (NSString *)imagesKey {
    return @"images";
}

@end
