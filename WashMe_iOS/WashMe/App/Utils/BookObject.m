//
//  BookObject.m
//  WashMe
//
//  Created by Almas Adilbek on 11/11/14.
//  Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

#import "BookObject.h"
#import "CarwashComplex.h"
#import "IdTitleObject.h"
#import "NSString+Ext.h"

@implementation BookObject

- (NSString *)localizedPrice {
    return [NSString stringWithFormat:@"%@ тг.", [NSString numberFormattedNumberText:self.price]];
}

- (NSString *)servicesTitles {
    NSMutableArray *array = [NSMutableArray array];
    for(IdTitleObject *obj in self.services) {
        [array addObject:obj.title];
    }
    return [array componentsJoinedByString:@", "];
}

- (NSString *)prettyTime {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy.MM.dd"];
    return [NSString stringWithFormat:@"%@ в %@", [df stringFromDate:self.bookDate], self.bookTime];
}


@end
