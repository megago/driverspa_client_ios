//
//  IdTitleObject.m
//  WashMe
//
//  Created by Almas Adilbek on 10/22/14.
//  Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

#import "IdTitleObject.h"

@implementation IdTitleObject

+ (id)instanceWithId:(id)objId title:(NSString *)objectTitle
{
    IdTitleObject *obj = [[IdTitleObject alloc] init];
    obj.objectId = objId;
    obj.title = objectTitle;
    return obj;
}

+ (id)instanceWithId:(id)objId title:(NSString *)objectTitle value:(NSString *)value {
    IdTitleObject *obj = [self instanceWithId:objId title:objectTitle];
    obj.value = value;
    return obj;
}

+ (id)instanceFromArray:(NSArray *)array
{
    IdTitleObject *instance = [[IdTitleObject alloc] init];
    instance.objectId = array[0];
    instance.title = array[1];
    return instance;
}

- (BOOL)isIntObjectIdEqual:(id)objId {
    return [self.objectId integerValue] == [objId integerValue];
}


@end
