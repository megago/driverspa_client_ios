#import "ModelObject.h"


@interface ObjectImage : ModelObject {
}

@property (nonatomic, copy) NSString *relativeUrl;
@property (nonatomic, assign) CGFloat imageWidth;
@property (nonatomic, assign) CGFloat imageHeight;

+ (ObjectImage *)instanceFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;

- (NSString *)webUrl;
- (NSURL *)URL;


@end
