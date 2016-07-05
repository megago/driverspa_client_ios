//
//  AccountApi.m
//  WashMe
//
//  Created by Almas Adilbek on 9/8/14.
//  Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

#import "AccountApi.h"
#import "NSString+Ext.h"
#import "NSObject+Json.h"
#import "SSKeychain.h"
#import "User.h"

@implementation AccountApi

+ (void)register:(NSString *)phoneNumber companyName:(NSString *)companyName success:(success)success failure:(failure)failure
{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"mobile"] = [phoneNumber phoneNumberPresentation];

    // If company
    if(companyName) params[@"company_name"] = [companyName trim];

    [self POST:@"account/register" body:[params JSONRepresentation] success:success failure:failure];
}

+ (void)confirmRegistration:(NSString *)phoneNumber activationCode:(NSString *)code success:(success)success failure:(failure)failure
{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"mobile"] = [phoneNumber phoneNumberPresentation];
    params[@"activation_code"] = code;

    [self POST:@"account/activate" body:[params JSONRepresentation] success:^(id response) {
        success(response);
    } failure:failure];
}


@end
