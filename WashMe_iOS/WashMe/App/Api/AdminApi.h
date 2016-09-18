//
//  AdminApi.h
//  WashMe
//
//  Created by Almas Adilbek on 10/26/14.
//  Copyright (c) 2014 Almas Adilbek. All rights reserved.
//



#import "APIClient.h"

@interface AdminApi : APIClient

+ (void)myCarwashes:(success)success failure:(failure)failure;
+ (void)ordersPending:(success)success failure:(failure)failure;
+ (void)ordersAll:(success)success failure:(failure)failure;
+ (void)ordersToday:(success)success failure:(failure)failure;
+ (void)ordersTomorrow:(success)success failure:(failure)failure;
+ (void)orderBook:(NSString *)bookId success:(success)success failure:(failure)failure;

+ (void)createCarwash:(NSDictionary *)params success:(success)success failure:(failure)failure;
+ (void)updateCarwash:(NSString *)carwashId params:(NSDictionary *)params success:(success)success failure:(failure)failure;

+ (void)getCarwashDetails:(NSString *)carwashID success:(success)success failure:(failure)failure;

// Bookings
+ (void)rejectBook:(NSString *)bookId success:(success)success failure:(failure)failure;
+ (void)approveBook:(NSString *)bookId success:(success)success failure:(failure)failure;
+ (void)startBook:(NSString *)bookId success:(success)success failure:(failure)failure;
+ (void)finishBook:(NSString *)bookId success:(success)success failure:(failure)failure;
+ (void)clientDidNotCome:(NSString *)bookId success:(success)success failure:(failure)failure;

// Reviews
+ (void)myReviews:(success)success failure:(failure)failure;

@end
