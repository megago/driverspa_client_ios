//
//  CarwashServiceCollectionView.h
//  WashMe
//
//  Created by Ivan Korotkikh on 07.08.16.
//  Copyright © 2016 Almas Adilbek. All rights reserved.
//

@class IdTitleObject;

@protocol CarwashServiceCollectionDelegate<NSObject>
@optional
- (void)carwashServiceCollectionViewServiceSelected: (IdTitleObject *)service;
- (void)carwashServiceCollectionViewServiceDeselected: (IdTitleObject *)service;
- (void)carwashServiceCollectionViewSelectedServices:(NSArray *) selectedServices;
@end

@interface CarwashServiceCollectionView : UIView
@property (nonatomic, strong) id <CarwashServiceCollectionDelegate> delegate;
- (void)addService:(IdTitleObject *)service;
- (void)addServices:(NSArray *)services;
- (void)refreshServices:(NSArray *)services;
- (void)adminRefreshServices:(NSArray *)services;
- (void)selectItemAtIndex : (NSInteger)index;
- (void)reloadData;
@end
