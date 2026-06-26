#import "ModelObject.h"


@interface UserObject : ModelObject {

    NSString *avatar;
    NSString *carModel;
    NSString *carNumber;
    NSString *firstName;
    NSString *userObjectId;
    NSString *lastName;
    NSString *resourceUri;
    NSString *username;

}

@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *carModel;
@property (nonatomic, copy) NSString *carNumber;
@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *userObjectId;
@property (nonatomic, copy) NSString *lastName;
@property (nonatomic, copy) NSString *resourceUri;
@property (nonatomic, copy) NSString *username;

+ (UserObject *)instanceFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;

- (NSString *)fio;

@end
