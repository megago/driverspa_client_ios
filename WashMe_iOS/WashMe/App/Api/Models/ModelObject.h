//
//  ModelObject.h
//  Myth
//
//  Created by Almas Adilbek on 11/13/12.
//
//

#import <Foundation/Foundation.h>

@interface ModelObject : NSObject <NSCoding> {
    NSDictionary *objectData;
}

-(BOOL)isValid:(id)value;

-(id)idValueForKey:(NSString *)key;
-(NSString *)stringValueForKey:(NSString *)key;
-(NSNumber *)numberValueForKey:(NSString *)key;
-(NSDate *)dateValueForKey:(NSString *)key dateFormat:(NSString *)dateFormat;
-(BOOL)boolValueForKey:(NSString *)key;
-(NSInteger)intValueForKey:(NSString *)key;
-(float)floatValueForKey:(NSString *)key;
-(NSArray *)arrayValueForKey:(NSString *)key;

-(id)idValueFrom:(id)object forKey:(NSString *)key;
-(NSString *)stringValueFrom:(id)object forKey:(NSString *)key;
-(NSNumber *)numberValueFrom:(id)object forKey:(NSString *)key;
-(NSDate *)dateValueFrom:(id)object forKey:(NSString *)key dateFormat:(NSString *)dateFormat;
-(NSInteger)intValueFrom:(id)object forKey:(NSString *)key;
-(float)floatValueFrom:(id)object forKey:(NSString *)key;
-(BOOL)boolValueFrom:(id)object forKey:(NSString *)key;
-(NSArray *)arrayValueFrom:(id)object forKey:(NSString *)key;

-(void)traceParams;
-(void)logKey:(NSString *)key;

@end
