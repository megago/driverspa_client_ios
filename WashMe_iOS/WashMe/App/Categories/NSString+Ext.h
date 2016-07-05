//
//  NSString+Ext.h
//  HomeCredit
//
//  Created by Almas Adilbek on 3/18/14.
//  Copyright (c) 2014 Crystal Spring LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Ext)

-(NSString *)trim;
-(BOOL)isNumeric;
-(BOOL)isPreciseNumeric;
-(NSString *)uppercaseFirstLetter;
- (NSDate *)dateWithDateFormat:(NSString *)dateFormat;

-(NSString *)phoneNumberPresentation;
-(NSString *)phoneNumberValidForCall;

+ (NSString *)base64String:(NSString *)str;

-(NSString *)formattedNumberText;
+(NSString *)formattedNumberText:(NSString *)numberStr;
+(NSString *)integerFormattedNumberText:(NSInteger)value;
+(NSString *)numberFormattedNumberText:(NSNumber *)value;

@end
