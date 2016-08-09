//
//  CarsCollectionView.h
//  WashMe
//
//  Created by Almas Adilbek on 3/30/16.
//  Copyright (c) 2016 Almas Adilbek. All rights reserved.
//

@class Car;

@protocol CarsCollectionViewDelegate<NSObject>
@optional
- (void)CarsCollectionViewAddTapped;
- (void)CarsCollectionViewCarTapped:(Car *)car;
@end

@interface CarsCollectionView : UIView

@property(nonatomic, weak) id <CarsCollectionViewDelegate> delegate;

- (void)addAddButton;
- (void)addCar:(Car *)car;
- (void)addCars:(NSArray *)cars;
- (void)selectItemAtIndex : (NSInteger)index;
- (void)reloadData;

@end
