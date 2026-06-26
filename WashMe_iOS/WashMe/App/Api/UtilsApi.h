//
//  UtilsApi.h
//  WashMe
//
//  Created by Almas Adilbek on 11/14/14.
//  Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

#import "APIClient.h"

@interface UtilsApi : APIClient

+ (void)uploadImage:(UIImage *)image success:(success)success failure:(failure)failure;
+ (void)deleteImage:(NSString *)imageId success:(success)success failure:(failure)failure;
+ (void)aboutUs:(success)success failure:(failure)failure;

+ (NSArray *)responseToImageBundles:(id)response;

@end
