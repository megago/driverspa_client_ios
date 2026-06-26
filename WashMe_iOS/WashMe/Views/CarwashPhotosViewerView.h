//
//  CarwashPhotosViewerView.h
//  WashMe
//
//  Created by Almas Adilbek on 1/3/15.
//  Copyright (c) 2015 Almas Adilbek. All rights reserved.
//



@class ImageBundle;

@interface CarwashPhotosViewerView : UIView <UINavigationControllerDelegate, UIImagePickerControllerDelegate, MWPhotoBrowserDelegate, UIScrollViewDelegate>

@property(nonatomic, strong) NSString *carwashId;

- (void)setPhotos:(NSArray *)photos;
- (void)addPhoto:(ImageBundle *)photo;
- (void)removePhoto:(ImageBundle *)photo;

@end
