//
// Created by Almas Adilbek on 9/19/14.
// Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CarwashesHelper : NSObject

+ (NSArray *)sortCarwashesByDistance:(NSArray *)carwashes;

+ (NSArray *)carwashBoxTypes;
+ (NSArray *)carwashBoxTypeTitles;

@end