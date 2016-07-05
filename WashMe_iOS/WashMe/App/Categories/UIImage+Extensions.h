//
//  UIImage+Extensions.h
//  Myth
//
//  Created by Almas Adilbek on 8/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extensions)

-(UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize;

+(UIImage *)imageWithName:(NSString *)imageName;
+(UIImage *)localizedImageWithName:(NSString *)imageName;
+(UIImage *)imageWithView:(UIView *)view;

@end
