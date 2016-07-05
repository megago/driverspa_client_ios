//
// Created by Almas Adilbek on 10/12/14.
// Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "BookmarksHelper.h"
#import "UserApi.h"
#import "Carwash.h"
#import "Cache.h"

@implementation BookmarksHelper {

}

+ (void)loadBookmarks {
    [UserApi bookmarks:^(id response) {
        // Cache bookmarks
        [Cache cacheUserLoadedBookmarks:response];

    } failure:^(NSInteger code, NSString *message) {

    }];
}

+ (void)carwashBookmarked:(NSString *)carwashId
{
    NSMutableDictionary *cachedBookmarks = [NSMutableDictionary dictionaryWithDictionary:[Cache cachedUserBookmarks]];
    cachedBookmarks[carwashId] = @"1";
    [Cache cacheUserBookmarks:cachedBookmarks];
}

+ (void)carwashBookmarkRemoved:(NSString *)carwashId {
    NSMutableDictionary *cachedBookmarks = [NSMutableDictionary dictionaryWithDictionary:[Cache cachedUserBookmarks]];
    [cachedBookmarks removeObjectForKey:carwashId];
    [Cache cacheUserBookmarks:cachedBookmarks];
}


+ (BOOL)isCarwashBookmarked:(NSString *)carwashId
{
    NSDictionary *cachedBookmarks = [Cache cachedUserBookmarks];
    return [cachedBookmarks[carwashId] isEqual:@"1"];
}

+ (BOOL)hasBookmarks {
    NSDictionary *bookmarks = [Cache cachedUserBookmarks];
    return bookmarks && [bookmarks allKeys].count > 0;
}


@end