#import "ModelObject.h"


@class ObjectImage;

@interface ImageBundle : ModelObject {

}

@property (nonatomic, copy) NSString *imagesId;
@property (nonatomic, strong) ObjectImage *original;
@property (nonatomic, strong) ObjectImage *medium;
@property (nonatomic, strong) ObjectImage *small;

+ (ImageBundle *)instanceFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;

@end
