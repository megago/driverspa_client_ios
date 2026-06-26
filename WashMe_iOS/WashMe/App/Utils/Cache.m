//
//  Cache.m
//  WashMe
//
//  Created by Almas Adilbek on 10/6/14.
//  Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

#import "Cache.h"
#import "CarwashRefs.h"
#import "Toast.h"
#import "CarwashApi.h"
#import "Carwash.h"
#import "CompanyApi.h"
#import "CompanyCarwashRefs.h"
#import "NSObject+Json.h"

#define kCarwashRefsKey @"carwashRefs"
#define kCompanyRefsKey @"companyRefs"
#define kUserBookmarks @"userBookmarks"

@implementation Cache

#pragma mark -
#pragma mark Refs

+ (void)loadCarwashRefs:(CacheObjectBlock)block
{
    id refs = [self carwashRefsDictionary];
    if(!refs) {
        [Toast showHudLoading];
    }
    [CarwashApi ref:^(id response) {
        if(block) block(response);
    } failure:^(NSInteger code, NSString *message) {

    }];
}

+ (void)loadCompanyRefs:(CacheObjectBlock)block
{
    id refs = [self companyCarwashRefsDictionary];
    if(!refs) {
        [Toast showHudLoading];
    }
    [CompanyApi ref:^(id response) {
        if(block) block(response);
    } failure:^(NSInteger code, NSString *message) {

    }];
}

+ (void)cacheCarwashRefs:(id)response {
    [[self sharedCache] setObject:response forKey:kCarwashRefsKey];
}

+ (void)cacheCompanyRefs:(id)response {
    [[self sharedCache] setObject:response forKey:kCompanyRefsKey];
}


+ (void)carwashRefs:(CacheObjectBlock)block {
    NSDictionary *refsDic = [self carwashRefsDictionary];
    if(refsDic) {
        block([CarwashRefs instanceFromDictionary:refsDic]);
    } else {
        [self loadCarwashRefs:block];
    }
}

+ (void)companyCarwashRefs:(CacheObjectBlock)block {
    NSDictionary *refsDic = [self companyCarwashRefsDictionary];
    if(refsDic) {
        block([CompanyCarwashRefs instanceFromDictionary:refsDic]);
    } else {
        [self loadCompanyRefs:block];
    }
}

+ (CarwashRefs *)carwashRefs {
    NSDictionary *refs = [self carwashRefsDictionary];
    if(refs) {
        return [CarwashRefs instanceFromDictionary:refs];
    }
    return nil;
}

+ (CarwashRefs *)companyCarwashRefs {
    NSDictionary *refs = [self companyCarwashRefsDictionary];
    if(refs) {
        return [CarwashRefs instanceFromDictionary:refs];
    }
    return nil;
}

+(NSDictionary *)carwashRefsDictionary {
    return [[self sharedCache] objectForKey:kCarwashRefsKey];
}

+(NSDictionary *)companyCarwashRefsDictionary {
    return [[self sharedCache] objectForKey:kCompanyRefsKey];
}


#pragma mark -
#pragma mark Bookmarks

+ (void)cacheUserLoadedBookmarks:(id)response
{
    NSMutableDictionary *o = [NSMutableDictionary dictionary];
    for(Carwash *carwash in response) {
        o[carwash.carwashId] = @"1";
    }
    [self cacheUserBookmarks:o];
}

+ (void)cacheUserBookmarks:(NSDictionary *)bookmarks {
    [[TMCache sharedCache] setObject:bookmarks forKey:kUserBookmarks];
}

+ (NSDictionary *)cachedUserBookmarks {
    NSDictionary *bookmarks = [[TMCache sharedCache] objectForKey:kUserBookmarks];
    return bookmarks ? bookmarks : @{};
}


@end
