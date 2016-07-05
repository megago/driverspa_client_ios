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


@end
