//
//  CarwashServiceCollectionView.m
//  WashMe
//
//  Created by Ivan Korotkikh on 07.08.16.
//  Copyright © 2016 Almas Adilbek. All rights reserved.
//

#import "CarwashServiceCollectionView.h"
#import "ALView+PureLayout.h"
#import "UIView+ConcisePureLayout.h"
#import "ServiceCollectionCell.h"

#define kHeight 60

@interface CarwashServiceCollectionView () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *items;
@end

@implementation CarwashServiceCollectionView

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
        [_collectionView registerClass:[ServiceCollectionCell class] forCellWithReuseIdentifier:@"ServiceCollectionCell"];
        [self addSubview:_collectionView];
        [_collectionView autoPinEdgesToSuperviewEdges];
    }
    return self;
}

#pragma mark -
#pragma mark UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 5;//self.items.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(kHeight, kHeight);
}
- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, kViewControllerPadding, 0, 0);
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //id item = self.items[indexPath.item];
    ServiceCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ServiceCollectionCell" forIndexPath:indexPath];
    [cell setTitleService:@"Кузов + салон"];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //id item = self.items[indexPath.item];
}

@end
