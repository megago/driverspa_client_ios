//
//  CirclePictureView.h
//  WashMe
//
//  Created by Almas Adilbek on 11/13/14.
//  Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

@protocol CarwashPictureViewDelegate<NSObject>
- (void)circlePictureViewTapped;
@end

@interface CirclePictureView : UIView

@property(nonatomic, weak) id <CarwashPictureViewDelegate> delegate;
@property(nonatomic, assign) BOOL hasImage;

- (id)initWithDimension:(CGFloat)dimension;

- (void)setPlaceholder:(NSString *)placeholderImageName;
- (void)setImage:(UIImage *)image;
- (void)setImages:(NSArray *)images showBadge:(BOOL)showBadge noImagePlaceholder:(NSString *)noImagePlaceholder;

@end
