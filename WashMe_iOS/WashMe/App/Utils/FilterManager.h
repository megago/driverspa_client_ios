//
//  FilterManager.h
//  WashMe
//
//  Created by Almas Adilbek on 4/25/16.
//  Copyright (c) 2016 Almas Adilbek. All rights reserved.
//



@interface FilterManager : NSObject

@property(nonatomic, copy) NSString *free;
@property(nonatomic, copy) NSString *working;
@property(nonatomic, strong) NSNumber *maxPrice;
@property(nonatomic, strong) NSMutableArray *comforts;
@property(nonatomic, copy) NSString *payments;
@property(nonatomic, copy) NSNumber *rating;
@property(nonatomic, copy) NSNumber *maxDistance;

- (NSString *)comfortsString;
- (void)reset;

@end
