//
//  CompanyApi.m
//  WashMe
//
//  Created by Almas Adilbek on 10/22/14.
//  Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

#import "CompanyApi.h"
#import "Cache.h"
#import "CompanyCarwashRefs.h"

@implementation CompanyApi

+(void)ref:(success)success failure:(failure)failure {
    [self GET:@"public_carwash/ref?format=json" success:^(id response) {
        [Cache cacheCompanyRefs:response];
        success([CompanyCarwashRefs instanceFromDictionary:response]);
    } failure:failure];
}

@end
