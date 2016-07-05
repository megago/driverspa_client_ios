//
//  CarsCollectionView.m
//  WashMe
//
//  Created by Almas Adilbek on 3/30/16.
//  Copyright (c) 2016 Almas Adilbek. All rights reserved.
//

#import "CarsCollectionView.h"
#import "ALView+PureLayout.h"
#import "NSMutableArray+ObjectiveSugar.h"
#import "UIView+ConcisePureLayout.h"
#import "CarsCollectionCell.h"
#import "AddCarCollectionCell.h"
#import "CarCollectionCell.h"
#import "Car.h"

#define kHeight 70

@interface CarsCollectionView()<UICollectionViewDelegate, UICollectionViewDataSource>
@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, strong) NSMutableArray *items;
@end

@implementation CarsCollectionView

- (id)init {
    self = [super init];
    if(self) {

        [self aa_setHeight:kHeight];

        self.items = [[NSMutableArray alloc] init];

        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.sectionInset = UIEdgeInsetsMake(0, kViewControllerPadding, 0, kViewControllerPadding);
        layout.minimumInteritemSpacing = 5;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;

        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.alwaysBounceHorizontal = YES;
        _collectionView.pagingEnabled = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[AddCarCollectionCell class] forCellWithReuseIdentifier:@"AddCarCollectionCell"];
        [_collectionView registerClass:[CarCollectionCell class] forCellWithReuseIdentifier:@"CarCollectionCell"];
        [self addSubview:_collectionView];
        [_collectionView autoPinEdgesToSuperviewEdges];

    }
    return self;
}

#pragma mark -
#pragma mark UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.items.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(kHeight, kHeight);
}
- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, kViewControllerPadding, 0, 0);
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    id item = self.items[indexPath.item];
    if([item isEqual:@"add"]) {
        AddCarCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AddCarCollectionCell" forIndexPath:indexPath];
        return cell;
    } else {
        Car *car = (Car *)item;
        CarCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CarCollectionCell" forIndexPath:indexPath];
        cell.iconImageView.image = [UIImage imageNamed:car.iconName];
        cell.titleLabel.text = car.carNumber;
        return cell;
    }
    return nil;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    id item = self.items[indexPath.item];
    if([item isEqual:@"add"]) {
        if([self.delegate respondsToSelector:@selector(CarsCollectionViewAddTapped)]) {
            [self.delegate CarsCollectionViewAddTapped];
        }
    } else {
        if([self.delegate respondsToSelector:@selector(CarsCollectionViewCarTapped:)]) {
            [self.delegate CarsCollectionViewCarTapped:item];
        }
    }
}

- (void)addAddButton {
    [self.items insertObject:@"add" atIndex:0];
    [self.collectionView reloadData];
}

- (void)addCar:(Car *)car {
    [self.items addObject:car];
    [self.collectionView reloadData];
}

- (void)addCars:(NSArray *)cars {
    [self.items addObjectsFromArray:cars];
    [self.collectionView reloadData];
}


@end
