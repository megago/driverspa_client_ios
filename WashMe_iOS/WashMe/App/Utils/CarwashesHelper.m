//
// Created by Almas Adilbek on 9/19/14.
// Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

#import "CarwashesHelper.h"
#import "Carwash.h"
#import "IdTitleObject.h"
#import "NSArray+ObjectiveSugar.h"


@implementation CarwashesHelper {

}

+ (NSArray *)sortCarwashesByDistance:(NSArray *)carwashes
{
    NSArray *sortedArray;
    sortedArray = [carwashes sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        long first = [(Carwash *)a distanceInMeters];
        long second = [(Carwash *)b distanceInMeters];
        return (NSComparisonResult) (first > second);
    }];
    return sortedArray;
}

+ (NSArray *)carwashBoxTypes
{
    NSArray *boxTypes = @[
                    [IdTitleObject instanceWithId:@"online" title:@"Онлайн"],
                    [IdTitleObject instanceWithId:@"offline" title:@"Оффлайн"],
                    [IdTitleObject instanceWithId:@"hybrid" title:@"Гибрид"]
            ];
    return boxTypes;
}

+ (NSArray *)carwashBoxTypeTitles
{
    NSMutableArray * titles = [NSMutableArray array];
    [[self carwashBoxTypes] each:^(IdTitleObject *object) {
        [titles addObject:object.title];
    }];
    return titles;
}


@end