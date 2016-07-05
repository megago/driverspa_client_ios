//
//  ApiUtils.m
//  WashMe
//
//  Created by Almas Adilbek on 11/5/14.
//  Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

#import "ApiUtils.h"
#import "IdTitleObject.h"
#import "Carwash.h"
#import "CarwashBook.h"
#import "ImageBundle.h"

@implementation ApiUtils

+ (NSArray *)responseToCarwashes:(id)response
{
    NSMutableArray * array = [NSMutableArray array];
    for(NSDictionary *o in response) {
        [array addObject:[Carwash instanceFromDictionary:o]];
    }
    return array;
}

+ (NSArray *)responseToCarwashBooks:(id)responseArray
{
    NSMutableArray * array = [NSMutableArray array];
    for(NSDictionary *o in responseArray) {
        [array addObject:[CarwashBook instanceFromDictionary:o]];
    }
    return array;
}


+ (NSArray *)responseArrayToIdTitleObjectsArray:(id)responseArray
{
    if ([responseArray isKindOfClass:[NSArray class]])
    {
        NSMutableArray *populatedServices = [NSMutableArray array];
        for (NSArray *array in responseArray) {
            if ([array isKindOfClass:[NSArray class]]) {
                [populatedServices addObject:[IdTitleObject instanceFromArray:array]];
            }
        }
        return populatedServices;
    } else {
        return @[];
    }
}

+ (NSArray *)responseImagesToImageBundles:(NSArray *)images
{
    NSMutableArray *populatedImages = [NSMutableArray array];
    for(NSDictionary *image in images) {
        [populatedImages addObject:[ImageBundle instanceFromDictionary:image]];
    }
    return populatedImages;
}


@end
