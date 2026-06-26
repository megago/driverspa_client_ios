//
//  Version.h
//  HomeCredit
//
//  Created by Almas Adilbek on 2/4/14.
//  Copyright (c) 2014 Crystal Spring LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

@interface Version : NSObject

+(BOOL)isIpad;
+(BOOL)isIPhone5;

+(float)iphone:(float)iphoneValue ipad:(float)ipadValue;
+(float)iphone5:(float)iphone5Value iphone4:(float)iphone4Value;

+(BOOL)iOS7;
+(float)iOS7:(float)ios7Value or:(float)orValue;
+(float)iOS7StatusBarBottom;

+(BOOL)iOS8;

@end
