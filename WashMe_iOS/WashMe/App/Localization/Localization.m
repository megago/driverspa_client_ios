//
//  Localization.m
//  Myth
//
//  Created by Almas Adilbek on 12/13/12.
//
//

#define kLocaleKey @"lang"

#import "Language.h"
#import "Localization.h"

static NSString *_currentLocale;
static NSDictionary *_translations;

@implementation Localization

+(NSString *)currentLocale
{
    if(!_currentLocale) {
        _currentLocale = [[NSUserDefaults standardUserDefaults] valueForKey:kLocaleKey];
        if(!_currentLocale) _currentLocale = localeRU;
    }
    return _currentLocale;
}
+(NSString *)ISOLocale {
    NSString *locale = [self currentLocale];
    if([locale isEqual:localeKZ]) return @"KZ";
    if([locale isEqual:localeRU]) return @"RU";
    return @"KZ";
}

+(void)setLocale:(NSString *)locale
{
    if(![locale isEqual:_currentLocale] && _translations) {
        _translations = nil;
    }
    _currentLocale = locale;
    [[NSUserDefaults standardUserDefaults] setValue:locale forKey:kLocaleKey];
}

+(NSString *)ln:(NSString *)key {
    if(!_translations) {
        _translations = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"translation_%@", [self currentLocale]] ofType:@"plist"]];
    }
    return [_translations objectForKey:key]?[_translations objectForKey:key]:key;
}

+(NSString *)ln_uc:(NSString *)key {
    return [[self ln:key] uppercaseString];
}

+(NSString *)ln_semicolon:(NSString *)key {
    return [[self ln:key] stringByAppendingString:@":"];
}

+(BOOL)isCurrentLanguage:(Language *)language {
    return [self isLocale:language.locale];
}

+(BOOL)isLocale:(NSString *)locale {
    return [[self currentLocale] isEqual:locale];
}

#pragma mark -

+(NSArray *)languages {
    return @[
            [Language languageWithLocale:localeKZ name:@"Қазақша"],
            [Language languageWithLocale:localeRU name:@"Русский"],
            [Language languageWithLocale:localeEN name:@"English"]
    ];
}

#pragma mark -
#pragma mark System messages

+(NSDictionary *)systemMessageKeys {
    return @{
            @"The request timed out.":@"system_msg_request_timed_out"
    };
}

+(NSString *)systemMessageWithMessage:(NSString *)message {
    NSString *key = [Localization systemMessageKeys][message];
    return key?[Localization ln:key]:message;
}

@end
