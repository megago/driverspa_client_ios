#import "ImageBundle.h"

#import "ObjectImage.h"

@implementation ImageBundle

@synthesize imagesId, original;

+ (ImageBundle *)instanceFromDictionary:(NSDictionary *)aDictionary {

    ImageBundle *instance = [[ImageBundle alloc] init];
    [instance setAttributesFromDictionary:aDictionary];
    return instance;

}

- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary {

    if (![aDictionary isKindOfClass:[NSDictionary class]]) {
        return;
    }

    self.imagesId = [self stringValueFrom:aDictionary forKey:@"id"];
    self.original = [ObjectImage instanceFromDictionary:aDictionary[@"original"]];
    self.medium = [ObjectImage instanceFromDictionary:aDictionary[@"thumb1"]];
    self.small = [ObjectImage instanceFromDictionary:aDictionary[@"thumb2"]];
}


@end
