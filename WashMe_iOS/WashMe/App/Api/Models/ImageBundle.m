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

#pragma mark -
#pragma mark NSCoding

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        self.imagesId = [decoder decodeObjectForKey:@"imagesId"];
        self.original = [decoder decodeObjectForKey:@"original"];
        self.medium = [decoder decodeObjectForKey:@"medium"];
        self.small = [decoder decodeObjectForKey:@"small"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.imagesId forKey:@"imagesId"];
    [encoder encodeObject:self.original forKey:@"original"];
    [encoder encodeObject:self.medium forKey:@"medium"];
    [encoder encodeObject:self.small forKey:@"small"];
}

@end
