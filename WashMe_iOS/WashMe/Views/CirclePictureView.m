//
//  CirclePictureView.m
//  WashMe
//
//  Created by Almas Adilbek on 11/13/14.
//  Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

#import "CirclePictureView.h"
#import "ImageBundle.h"
#import "UIImageView+WebCache.h"
#import "ObjectImage.h"
#import "ApiUtils.h"
#import "M13BadgeView.h"

@implementation CirclePictureView {
    UIImageView *imageView;
}

- (id)initWithDimension:(CGFloat)dimension
{
    self = [super initWithFrame:CGRectMake(0, 0, dimension, dimension)];
    if(self) {

        imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.layer.cornerRadius = (CGFloat) (dimension * 0.5);
        imageView.layer.masksToBounds = YES;
        [self addSubview:imageView];

    }
    return self;
}

- (void)setPlaceholder:(NSString *)placeholderImageName {
    imageView.image = [UIImage imageWithName:placeholderImageName];
}

- (void)setImage:(UIImage *)image {
    self.hasImage = YES;
    imageView.image = image;
}

- (void)setImages:(NSArray *)images showBadge:(BOOL)showBadge noImagePlaceholder:(NSString *)noImagePlaceholder
{
    if(images.count > 0)
    {
        self.hasImage = YES;
        ImageBundle *imageBundle = images[0];

        UIActivityIndicatorView *loader = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        loader.hidesWhenStopped = YES;
        loader.center = imageView.center;
        [self addSubview:loader];
        [loader startAnimating];

        [imageView sd_setImageWithURL:[NSURL URLWithString:[imageBundle.medium webUrl]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [loader stopAnimating];
            [loader removeFromSuperview];
        }];

        // Badge
        if(showBadge) {
            M13BadgeView *countView = [[M13BadgeView alloc] initWithFrame:CGRectZero];
            [countView setFont:[UIFont robotoBold:13]];
            [countView setText:[NSString stringWithFormat:@"%i", images.count]];
            countView.badgeBackgroundColor = [UIColor whiteColor];
            countView.textColor = [UIColor blackColor];
            countView.horizontalAlignment = M13BadgeViewHorizontalAlignmentNone;
            countView.verticalAlignment = M13BadgeViewVerticalAlignmentNone;
            countView.cornerRadius = 10;
            countView.x = self.width - 25;
            countView.y = self.height - 25;
            [self addSubview:countView];
        }

    } else {
        imageView.image = [UIImage imageWithName:noImagePlaceholder];
    }

    // Set tap gesture
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped)];
    [self addGestureRecognizer:ges];
}

- (void)tapped {
    [self.delegate circlePictureViewTapped];
}


@end
