//
// Created by Almas Adilbek on 10/12/14.
// Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BookmarksHelper : NSObject

+(void)loadBookmarks;
+(void)carwashBookmarked:(NSString *)carwashId;
+(void)carwashBookmarkRemoved:(NSString *)carwashId;
+(BOOL)isCarwashBookmarked:(NSString *)carwashId;

+(BOOL)hasBookmarks;

@end