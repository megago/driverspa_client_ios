//
//  IdTitleObject.h
//  WashMe
//
//  Created by Almas Adilbek on 10/22/14.
//  Copyright (c) 2014 Almas Adilbek. All rights reserved.
//



@interface IdTitleObject : NSObject

@property(nonatomic, strong) id objectId;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, strong) id value;

+ (id)instanceWithId:(id)objId title:(NSString *)objectTitle;
+ (id)instanceWithId:(id)objId title:(NSString *)objectTitle value:(NSString *)value;
+ (id)instanceFromArray:(NSArray *)array;

- (BOOL)isIntObjectIdEqual:(id)objId;

@end
