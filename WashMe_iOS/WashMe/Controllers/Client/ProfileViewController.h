//
// Created by Almas Adilbek on 10/2/14.
// Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ScrollViewControllerOld.h"
#import "CirclePictureView.h"
#import "MWPhotoBrowser.h"
#import "CarsCollectionView.h"
#import "AddCarViewController.h"
#import "ScrollViewController.h"

@interface ProfileViewController : ScrollViewController<CarwashPictureViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, MWPhotoBrowserDelegate, CarsCollectionViewDelegate, AddCarViewControllerDelegate>
- (void)tapSave;
@end