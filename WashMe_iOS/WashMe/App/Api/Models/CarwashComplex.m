#import <TMCache/TMCache.h>
#import "NSObject+Json.h"
#import "User.h"
#import "BoxSetting.h"
#import "CarwashContact.h"
#import "CarwashSchedule.h"
#import "CarwashComplex.h"
#import "CarwashReview.h"
#import "CarwashMenuItem.h"

@implementation CarwashComplex

@synthesize additionalInfos, boxSettings, cartypes, contacts, reviews, schedule, services;

+ (CarwashComplex *)instanceFromDictionary:(NSDictionary *)aDictionary {

    CarwashComplex *instance = [[CarwashComplex alloc] init];
    [instance setAttributesFromDictionary:aDictionary];
    return instance;

}

- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary {

    if (![aDictionary isKindOfClass:[NSDictionary class]]) {
        return;
    }

    [super setAttributesFromDictionary:aDictionary];

    objectData = aDictionary;

    self.additionalInfos = [self arrayValueForKey:@"additional_info"];
    self.schedule = [CarwashSchedule instanceFromDictionary:aDictionary[@"schedule"]];
    self.cartypes = [self arrayValueForKey:@"cartypes"];
    self.services = [self arrayValueForKey:@"services"];
    self.payoptions = [self arrayValueForKey:@"payoptions"];

    NSArray *receivedReviews = aDictionary[@"reviews"];
    if ([receivedReviews isKindOfClass:[NSArray class]])
    {
        NSMutableArray *populatedReviews = [NSMutableArray array];
        for (NSDictionary *item in receivedReviews) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [populatedReviews addObject:[CarwashReview instanceFromDictionary:item]];
            }
        }
        self.reviews = populatedReviews;
    } else {
        self.reviews = @[];
    }

    NSArray *receivedBoxSettings = aDictionary[@"box_settings"];
    if ([receivedBoxSettings isKindOfClass:[NSArray class]])
    {
        NSMutableArray *populatedBoxSettings = [NSMutableArray array];
        for (NSDictionary *item in receivedBoxSettings) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [populatedBoxSettings addObject:[BoxSetting instanceFromDictionary:item]];
            }
        }
        self.boxSettings = populatedBoxSettings;
    } else {
        self.boxSettings = @[];
    }

    NSArray *receivedContacts = aDictionary[@"contacts"];
    if ([receivedContacts isKindOfClass:[NSArray class]])
    {
        NSMutableArray *populatedContacts = [NSMutableArray array];
        for (NSDictionary *item in receivedContacts) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [populatedContacts addObject:[CarwashContact instanceFromDictionary:item]];
            }
        }
        self.contacts = populatedContacts;
    } else {
        self.contacts = @[];
    }

    // Menu
    NSDictionary *receivedMenu = aDictionary[@"menu"];
    NSMutableDictionary *menuDictionary = [NSMutableDictionary dictionary];
    for(NSString *key in receivedMenu) {
        NSMutableDictionary *pricesDictionary = [NSMutableDictionary dictionary];
        NSArray *prices = receivedMenu[key];
        if(prices) {
            for(NSDictionary *o in prices) {
                CarwashMenuItem *menuItem = [CarwashMenuItem instanceFromDictionary:o];
                pricesDictionary[menuItem.type] = menuItem;
            }
            menuDictionary[key] = pricesDictionary;
        }
    }
    self.menu = menuDictionary;

    objectData = nil;
}

- (NSString *)contactsMobilePhone {
    for(CarwashContact *contact in self.contacts) {
        if([contact.type isEqual:@"phone"]) {
            return contact.value;
        }
    }
    return @"";
}

- (NSString *)contactsWebsiteAlias {
    for(CarwashContact *contact in self.contacts) {
        if([contact.type isEqual:@"website"]) {
            return contact.alias.length > 0 ? contact.alias : contact.value;
        }
    }
    return @"";
}

- (NSString *)contactsWebsite {
    for(CarwashContact *contact in self.contacts) {
        if([contact.type isEqual:@"website"]) {
            return contact.value;
        }
    }
    return @"";
}

- (NSString *)contactsEmail {
    for(CarwashContact *contact in self.contacts) {
        if([contact.type isEqual:@"email"]) {
            return contact.alias.length > 0 ? contact.alias : contact.value;
        }
    }
    return @"";
}

- (NSString *)boxNameById:(NSString *)uid {
    for (BoxSetting *setting in self.boxSettings){
        if ([setting.uid isEqual:uid]){
            return setting.boxName;
        }
    }
    return @"";
}

#pragma mark -
#pragma mark User cache

+ (void)setAuthorizedCarwashData:(CarwashComplex *)carwashData withMobile:(NSString *)_mobile
{
    [[TMCache sharedCache] setObject:(id)carwashData forKey:[self carwashdataCacheKeyWithMobile:_mobile]];
}

+ (CarwashComplex *)authorizedCarwashDataWithMobile:(NSString *)_mobile {
    id object = [[TMCache sharedCache] objectForKey:[self carwashdataCacheKeyWithMobile:_mobile]];
    return object ? object : nil;
}

+ (void)clearAuthorizedCarwashDataWithMobile:(NSString *)_mobile {
    [[TMCache sharedCache] removeObjectForKey:[self carwashdataCacheKeyWithMobile:_mobile]];
}

+ (NSString *)carwashdataCacheKeyWithMobile:(NSString *)_mobile {
    _mobile = [_mobile stringByReplacingOccurrencesOfString:@"+" withString:@""];
    return [NSString stringWithFormat:@"cachedCarwashObject_%@", _mobile];
}

@end
