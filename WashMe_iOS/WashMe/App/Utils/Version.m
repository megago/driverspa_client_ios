//
//  Version.m
//  HomeCredit
//
//  Created by Almas Adilbek on 2/4/14.
//  Copyright (c) 2014 Crystal Spring LLC. All rights reserved.
//

#import "Version.h"

@implementation Version

+(BOOL)isIpad {
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
}
+(BOOL)isIPhone5 {
    return ![self isIpad] && [[UIScreen mainScreen] bounds].size.height > 480;
}

+(float)iphone:(float)iphoneValue ipad:(float)ipadValue {
    return ![self isIpad]?iphoneValue:ipadValue;
}

+(float)iphone5:(float)iphone5Value iphone4:(float)iphone4Value {
    return [self isIPhone5]?iphone5Value:iphone4Value;
}

+(BOOL)iOS7 {
    return SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0");
}

+(float)iOS7:(float)ios7Value or:(float)orValue {
    return [self iOS7]?ios7Value:orValue;
}

+(float)iOS7StatusBarBottom {
    return [self iOS7:20 or:0];
}

+ (BOOL)iOS8 {
    return SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0");
}


@end
