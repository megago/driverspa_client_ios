#import "UserObject.h"

@implementation UserObject

@synthesize avatar, carModel, carNumber, firstName, userObjectId, lastName, resourceUri, username;

+ (UserObject *)instanceFromDictionary:(NSDictionary *)aDictionary {

    UserObject *instance = [[UserObject alloc] init];
    [instance setAttributesFromDictionary:aDictionary];
    return instance;

}

- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary {

    if (![aDictionary isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    objectData = aDictionary;

    self.avatar = [self stringValueForKey:@"avatar"];
    self.carModel = [self stringValueForKey:@"car_model"];
    self.carNumber = [self stringValueForKey:@"car_number"];
    self.firstName = [self stringValueForKey:@"first_name"];
    self.userObjectId = [self stringValueForKey:@"id"];
    self.lastName = [self stringValueForKey:@"last_name"];
    self.resourceUri = [self stringValueForKey:@"resource_uri"];
    self.username = [self stringValueForKey:@"username"];
    
    objectData = nil;
    
}

- (NSString *)fio {
    return [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName];
}

@end
