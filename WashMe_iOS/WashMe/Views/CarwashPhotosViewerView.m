//
//  CarwashPhotosViewerView.m
//  WashMe
//
//  Created by Almas Adilbek on 1/3/15.
//  Copyright (c) 2015 Almas Adilbek. All rights reserved.
//

#import <MWPhotoBrowser/MWPhotoBrowser.h>
#import "CarwashPhotosViewerView.h"
#import "ImageBundle.h"
#import "UIImageView+WebCache.h"
#import "ObjectImage.h"
#import "UIActionSheet+Blocks.h"
#import "AppDelegate.h"
#import "UIAlertView+Blocks.h"
#import "CarwashApi.h"
#import "NSObject+PWObject.h"
#import "UtilsApi.h"

@implementation CarwashPhotosViewerView {
    UIScrollView *photosScrollView;
    UIImageView *noPhotoView;
    UIPageControl *pageControl;
    UIButton *addButton;
    UIButton *menuButton;

    NSMutableArray *carwashPhotos;
    MWPhotoBrowser *carwashPhotosBrowser;
}

-(id)init
{
    CGFloat footerHeight = 15;
    UIImage *photoPlaceholderImage = [UIImage imageNamed:@"carwash-photo-placeholder.png"];
    CGFloat photoHeight = photoPlaceholderImage.size.height * [ASize screenWidth] / 320.f;
    CGFloat h = footerHeight + photoHeight;

    self = [super initWithFrame:CGRectMake(0, 0, [ASize screenWidth], h)];
    if(self) {

        carwashPhotos = [[NSMutableArray alloc] init];

        photosScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.width, photoHeight)];
        photosScrollView.delegate = self;
        photosScrollView.pagingEnabled = YES;
        photosScrollView.alwaysBounceHorizontal = YES;
        photosScrollView.showsHorizontalScrollIndicator = NO;
        photosScrollView.showsVerticalScrollIndicator = NO;
        photosScrollView.backgroundColor = [UIColor fromRGB:0x215A95];
        [self addSubview:photosScrollView];

        noPhotoView = [[UIImageView alloc] initWithFrame:photosScrollView.bounds];
        noPhotoView.image = photoPlaceholderImage;
        [self addSubview:noPhotoView];

        // menu button
        menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [menuButton addTarget:self action:@selector(menuButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        UIImage *menuButtonImage = [UIImage imageNamed:@"btn_carwash-photo-menu_normal.png"];
        [menuButton setImage:menuButtonImage forState:UIControlStateNormal];
        [menuButton setImage:[UIImage imageNamed:@"btn_carwash-photo-menu_pressed.png"] forState:UIControlStateHighlighted];
        menuButton.width = menuButtonImage.size.width;
        menuButton.height = menuButtonImage.size.height;
        menuButton.x = self.width - menuButton.width - 10;
        menuButton.y = photosScrollView.height - menuButton.height - 10;
        menuButton.hidden = YES;
        [self addSubview:menuButton];

        // Add Button
        addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [addButton addTarget:self action:@selector(addButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        UIImage *addButtonImage = [UIImage imageNamed:@"btn_carwash-upload-photo_normal.png"];
        [addButton setImage:addButtonImage forState:UIControlStateNormal];
        [addButton setImage:[UIImage imageNamed:@"btn_carwash-upload-photo_pressed.png"] forState:UIControlStateHighlighted];
        addButton.width = addButtonImage.size.width;
        addButton.height = addButtonImage.size.height;
        addButton.center = menuButton.center;
        addButton.hidden = YES;
        [self addSubview:addButton];

        pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, photosScrollView.bottom + 5, self.width, 10)];
        pageControl.hidden = YES;
        [self addSubview:pageControl];

        // Gesture
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openGallery)];
        [photosScrollView addGestureRecognizer:ges];
    }
    return self;
}

- (void)addPhoto:(ImageBundle *)photo
{
    if(photo) {
        [carwashPhotos addObject:photo];
        [self setPhotos:carwashPhotos];
    }
}

- (void)removePhoto:(ImageBundle *)photo
{
    if(photo) {
        for(ImageBundle *imageBundle in carwashPhotos) {
            if([imageBundle.imagesId isEqual:photo.imagesId]) {
                [carwashPhotos removeObject:imageBundle];
                [self setPhotos:carwashPhotos];
                break;
            }
        }
    }
}


- (void)setPhotos:(NSArray *)photos
{
    carwashPhotos = [NSMutableArray arrayWithArray:photos];

    // Clear old photos
    for(UIView *subview in photosScrollView.subviews) {
        [subview removeFromSuperview];
    }

    if(photos.count == 0) {
        addButton.hidden = NO;
        menuButton.hidden = YES;
        noPhotoView.hidden = NO;
        pageControl.hidden = YES;
        return;
    }

    noPhotoView.hidden = YES;
    addButton.hidden = YES;
    menuButton.hidden = NO;
    if(photos.count > 1) pageControl.hidden = NO;

    NSInteger index = 0;
    for(ImageBundle *photo in photos)
    {
        UIImageView *photoView = [[UIImageView alloc] initWithFrame:photosScrollView.bounds];
        photoView.contentMode = UIViewContentModeScaleAspectFill;
        photoView.layer.masksToBounds = YES;
        photoView.x = index * self.width;
        [photosScrollView addSubview:photoView];

        UIActivityIndicatorView *loader = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        loader.hidesWhenStopped = YES;
        loader.centerX = photoView.centerX;
        loader.y = photoView.height - loader.height - 10;
        [photosScrollView addSubview:loader];

        [loader startAnimating];
        [photoView sd_setImageWithURL:[photo.original URL] placeholderImage:[UIImage imageNamed:@"carwash-photo-placeholder.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [loader stopAnimating];
            [loader removeFromSuperview];
        }];

        ++index;
    }

    CGSize size = photosScrollView.contentSize;
    size.width = photosScrollView.width * photos.count;
    [photosScrollView setContentSize:size];

    pageControl.numberOfPages = photos.count;
}

