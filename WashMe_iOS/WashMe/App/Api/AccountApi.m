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

+ (void)whatsappRequest:(NSString *)phoneNumber pushToken:(NSString *)pushToken email:(NSString *)email success:(success)success failure:(failure)failure
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"mobile"] = [phoneNumber phoneNumberPresentation];
    params[@"company_name"] = @"NA";
    if(pushToken.length > 0) params[@"push_token"] = pushToken;
    if(email.length > 0) params[@"email"] = email;

    [self POST:@"account/whatsapp_request/" body:[params JSONRepresentation] success:success failure:failure];
}

+ (void)whatsappStatus:(NSString *)token success:(success)success failure:(failure)failure
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"token"] = token;

    [self POST:@"account/whatsapp_status/" body:[params JSONRepresentation] success:success failure:failure];
}


@end
