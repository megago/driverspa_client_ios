#import "Language.h"

@implementation Language

@synthesize locale, name;

+ (Language *)instanceFromDictionary:(NSDictionary *)aDictionary {

    Language *instance = [[Language alloc] init];
    [instance setAttributesFromDictionary:aDictionary];
    return instance;

}

- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary {

    if (![aDictionary isKindOfClass:[NSDictionary class]]) {
        return;
    }

    self.locale = [aDictionary objectForKey:@"locale"];
    self.name = [aDictionary objectForKey:@"name"];

}

+(Language *)languageWithLocale:(NSString *)locale name:(NSString *)name {
    Language *language = [[Language alloc] init];
    language.locale = locale;
    language.name = name;
    return language;
}


@end
