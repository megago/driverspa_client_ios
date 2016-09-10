#import "CarwashReview.h"

@implementation CarwashReview

@synthesize carwash, mark, text, author, authorId;

+ (CarwashReview *)instanceFromDictionary:(NSDictionary *)aDictionary {

    CarwashReview *instance = [[CarwashReview alloc] init];
    [instance setAttributesFromDictionary:aDictionary];
    return instance;

}

- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary {

    if (![aDictionary isKindOfClass:[NSDictionary class]]) {
        return;
    }

    objectData = aDictionary;

    self.carwash = [self stringValueForKey:@"carwash"];
    self.mark = [self numberValueForKey:@"mark"];
    self.text = [self stringValueForKey:@"text"];
    self.author = [self stringValueForKey:@"author"];
    self.authorId = [self numberValueForKey:@"author"];

    objectData = nil;
}

#pragma mark -
#pragma mark NSCoding

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        self.carwash = [decoder decodeObjectForKey:@"carwash"];
        self.mark = [decoder decodeObjectForKey:@"mark"];
        self.text = [decoder decodeObjectForKey:@"text"];
        self.author = [decoder decodeObjectForKey:@"author"];
        self.authorId = [decoder decodeObjectForKey:@"authorId"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.carwash forKey:@"carwash"];
    [encoder encodeObject:self.mark forKey:@"mark"];
    [encoder encodeObject:self.text forKey:@"text"];
    [encoder encodeObject:self.author forKey:@"author"];
    [encoder encodeObject:self.authorId forKey:@"authorId"];
}

@end
