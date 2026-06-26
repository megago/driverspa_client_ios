//
//  AddPhotoCircleView.h
//  WashMe
//
//  Created by Almas Adilbek on 10/21/14.
//  Copyright (c) 2014 Almas Adilbek. All rights reserved.
//


@protocol AddPhotoCircleViewDelegate<NSObject>
- (void)addPhotoCircleViewAddTapped;
- (void)addPhotoCircleViewPhotoTapped;
@end

@interface AddPhotoCircleView : UIView

@property(nonatomic, weak) id <AddPhotoCircleViewDelegate> delegate;

- (void)setImage:(UIImage *)image;

@end
