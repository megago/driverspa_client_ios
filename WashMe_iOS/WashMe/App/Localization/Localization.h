//
//  Localization.h
//  Myth
//
//  Created by Almas Adilbek on 12/13/12.
//
//

#import <Foundation/Foundation.h>
#import "LocalizationConstants.h"

@class Language;

@interface Localization : NSObject {
    
}

/**
 *  Получить выбранный язык
 *
 *  @return выбранный язык в формате kk, ru
 */
+(NSString *)currentLocale;

/**
 *  Получить выбранный язык
 *
 *  @return выбранный язык в формате KZ, RU
 */
+(NSString *)ISOLocale;

/**
 *  Определить выбранный язык
 *
 *  @param locale
 */
+(void)setLocale:(NSString *)locale;

/**
 *  Получить переведенную строку
 *
 *  @param key макро строки
 *
 *  @return переведенная строка
 */
+(NSString *)ln:(NSString *)key;

/**
 *  Получить переведенную строку, показать с заглавной буквой
 *
 *  @param key макро строки
 *
 *  @return переведенная строка
 */
+(NSString *)ln_uc:(NSString *)key;

/**
 *  Получить переведенную строку, звять ее в кавычки
 *
 *  @param key макро строки
 *
 *  @return переведенная строка
 */
+(NSString *)ln_semicolon:(NSString *)key;

/**
 *  Проверить текущий язык
 *
 *  @param language текущий язык
 *
 *  @return YES если текущий язык выбран
 */
+(BOOL)isCurrentLanguage:(Language *)language;

/**
 *  Проверить текущий язык в формате kk, ru
 *
 *  @param language текущий язык
 *
 *  @return YES если текущий язык выбран
 */
+(BOOL)isLocale:(NSString *)locale;

/**
 *  Получить массив всех возможных языков
 *
 *  @return массив языков
 */
+(NSArray *)languages;

+(NSDictionary *)systemMessageKeys;
+(NSString *)systemMessageWithMessage:(NSString *)message;

@end