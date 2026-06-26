//
//  ModelObject.m
//  Myth
//
//  Created by Almas Adilbek on 11/13/12.
//
//

#import "ModelObject.h"

@implementation ModelObject

-(id)idValueForKey:(NSString *)key {
    return [self idValueFrom:objectData forKey:key];
}

-(NSString *)stringValueForKey:(NSString *)key {
    return [self stringValueFrom:objectData forKey:key];
}

-(NSNumber *)numberValueForKey:(NSString *)key {
    return [self numberValueFrom:objectData forKey:key];
}

-(NSDate *)dateValueForKey:(NSString *)key dateFormat:(NSString *)dateFormat {
    return [self dateValueFrom:objectData forKey:key dateFormat:dateFormat];
}

-(NSInteger)intValueForKey:(NSString *)key {
    return [self intValueFrom:objectData forKey:key];
}

-(float)floatValueForKey:(NSString *)key {
    return [self floatValueFrom:objectData forKey:key];
}

-(BOOL)boolValueForKey:(NSString *)key {
    return [objectData[key] boolValue];
}

-(NSArray *)arrayValueForKey:(NSString *)key {
    return [self arrayValueFrom:objectData forKey:key];
}

#pragma mark -

-(id)idValueFrom:(id)object forKey:(NSString *)key {
    [self logKey:key];
    id value = [object objectForKey:key];
    return [self isValid:value]?value:@"";
}

-(NSString *)stringValueFrom:(id)object forKey:(NSString *)key {
    [self logKey:key];
    id value = [object objectForKey:key];
    return [self isValid:value]?[NSString stringWithFormat:@"%@", value]:@"";
}

-(NSNumber *)numberValueFrom:(id)object forKey:(NSString *)key {
    [self logKey:key];
    NSNumber *value = [object objectForKey:key];
    return [self isValid:value]?value: @0;
}

-(NSDate *)dateValueFrom:(id)object forKey:(NSString *)key dateFormat:(NSString *)dateFormat
{
    [self logKey:key];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:dateFormat];
    NSDate *date = [df dateFromString:[object objectForKey:key]];
    return date;
}

-(NSInteger)intValueFrom:(id)object forKey:(NSString *)key {
    [self logKey:key];
    id value = [object objectForKey:key];
    return [self isValid:value]?[value intValue]:0;
}

-(float)floatValueFrom:(id)object forKey:(NSString *)key {
    [self logKey:key];
    id value = [object objectForKey:key];
    return [self isValid:value]?[value floatValue]:0;
}

-(BOOL)boolValueFrom:(id)object forKey:(NSString *)key {
    return [[object objectForKey:key] boolValue];
}

-(NSArray *)arrayValueFrom:(id)object forKey:(NSString *)key {
    [self logKey:key];
    id value = [object objectForKey:key];
    return [self isValid:value]?value:@[];
}

#pragma mark -

-(BOOL)isValid:(id)value {
    return (value && ![value isEqual:[NSNull null]]);
}

#pragma mark -

-(void)traceParams {
    NSLog(@"Trance Params methods not implemented");
}

-(void)logKey:(NSString *)key {
    if(NO) {
        NSLog(@"key: %@", key);
    }
}

@end
