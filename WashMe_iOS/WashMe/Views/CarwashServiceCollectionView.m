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
#import "CarwashGroupMenuItem.h"

#define kHeight 50

@interface CarwashServiceCollectionView () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) NSMutableArray *groupItems;

@end

@implementation CarwashServiceCollectionView {
    NSMutableArray *selectedServices;
    NSMutableArray *selectedGroups;
    NSMutableArray *disabledService;
}

- (id)init {
    self = [super init];
    if(self) {
        
        //[self aa_setHeight:kHeight];
        
        self.items = [[NSMutableArray alloc] init];
        self.groupItems = [[NSMutableArray alloc] init];
        selectedServices = [[NSMutableArray alloc] init];
        selectedGroups = [[NSMutableArray alloc] init];
        disabledService = [[NSMutableArray alloc] init];
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.sectionInset = UIEdgeInsetsMake(0, kViewControllerPadding, kViewControllerPadding, kViewControllerPadding);
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
        _collectionView.allowsMultipleSelection = NO;
        _collectionView.scrollEnabled = NO;
        [_collectionView registerClass:[ServiceCollectionCell class] forCellWithReuseIdentifier:@"ServiceCollectionCell"];
        [_collectionView registerClass:[ServiceCollectionCell class] forCellWithReuseIdentifier:@"GroupCollectionCell"];
        [self addSubview:_collectionView];
        [_collectionView autoPinEdgesToSuperviewEdges];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {

        self.items = [[NSMutableArray alloc] init];
        self.groupItems = [[NSMutableArray alloc] init];
        selectedServices = [[NSMutableArray alloc] init];
        selectedGroups = [[NSMutableArray alloc] init];
        disabledService = [[NSMutableArray alloc] init];
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.sectionInset = UIEdgeInsetsMake(0, kViewControllerPadding, kViewControllerPadding, kViewControllerPadding);
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
        _collectionView.allowsMultipleSelection = NO;
        _collectionView.scrollEnabled = NO;
        [_collectionView registerClass:[ServiceCollectionCell class] forCellWithReuseIdentifier:@"ServiceCollectionCell"];
        [_collectionView registerClass:[ServiceCollectionCell class] forCellWithReuseIdentifier:@"GroupCollectionCell"];
        [self addSubview:_collectionView];
    }
    return self;
}

#pragma mark -
#pragma mark UICollectionView

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0){
        return self.groupItems.count;
    } else {
        return self.items.count;
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = (collectionView.frame.size.width - 4 * kViewControllerPadding) / 3;
    return CGSizeMake(width, kHeight);
}
- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, kViewControllerPadding, kViewControllerPadding, kViewControllerPadding);
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0){
        ServiceCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GroupCollectionCell" forIndexPath:indexPath];
        CarwashGroupMenuItem *group = self.groupItems[(NSUInteger) indexPath.row];
        cell.groupItem = group;
        if ([selectedGroups containsObject:group]){
            cell.isSelectedCell = YES;
        } else {
            cell.isSelectedCell = NO;
        }
        [cell setTitle:group.name];
        return cell;
    } else {
        ServiceCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ServiceCollectionCell" forIndexPath:indexPath];
        IdTitleObject *service = self.items[(NSUInteger) indexPath.row];
        if ([selectedServices containsObject:service]){
            cell.isSelectedCell = YES;
        } else {
            cell.isSelectedCell = NO;
        }
        if ([disabledService containsObject:service.objectId]){
            cell.isDissableCell = YES;
            cell.userInteractionEnabled = NO;
        } else {
            cell.isDissableCell = NO;
            cell.userInteractionEnabled = YES;
        }
        [cell setTitle:service.title];
        return cell;
    }
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0){
        CarwashGroupMenuItem *item = self.groupItems[indexPath.row];
//        [selectedServices removeAllObjects];
//        if ([selectedGroups containsObject:item]){
//            [selectedGroups removeObject:item];
//            [disabledService removeAllObjects];
//        } else {
//            [selectedGroups removeAllObjects];
//            [disabledService removeAllObjects];
//            [selectedGroups addObject:item];
//            [disabledService addObjectsFromArray:item.services];
//        }
        if ([selectedGroups containsObject:item]){
            [selectedGroups removeObject:item];
        } else {
            [selectedGroups addObject:item];
        }
        [self.delegate carwashServiceCollectionViewSelectedGroups:selectedGroups];
//        [self.delegate carwashServiceCollectionViewSelectedServices:selectedServices];
        [self reloadData];
    } else {
        IdTitleObject *item = self.items[indexPath.row];
        if ([selectedServices containsObject:item]){
            [selectedServices removeObject:item];
        } else {
            [selectedServices addObject:item];
        }
        [self.delegate carwashServiceCollectionViewSelectedServices:selectedServices];
        [self reloadData];
    }
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
        [self aa_setHeight:height + 20];
    }
    
    [self.items removeAllObjects];
    [self.items addObjectsFromArray:services];
    [self.collectionView reloadData];
}

- (void)refreshServices:(NSArray *)services withGroupServices:(NSArray *)groups {
    float fullHeight = 0;
    int section = (int) services.count / 3;
    int groupsSection = (int) groups.count / 3;
    if (section == 0) {
        fullHeight += kHeight;
    } else {
        CGFloat height = services.count % 3 > 0 ? kHeight * (section + 1) + 15*section : kHeight * section;
        fullHeight += height + 20;
    }
    
    if (groupsSection == 0) {
        fullHeight += groups.count > 0 ? kHeight + 10 : 0;
    } else {
        CGFloat height = groups.count % 3 > 0 ? kHeight * (groupsSection + 1) + 15*groupsSection : kHeight * groupsSection;
        fullHeight += height + 20;
    }
    [self aa_setHeight:fullHeight];
    
    [self.items removeAllObjects];
    [self.items addObjectsFromArray:services];
    [self.groupItems removeAllObjects];
    [self.groupItems addObjectsFromArray:groups];
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

#pragma mark - Helpers

- (NSInteger)objectExists:(NSString *)key
                withValue:(id)value
                  inArray:(NSArray *)arr {
    
    NSPredicate *exists = [NSPredicate predicateWithFormat:
                           @"%K == %@", key, value];
    NSUInteger index = [arr indexOfObjectPassingTest:
                        ^(id obj, NSUInteger idx, BOOL *stop) {
                            return [exists evaluateWithObject:obj];
                        }];
    
    if (index == NSNotFound) {
        return -1;
    }
    return index;
}

@end
