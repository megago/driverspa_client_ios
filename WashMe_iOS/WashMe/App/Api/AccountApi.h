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

@end
