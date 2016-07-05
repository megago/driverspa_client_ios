//
// Created by Almas Adilbek on 9/8/14.
// Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

#import "InputTextField+Validation.h"
#import "UIHelper.h"
#import "NSString+Ext.h"


@implementation InputTextField (Validation)

-(BOOL)validate {
    if([self value].length == 0) {
        [self focus];
        return NO;
    }
    return YES;
}

-(BOOL)validatePhoneNumber
{
    NSString *value = [self validPhoneNumber];
    if(value.length == 0) {
        [self focus];
        [UIHelper showAlertWithMessageTitle:@"" message:@"Введите номер телефона"];
        return NO;
    }
    if(value.length != 10) {
        [self focus];
        [UIHelper showAlertWithMessageTitle:@"" message:@"Не корректный номер телефона"];
        return NO;
    }
    return YES;
}

-(BOOL)validateAmount
{
    NSString *value = [self value];
    if(value.length == 0 || [value isEqual:@"0"]) {
        [UIHelper showAlertWithMessageTitle:@"" message:@"Введите сумму"];
        [self focus];
        return NO;
    }

    if(![value isNumeric]) {
        [UIHelper showAlertWithMessageTitle:@"" message:@"Введите правильную сумму"];
        [self focus];
        return NO;
    }

    return YES;
}

-(BOOL)validateSMS
{
    return [self validateWithMessage:@"Введите СМС код отправленный на ваш номер телефона"];
}


-(BOOL)validatePassword
{
    if(![self validateWithMessage:@"Введите пароль"]) {
        return NO;
    }

    if([self value].length < 1) { // TODO: 8
        [UIHelper showAlertWithMessageTitle:@"" message:@"Пароль должен иметь минимум 8 символов"];
        [self focus];
        return NO;
    }

    return YES;
}

- (BOOL)validateNewPassword
{
    if(![self validateWithMessage:@"Введите правильный новый пароль"]) {
        return NO;
    }

    NSString *value = [self value];

    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^(?=.*?)([a-zA-Z0-9!@#$%^&*()_+|}{<>?”:);]){8,}" options:NSRegularExpressionCaseInsensitive error:nil];
    NSTextCheckingResult *match = [regex firstMatchInString:value options:0 range:NSMakeRange(0, [value length])];
    BOOL isMatch = match != nil;
    if(!isMatch) {
        [UIHelper showAlertWithMessage:@"Пароль не соответсвует стандарту. Введите новый пароль"];
        [self focus];
        return NO;
    }
    return YES;
}

- (BOOL)validateIin
{
    if(![self validate]) {
        [UIHelper showAlertWithMessage:@"Введите Ваш ИИН"];
        return NO;
    }

    if(![[self value] isNumeric]) {
        [UIHelper showAlertWithMessage:@"ИИН должен состоять только из чисел"];
        [self focus];
        return NO;
    }

    if([self value].length != 12) {
        [UIHelper showAlertWithMessage:@"Введен не правильный ИИН"];
        [self focus];
        return NO;
    }
    return YES;
}

- (BOOL)validateEmail
{
    NSString *emailRegex =
            @"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
                    @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
                    @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
                    @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
                    @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
                    @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
                    @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES[c] %@", emailRegex];
    if(![emailTest evaluateWithObject:[self value]]) {
        [UIHelper showAlertWithMessage:@"Введите корректный e-mail адрес"];
        [self focus];
        return NO;
    }

    return YES;
}


- (BOOL)validateWithMessage:(NSString *)message
{
    if(![self validate]) {
        [UIHelper showAlertWithMessage:message];
        return NO;
    }

    return YES;
}

#pragma mark -
#pragma mark Format corrections

- (NSString *)validPhoneNumber {
    NSString *value = [self value];
    value = [value stringByReplacingOccurrencesOfString:@"+7" withString:@""];
    value = [value stringByReplacingOccurrencesOfString:@"+" withString:@""];
    value = [value stringByReplacingOccurrencesOfString:@" " withString:@""];
    value = [value stringByReplacingOccurrencesOfString:@"(" withString:@""];
    value = [value stringByReplacingOccurrencesOfString:@")" withString:@""];

    return value;
}


@end