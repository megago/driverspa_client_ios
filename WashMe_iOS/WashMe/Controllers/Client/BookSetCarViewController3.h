//
//  BookSetCarViewController3.h
//  WashMe
//
//  Created by Ivan Korotkikh on 07.08.16.
//  Copyright © 2016 Almas Adilbek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CarsCollectionView.h"
#import "AddCarViewController.h"
#import "ScrollViewController.h"

@class CarwashComplex;
@class BookObject;

@interface BookSetCarViewController3 : ScrollViewController<UINavigationControllerDelegate, CarsCollectionViewDelegate, AddCarViewControllerDelegate>
@property(nonatomic, strong) CarwashComplex *carwash;
@property(nonatomic, strong) BookObject *bookObject;
@end