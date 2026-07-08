//
//  AccountApi.h
//  WashMe
//
//  Created by Almas Adilbek on 9/8/14.
//  Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

#import "APIClient.h"

@interface AccountApi : APIClient

+(void)register:(NSString *)phoneNumber companyName:(NSString *)companyName success:(success)success failure:(failure)failure;
+(void)confirmRegistration:(NSString *)phoneNumber activationCode:(NSString *)code success:(success)success failure:(failure)failure;

// WhatsApp login (mirrors Android DriverSpa client flow).
// Requests a short token + wa_link; success receives data{token, whatsapp_number, wa_link}.
+(void)whatsappRequest:(NSString *)phoneNumber pushToken:(NSString *)pushToken email:(NSString *)email success:(success)success failure:(failure)failure;
// Polls verification. While pending success receives data{verified:false}; once matched
// success receives the full user dictionary (with token = api_key + password_required).
+(void)whatsappStatus:(NSString *)token success:(success)success failure:(failure)failure;

@end
