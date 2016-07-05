#import "ModelObject.h"


@interface CarwashReview : ModelObject {

    NSString *carwash;
    NSNumber *mark;
    NSString *text;
    NSString *author;
    NSNumber *authorId;

}

@property (nonatomic, copy) NSString *carwash;
@property (nonatomic, copy) NSNumber *mark;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *author;
@property (nonatomic, copy) NSNumber *authorId;

+ (CarwashReview *)instanceFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;

@end
