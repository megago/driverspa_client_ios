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
#import "IdTitleObject.h"
#import "ASize.h"

#define kHeight 50

@interface CarwashServiceCollectionView () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *items;
@end

@implementation CarwashServiceCollectionView

- (id)init {
    self = [super init];
    if(self) {
        
        //[self aa_setHeight:kHeight];
        
        self.items = [[NSMutableArray alloc] init];
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.sectionInset = UIEdgeInsetsMake(0, kViewControllerPadding, 0, kViewControllerPadding);
        layout.minimumInteritemSpacing = 5;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.alwaysBounceHorizontal = NO;
        _collectionView.alwaysBounceVertical = NO;
        _collectionView.pagingEnabled = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.allowsMultipleSelection = YES;
        [_collectionView registerClass:[ServiceCollectionCell class] forCellWithReuseIdentifier:@"ServiceCollectionCell"];
        [self addSubview:_collectionView];
        [_collectionView autoPinEdgesToSuperviewEdges];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {

        self.items = [[NSMutableArray alloc] init];
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.sectionInset = UIEdgeInsetsMake(0, kViewControllerPadding, 0, kViewControllerPadding);
        layout.minimumInteritemSpacing = 5;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        self.collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.alwaysBounceHorizontal = NO;
        _collectionView.alwaysBounceVertical = NO;
        _collectionView.pagingEnabled = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.allowsMultipleSelection = YES;
        [_collectionView registerClass:[ServiceCollectionCell class] forCellWithReuseIdentifier:@"ServiceCollectionCell"];
        [self addSubview:_collectionView];
    }
    return self;
}

#pragma mark -
#pragma mark UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.items.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = (collectionView.frame.size.width - 4 * kViewControllerPadding) / 3;
    return CGSizeMake(width, kHeight);
}
- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, kViewControllerPadding, 0, kViewControllerPadding);
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ServiceCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ServiceCollectionCell" forIndexPath:indexPath];
    
    IdTitleObject *service = self.items[(NSUInteger) indexPath.row];
    cell.serviceLabel.text = service.title;
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSArray<NSIndexPath*>* selectedIndexes = collectionView.indexPathsForSelectedItems;
    NSMutableArray *services = [[NSMutableArray alloc] init];
    for (NSIndexPath *path in selectedIndexes) {
        IdTitleObject *item = self.items[path.row];;
        [services addObject:item];
    }
    //NSLog(@"selected - %ld", (long)services.count);
    [self.delegate carwashServiceCollectionViewSelectedServices:services];
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSArray<NSIndexPath*>* selectedIndexes = collectionView.indexPathsForSelectedItems;
    NSMutableArray *services = [[NSMutableArray alloc] init];
    for (NSIndexPath *path in selectedIndexes) {
        IdTitleObject *item = self.items[path.row];;
        [services addObject:item];
    }
    //NSLog(@"deselected - %ld", (long)services.count);
    [self.delegate carwashServiceCollectionViewSelectedServices:services];
}
- (void)addService:(IdTitleObject *)service {
    [self.items addObject:service];
    [self.collectionView reloadData];
}

- (void)addServices:(NSArray *)services {
    [self.items addObjectsFromArray:services];
    [self.collectionView reloadData];
}

- (void)adminRefreshServices:(NSArray *)services {
    int section = (int) services.count / 3;
    if (section == 0) {
        self.height = kHeight;
    } else {
        CGFloat height = services.count % 3 > 0 ? kHeight * (section + 1) + 15*section : kHeight * section;
        self.height = height;
    }
    self.collectionView.frame = self.bounds;
    
    [self.items removeAllObjects];
    [self.items addObjectsFromArray:services];
    [self.collectionView reloadData];
}

- (void)refreshServices:(NSArray *)services {
    int section = (int) services.count / 3;
    if (section == 0) {
        [self aa_setHeight:kHeight];
    } else {
        CGFloat height = services.count % 3 > 0 ? kHeight * (section + 1) + 15*section : kHeight * section;
        [self aa_setHeight:height];
    }
    
    [self.items removeAllObjects];
    [self.items addObjectsFromArray:services];
    [self.collectionView reloadData];
}

- (void)selectItemAtIndex : (NSInteger)index {
    NSIndexPath *selection = [NSIndexPath indexPathForItem:index inSection:0];
    [self.collectionView selectItemAtIndexPath:selection
                                      animated:YES
                                scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
}

- (void)reloadData {
    [self.collectionView reloadData];
}

@end
