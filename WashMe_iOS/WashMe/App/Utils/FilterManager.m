//
//  FilterManager.m
//  WashMe
//
//  Created by Almas Adilbek on 4/25/16.
//  Copyright (c) 2016 Almas Adilbek. All rights reserved.
//

#import "FilterManager.h"
#import "ObjectiveSugar.h"
#import "IdTitleObject.h"

@implementation FilterManager

- (id)init {
    self = [super init];
    if(self) {

    }
    return self;
}

- (NSString *)comfortsString {
    if(!self.comforts) {
        return nil;
    }
    return [[self.comforts map:^id(IdTitleObject *object) {
        return object.objectId;
    }] componentsJoinedByString:@","];
}

- (void)reset {
    self.free = nil;
    self.working = nil;
    self.maxPrice = nil;
    self.comforts = nil;
    self.payments = nil;
    self.rating = nil;
    self.maxDistance = nil;
}


@end
