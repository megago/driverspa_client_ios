//
//  AppUtils.m
//  WashMe
//
//  Created by Almas Adilbek on 10/6/14.
//  Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

#import <sys/utsname.h>
#import "AppUtils.h"

@implementation AppUtils

+ (NSString *)appVersion {
    return [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
}

+ (NSString *)deviceModel
{
    struct utsname systemInfo;
    uname(&systemInfo);
    return [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
}

+(BOOL)isAlmas {
    NSProcessInfo* pinfo = [NSProcessInfo processInfo];
    unsigned long long int memory = pinfo.physicalMemory;
//    NSLog(@"%qu", memory);
    return memory == 8589934592;
}

@end
