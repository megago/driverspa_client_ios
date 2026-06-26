//
//  BookSetCarViewController3.h
//  WashMe
//
//  Created by Ivan Korotkikh on 07.08.16.
//  Copyright © 2016 Almas Adilbek. All rights reserved.
//

#import "ScrollViewController.h"

@class CarwashComplex;
@class BookObject;

@interface BookSetCarViewController3 : ScrollViewController
@property(nonatomic, strong) CarwashComplex *carwash;
@property(nonatomic, strong) BookObject *bookObject;
@property(nonatomic, assign, getter=isEditMode) BOOL editMode;
@end