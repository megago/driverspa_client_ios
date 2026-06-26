#import <Foundation/Foundation.h>

@interface Language : NSObject {

    NSString *locale;
    NSString *name;

}

@property (nonatomic, copy) NSString *locale;
@property (nonatomic, copy) NSString *name;

+ (Language *)instanceFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;

+(Language *)languageWithLocale:(NSString *)locale name:(NSString *)name;

@end
