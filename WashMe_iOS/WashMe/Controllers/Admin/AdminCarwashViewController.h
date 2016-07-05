//
//  AdminCarwashViewController.h
//  WashMe
//
//  Created by Almas Adilbek on 10/20/14.
//  Copyright (c) 2014 Almas Adilbek. All rights reserved.
//



#import "ScrollViewControllerOld.h"
#import "AddPhotoCircleView.h"
#import "MWPhotoBrowser.h"

@protocol AdminCarwashViewControllerDelegate;
@class CarwashComplex;
@class Carwash;

@interface AdminCarwashViewController : ScrollViewControllerOld <UINavigationControllerDelegate>

@property(nonatomic, weak) id <AdminCarwashViewControllerDelegate> delegate;
@property(nonatomic, strong) Carwash *carwash;

@end


@protocol AdminCarwashViewControllerDelegate <NSObject>
- (void)adminCarwashViewControllerCarwashCreated:(CarwashComplex *)createdCarwash;
- (void)adminCarwashViewControllerCarwashUpdated:(CarwashComplex *)updatedCarwash;
@end
