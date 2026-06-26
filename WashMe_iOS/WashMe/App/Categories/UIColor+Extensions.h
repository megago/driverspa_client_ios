//
//  UIColor+Extensions.h
//  Kiwi.kz
//
//  Created by Almas Adilbek on 11/3/12.
//
//

#import <UIKit/UIKit.h>

@interface UIColor (Extensions)

+(UIColor *)fromRGB:(int)rgb;

- (UIColor *)lighterColor;
- (UIColor *)darkerColor;

+ (UIColor *)carwashBookStatusColor:(NSString *)status;

@end
