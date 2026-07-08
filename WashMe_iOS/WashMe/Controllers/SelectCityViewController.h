//
//  SelectCityViewController.h
//  WashMe
//
//  Created by Ivan Korotkikh on 23.10.16.
//  Copyright © 2016 Almas Adilbek. All rights reserved.
//

#import "ScrollViewControllerOld.h"
@class City;
@protocol SelectCityViewControllerDelegate <NSObject>
- (void)changeCurrentCity:(City *)city;
@end

@interface SelectCityViewController : ScrollViewControllerOld
@property (nonatomic, assign) BOOL isModal;
@property (nonatomic, strong) NSArray *cities;
@property (nonatomic, weak) id <SelectCityViewControllerDelegate> delegate;
@end
