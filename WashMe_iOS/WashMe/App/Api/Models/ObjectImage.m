#import "ObjectImage.h"
#import "APIClient.h"

@implementation ObjectImage

@synthesize relativeUrl;

+ (ObjectImage *)instanceFromDictionary:(NSDictionary *)aDictionary {

    ObjectImage *instance = [[ObjectImage alloc] init];
    [instance setAttributesFromDictionary:aDictionary];
    return instance;

}

- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary {

    if (![aDictionary isKindOfClass:[NSDictionary class]]) {
        return;
    }

    if (aDictionary[@"url"])
    {
        self.relativeUrl = [self stringValueFrom:aDictionary forKey:@"url"];
    }
    else if (aDictionary[@"path"])
    {
        self.relativeUrl = [self stringValueFrom:aDictionary forKey:@"path"];
    }

    NSArray *receivedSize = [self arrayValueFrom:aDictionary forKey:@"size"];
    if(receivedSize.count == 2) {
        self.imageWidth = [receivedSize[0] floatValue];
        self.imageHeight = [receivedSize[1] floatValue];
    }
}

- (NSString *)webUrl {
    return [NSString stringWithFormat:@"%@%@", kApiBase, self.relativeUrl];
}

- (NSURL *)URL {
    return [NSURL URLWithString:[self webUrl]];
}

#pragma mark -
#pragma mark NSCoding

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        self.relativeUrl = [decoder decodeObjectForKey:@"relativeUrl"];
        self.imageWidth = [decoder decodeFloatForKey:@"imageWidth"];
        self.imageHeight = [decoder decodeFloatForKey:@"imageHeight"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.relativeUrl forKey:@"relativeUrl"];
    [encoder encodeFloat:self.imageWidth forKey:@"imageWidth"];
    [encoder encodeFloat:self.imageHeight forKey:@"imageHeight"];
    
}

@end
