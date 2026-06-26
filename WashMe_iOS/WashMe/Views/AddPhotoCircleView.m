//
//  AddPhotoCircleView.m
//  WashMe
//
//  Created by Almas Adilbek on 10/21/14.
//  Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

#import "AddPhotoCircleView.h"

@implementation AddPhotoCircleView {
    UIImageView *avatarView;
    BOOL hasPhoto;
}

- (id)init
{
    avatarView = [[UIImageView alloc] initWithImage:[UIImage imageWithName:@"avatar-circle"]];
    avatarView.contentMode = UIViewContentModeScaleAspectFill;
    avatarView.layer.cornerRadius = (CGFloat) (avatarView.width * 0.5);
    avatarView.layer.masksToBounds = YES;

    self = [super initWithFrame:avatarView.bounds];
    if(self) {
        avatarView.alpha = 0.7;
        [self addSubview:avatarView];

        UILabel *placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, avatarView.width - 10, 1)];
        placeholderLabel.backgroundColor = [UIColor clearColor];
        placeholderLabel.font = [UIFont robotoRegular:14];
        placeholderLabel.textColor = [UIColor whiteColor];
        placeholderLabel.lineBreakMode = NSLineBreakByWordWrapping;
        placeholderLabel.numberOfLines = 0;
        placeholderLabel.textAlignment = NSTextAlignmentCenter;
        placeholderLabel.text = @"Добавить\nфото";
        [placeholderLabel sizeToFit];
        placeholderLabel.alpha = 0.7;
        placeholderLabel.center = avatarView.center;
        [self addSubview:placeholderLabel];

        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped)];
        [self addGestureRecognizer:ges];

    }
    return self;
}

- (void)tapped {
    if(!hasPhoto) {
        [self.delegate addPhotoCircleViewAddTapped];
    } else {
        [self.delegate addPhotoCircleViewPhotoTapped];
    }
}

- (void)setImage:(UIImage *)image
{
    hasPhoto = YES;
    avatarView.image = image;
}


@end
