//
//  Cache.h
//  WashMe
//
//  Created by Almas Adilbek on 10/6/14.
//  Copyright (c) 2014 Almas Adilbek. All rights reserved.
//



#import "TMCache.h"

@class CarwashRefs;
@class CompanyCarwashRefs;

typedef void(^CacheObjectBlock)(id obj);

@interface Cache : TMCache

// Refs
+ (void)loadCarwashRefs:(CacheObjectBlock)block;
+ (void)loadCompanyRefs:(CacheObjectBlock)block;
+ (void)cacheCarwashRefs:(id)response;
+ (void)cacheCompanyRefs:(id)response;

+ (void)carwashRefs:(CacheObjectBlock)block;
+ (void)companyCarwashRefs:(CacheObjectBlock)block;

+ (CarwashRefs *)carwashRefs;
+ (CarwashRefs *)companyCarwashRefs;

// Bookmarks
+ (void)cacheUserLoadedBookmarks:(id)response;
+ (void)cacheUserBookmarks:(NSDictionary *)bookmarks;
+ (NSDictionary *)cachedUserBookmarks;

@end
