//
//  CarwashApi.h
//  WashMe
//
//  Created by Almas Adilbek on 9/16/14.
//  Copyright (c) 2014 Almas Adilbek. All rights reserved.
//



#import "APIClient.h"

@class City;
@class FilterManager;

typedef NS_ENUM(NSUInteger, CarwashBoxesTimeDay) {
    CarwashBoxesTimeDayToday,
    CarwashBoxesTimeDayTomorrow
};

@interface CarwashApi : APIClient

+ (void)getCarwashes:(success)success1 failure:(failure)failure1;

+ (void)getComplexCarwashes:(success)success1 failure:(failure)failure1;

+ (void)getCarwashes:(NSInteger)page filterManager:(FilterManager *)manager success:(success)success1 failure:(failure)failure1;
//+ (void)getCarwashes:(NSInteger)page free:(NSString *)free working:(NSString *)working maxPrice:(NSNumber *)maxPrice comforts:(NSString *)comforts payments:(NSString *)payments rating:(NSNumber *)rating maxDistance:(NSNumber *)maxDistance success:(success)success1 failure:(failure)failure1;

+ (void)getCarwashes:(NSInteger)page
                free:(NSString *)free
             working:(NSString *)working
            maxPrice:(NSNumber *)maxPrice
            comforts:(NSString *)comforts
            payments:(NSString *)payments
              rating:(NSNumber *)rating
         maxDistance:(NSNumber *)maxDistance
                city:(NSString *)city
              mobile:(NSString *)mobile
             success:(success)success failure:(failure)failure;

+ (void)getPublicCarwashes:(NSDictionary *)params success:(success)success failure:(failure)failure ;

+ (void)getCarwashDetails:(NSString *)carwashID success:(success)success failure:(failure)failure;
+ (void)getCarwashWithResource:(NSString *)resourceUri success:(success)success failure:(failure)failure;

+ (void)searchCarwashes:(NSString *)keyword success:(success)success failure:(failure)failure;

+ (void)addFeedback:(NSString *)text mark:(NSInteger)mark carwashId:(NSString *)carwashId success:(success)success failure:(failure)failure;
+ (void)timeTableWithCarwashId:(NSString *)carwashId day:(CarwashBoxesTimeDay)day success:(success)success failure:(failure)failure;
+ (void)ref:(success)success failure:(failure)failure;

// Admin

+ (void)uploadCarwashImage:(UIImage *)image carwashId:(NSString *)carwashId success:(success)success failure:(failure)failure;
+ (void)makeCarwash:(NSString *)carwashId public:(BOOL)isPublic success:(success)success failure:(failure)failure;

+ (void)createBoxForCarwash:(NSString *)carwashId bookingType:(NSString *)bookingType success:(success)success failure:(failure)failure;
+ (void)editBoxOfCarwash:(NSString *)carwashId boxId:(NSString *)boxId bookingType:(NSString *)bookingType success:(success)success failure:(failure)failure;
+ (void)deleteBoxOfCarwash:(NSString *)carwashId boxId:(NSString *)boxId success:(success)success failure:(failure)failure;

@end