#pragma mark -
#pragma mark actions

- (void)openGallery
{
    if(carwashPhotos.count == 0) return;

    carwashPhotosBrowser = [[MWPhotoBrowser alloc] initWithDelegate:self];

    carwashPhotosBrowser.displayActionButton = YES;
    carwashPhotosBrowser.displayNavArrows = YES;
    carwashPhotosBrowser.displaySelectionButtons = NO;
    carwashPhotosBrowser.zoomPhotosToFill = YES;
    carwashPhotosBrowser.alwaysShowControls = NO;
    carwashPhotosBrowser.enableGrid = YES;
    carwashPhotosBrowser.startOnGrid = NO;
    [carwashPhotosBrowser setCurrentPhotoIndex:pageControl.currentPage];

    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:carwashPhotosBrowser];
    [[UIHelper windowRootViewController] presentViewController:nc animated:YES completion:^{

    }];
    

    [self performBlock:^{
        [UIHelper setupWhiteStatusBar:YES];
    } afterDelay:0.15];

}

- (void)addButtonTapped {
    [self showActionSheet];
}

- (void)menuButtonTapped {
    [self showActionSheet];
}

#pragma mark -
#pragma mark ScrollView

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self scrollViewDidEndScrolling];
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self scrollViewDidEndScrolling];
}

// Custom
-(void)scrollViewDidEndScrolling
{
    CGFloat pageWidth = photosScrollView.frame.size.width;
    NSInteger page = (NSInteger) (floor((photosScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1);
    pageControl.currentPage = page;
}

#pragma mark -
#pragma mark MWPhotoBrowser

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return carwashPhotos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if(carwashPhotos.count > 0) {
        ImageBundle *imageBundle = carwashPhotos[index];
        MWPhoto *mwPhoto = [[MWPhoto alloc] initWithURL:[imageBundle.original URL]];
        return mwPhoto;
    }
    return nil;
}

- (void)photoBrowserDidFinishModalPresentation:(MWPhotoBrowser *)photoBrowser {
    [photoBrowser dismissViewControllerAnimated:YES completion:nil];
    [UIHelper setupWhiteStatusBar:YES];
}

#pragma mark -
#pragma mark UIImagePickerController

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [[UIHelper windowRootViewController] dismissViewControllerAnimated:YES completion:^{
        [UIHelper setupWhiteStatusBar:YES];
    }];

    UIImage *image = info[UIImagePickerControllerOriginalImage];

    [Toast showHudWithTitle:@"Загрузка фото"];
    [CarwashApi uploadCarwashImage:image carwashId:self.carwashId success:^(id response) {
        [self addPhoto:response];
        [Toast showSuccessToastWithMessage:@"Фото загружено"];
    } failure:^(NSInteger code, NSString *message) {
        [UIHelper showAlertTryAgain];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{
        [UIHelper setupWhiteStatusBar:YES];
    }];
}

#pragma mark -
#pragma mark Helper

- (void)showActionSheet
{
    NSMutableArray *optionButtons = [NSMutableArray array];
    [optionButtons addObject:@"Сделать снимок"];
    [optionButtons addObject:@"Выбрать из альбома"];

    NSString *title;
    NSString *deleteButtonTitle = nil;
    if(carwashPhotos.count > 0) {
        title = @"Загрузить / Удалить фото";
        deleteButtonTitle = @"Удалить фото";
    } else {
        title = @"Загрузить фото";
    }

    [UIActionSheet showInView:self.superview.superview withTitle:title cancelButtonTitle:@"Отмена" destructiveButtonTitle:deleteButtonTitle otherButtonTitles:optionButtons tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
        if(buttonIndex == actionSheet.cancelButtonIndex) return;
        if(buttonIndex != actionSheet.destructiveButtonIndex)
        {
            if(deleteButtonTitle) {
                if(buttonIndex == 1) {
                    [self takePhoto];
                } if(buttonIndex == 2) {
                    [self choosePhoto];
                }
            } else {
                if(buttonIndex == 0) {
                    [self takePhoto];
                } if(buttonIndex == 1) {
                    [self choosePhoto];
                }
            }
        } else {
            [self deletePhoto];
        }
    }];
}

- (void)takePhoto
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];

    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [imagePickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
        [imagePickerController setDelegate:self];

        [UIHelper setupBlackStatusBar:YES];
        [[UIHelper windowRootViewController] presentViewController:imagePickerController animated:YES completion:nil];
        
    }
}

- (void)choosePhoto
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];

    [imagePickerController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [imagePickerController setDelegate:self];

    [UIHelper setupBlackStatusBar:YES];
    [[UIHelper windowRootViewController] presentViewController:imagePickerController animated:YES completion:nil];
    
}

- (void)deletePhoto
{
    [UIAlertView showWithTitle:@"Удалить фото?" message:nil cancelButtonTitle:@"Отмена" otherButtonTitles:@[@"Удалить"] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex != alertView.cancelButtonIndex)
        {
            ImageBundle *imageBundle = carwashPhotos[pageControl.currentPage];

            [Toast showHudWithTitle:@"Удаление"];
            [UtilsApi deleteImage:imageBundle.imagesId success:^(id response) {
                [self removePhoto:imageBundle];
                [Toast showSuccessToastWithMessage:@"Фото удалено"];
            } failure:^(NSInteger code, NSString *message) {
                [UIHelper showAlertTryAgain];
            }];
        }
    }];
}

@end
