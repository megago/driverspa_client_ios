//
//  AdminApi.m
//  WashMe
//
//  Created by Almas Adilbek on 10/26/14.
//  Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "AdminApi.h"
#import "CarwashApi.h"
#import "ApiUtils.h"
#import "NSObject+Json.h"
#import "CarwashComplex.h"
#import "CarwashBook.h"

@implementation AdminApi

+ (void)myCarwashes:(success)success failure:(failure)failure {
    [self GET:@"company_carwash" success:^(id response) {
        NSArray *objects = [response objectForKey:@"objects"];
        success([ApiUtils responseToCarwashes:objects]);
    } failure:failure];
}

+ (void)ordersAll:(success)success failure:(failure)failure {
    [self GET:@"company_booking" success:^(id response) {
        success([self responseToCompanyBooks:response[@"objects"]]);
    } failure:failure];
}

+ (void)ordersToday:(success)success failure:(failure)failure {
    [self GET:@"company_booking?day=today" success:^(id response) {
        success([self responseToCompanyBooks:response[@"objects"]]);
    } failure:failure];
}

+ (void)ordersTomorrow:(success)success failure:(failure)failure {
    [self GET:@"company_booking?day=tomorrow" success:^(id response) {
        success([self responseToCompanyBooks:response[@"objects"]]);
    } failure:failure];
}

+ (void)orderBook:(NSString *)bookId success:(success)success failure:(failure)failure
{
    [self GET:[NSString stringWithFormat:@"company_booking/%@", bookId] success:^(id response) {
        success([CarwashBook instanceFromDictionary:response]);
    } failure:failure];
}

+ (void)createCarwash:(NSDictionary *)params success:(success)success failure:(failure)failure {
    [self POST:@"company_carwash" body:[params JSONRepresentation] success:^(id response) {
        success([CarwashComplex instanceFromDictionary:response]);
    } failure:failure];
}

+ (void)updateCarwash:(NSString *)carwashId params:(NSDictionary *)params success:(success)success failure:(failure)failure {
    [self PATCH:[NSString stringWithFormat:@"company_carwash/%@", carwashId] body:[params JSONRepresentation] success:^(id response) {
        success([CarwashComplex instanceFromDictionary:response]);
    } failure:failure];
}

+ (void)getCarwashDetails:(NSString *)carwashID success:(success)success failure:(failure)failure {
    [self GET:[NSString stringWithFormat:@"company_carwash/%@", carwashID] success:^(id response) {
        success([CarwashComplex instanceFromDictionary:response]);
    } failure:failure];
}

#pragma mark -
#pragma mark Bookings

+ (void)rejectBook:(NSString *)bookId success:(success)success failure:(failure)failure
{
    [self POST:@"company_booking/reject" body:[@{@"id":bookId} JSONRepresentation] success:^(id response) {
        success(response);
    } failure:failure];
}

+ (void)approveBook:(NSString *)bookId success:(success)success failure:(failure)failure
{
    [self POST:@"company_booking/approve" body:[@{@"id":bookId} JSONRepresentation] success:^(id response) {
        success(response);
    } failure:failure];
}

+ (void)startBook:(NSString *)bookId success:(success)success failure:(failure)failure
{
    [self POST:@"company_booking/start" body:[@{@"id":bookId} JSONRepresentation] success:^(id response) {
        success(response);
    } failure:failure];
}

+ (void)finishBook:(NSString *)bookId success:(success)success failure:(failure)failure
{
    [self POST:@"company_booking/finish" body:[@{@"id":bookId} JSONRepresentation] success:^(id response) {
        success(response);
    } failure:failure];
}

+ (void)clientDidNotCome:(NSString *)bookId success:(success)success failure:(failure)failure
{
    [self POST:@"company_booking/nocome" body:[@{@"id":bookId} JSONRepresentation] success:^(id response) {
        success(response);
    } failure:failure];
}

#pragma mark - 
#pragma mark Reviews

+ (void)myReviews:(success)success failure:(failure)failure {
    [self GET:@"company_reviews" success:^(id response) {
        NSArray *objects = [response objectForKey:@"objects"];
        success([ApiUtils responseToCarwashReviews:objects]);
    } failure:failure];
}

#pragma mark -
#pragma mark Helper

+ (NSArray *)responseToCompanyBooks:(id)response
{
    NSMutableArray *books = [NSMutableArray array];
    for(NSDictionary *item in response) {
        [books addObject:[CarwashBook instanceFromDictionary:item]];
    }
    return books;
}

@end
