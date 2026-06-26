//
//  ApiUtils.h
//  WashMe
//
//  Created by Almas Adilbek on 11/5/14.
//  Copyright (c) 2014 Almas Adilbek. All rights reserved.
//



@interface ApiUtils : NSObject

+ (NSArray *)responseToCarwashes:(id)response;
+ (NSArray *)responseToCarwashBooks:(id)response;
+ (NSArray *)responseToCarwashReviews:(id)response;
+ (NSArray *)responseArrayToIdTitleObjectsArray:(id)responseArray;
+ (NSArray *)responseImagesToImageBundles:(NSArray *)images;



@end
