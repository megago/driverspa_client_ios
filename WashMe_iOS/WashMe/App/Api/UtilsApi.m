//
//  UtilsApi.m
//  WashMe
//
//  Created by Almas Adilbek on 11/14/14.
//  Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

#import "UtilsApi.h"
#import "NSObject+Json.h"
#import "ApiUtils.h"
#import "ImageBundle.h"

@implementation UtilsApi

+ (void)uploadImage:(UIImage *)image success:(success)success failure:(failure)failure
{
    NSData *imageData = UIImageJPEGRepresentation(image, 0.8);
    [self POST:@"image_upload/new" uploadImage:imageData dataName:@"image" parameters:nil success:^(id response) {
        success([ImageBundle instanceFromDictionary:response]);
    } failure:failure];
}

+ (void)deleteImage:(NSString *)imageId success:(success)success failure:(failure)failure {
    [self POST:[NSString stringWithFormat:@"image_upload/delete/%@", imageId] success:^(id response) {
        success(response);
    } failure:failure];
}

+ (void)aboutUs:(success)success failure:(failure)failure {
    [self GET:@"about_us/html" success:^(id response) {
        NSString *object = [response objectForKey:@"about_us"];
        success(object);
    } failure:failure];
}

#pragma mark -
#pragma mark Helper

+ (NSArray *)responseToImageBundles:(id)response {
    if(response && [response isKindOfClass:[NSArray class]]) {
        NSMutableArray *images = [NSMutableArray array];
        for(NSDictionary *item in response) {
            [images addObject:[ImageBundle instanceFromDictionary:item]];
        }
        return images;
    } else {
        return @[];
    }
}


@end
