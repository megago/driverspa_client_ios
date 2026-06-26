//
//  UIColor+Extensions.m
//  Kiwi.kz
//
//  Created by Almas Adilbek on 11/3/12.
//
//

#import "CarwashBook.h"

@implementation UIColor (Extensions)

+(UIColor *)fromRGB:(int)rgb {
    return [UIColor colorWithRed:((float)((rgb & 0xFF0000) >> 16))/255.0 green:((float)((rgb & 0xFF00) >> 8))/255.0 blue:((float)(rgb & 0xFF))/255.0 alpha:1.0];
}

- (UIColor *)lighterColor
{
    CGFloat h, s, b, a;
    if ([self getHue:&h saturation:&s brightness:&b alpha:&a])
        return [UIColor colorWithHue:h
                          saturation:s
                          brightness:MIN(b * 1.3, 1.0)
                               alpha:a];
    return nil;
}

- (UIColor *)darkerColor
{
    CGFloat h, s, b, a;
    if ([self getHue:&h saturation:&s brightness:&b alpha:&a])
        return [UIColor colorWithHue:h
                          saturation:s
                          brightness:b * 0.75
                               alpha:a];
    return nil;
}

+ (UIColor *)carwashBookStatusColor:(NSString *)status {
    if([status isEqual:kBookStatusPending]) return [UIColor orangeColor];
    else if([status isEqual:kBookStatusFinished]) return [UIColor darkGrayColor];
    else if([status isEqual:kBookStatusRejected]) return [UIColor fromRGB:0xC04155];
    else if([status isEqual:kBookStatusApproved]) return [UIColor fromRGB:0x4CD964];
    else if([status isEqual:kBookStatusStarted]) return [UIColor orangeColor];
    else if([status isEqual:kBookStatusCancelled]) return [UIColor darkGrayColor];
    else if([status isEqual:kBookStatusNoCome]) return [UIColor fromRGB:0xC04155];
    return [UIColor blackColor];
}

@end
