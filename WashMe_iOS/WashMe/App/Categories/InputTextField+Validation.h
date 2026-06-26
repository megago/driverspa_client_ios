//
// Created by Almas Adilbek on 9/8/14.
// Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InputTextField.h"

@interface InputTextField (Validation)

- (BOOL)validate;

- (BOOL)validatePhoneNumber;
- (BOOL)validateAmount;
- (BOOL)validateSMS;
- (BOOL)validatePassword;
- (BOOL)validateNewPassword;
- (BOOL)validateIin;
- (BOOL)validateEmail;

- (BOOL)validateWithMessage:(NSString *)message;

// Format corrections
- (NSString *)validPhoneNumber;

@end