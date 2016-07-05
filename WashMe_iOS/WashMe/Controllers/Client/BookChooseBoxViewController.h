//
//  BookChooseBoxViewController.h
//  WashMe
//
//  Created by Almas Adilbek on 10/6/14.
//  Copyright (c) 2014 Almas Adilbek. All rights reserved.
//



#import "ScrollViewControllerOld.h"
#import "BoxesGridView.h"

@class CarwashComplex;
@class BookObject;

@interface BookChooseBoxViewController : ScrollViewControllerOld <BoxesGridViewDelegate>

@property(nonatomic, strong) BookObject *bookObject;
@property(nonatomic, assign, getter=isEditMode) BOOL editMode;
@property(nonatomic, assign, getter=isPreview) BOOL preview;


- (void)editBookButtonTapped;
@end
