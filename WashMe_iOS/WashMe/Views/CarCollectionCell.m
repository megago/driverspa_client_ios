//
//  CarCollectionCell.m
//  WashMe
//
//  Created by Almas Adilbek on 3/30/16.
//  Copyright (c) 2016 Almas Adilbek. All rights reserved.
//

#import "CarCollectionCell.h"
#import "ALView+PureLayout.h"
#import "UIView+ConcisePureLayout.h"

@implementation CarCollectionCell {
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        
        UIView *container = [UIView newAutoLayoutView];
        [self addSubview:container];
        [container aa_superviewFitWidthWithInset:10];
        [container aa_centerVertical];

        self.iconImageView = [UIImageView newAutoLayoutView];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
        [container addSubview:_iconImageView];
        [_iconImageView aa_superviewTop:0];
        [_iconImageView aa_superviewFitWidth];

        self.titleLabel = [UILabel newAutoLayoutView];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont robotoRegular:10];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.adjustsFontSizeToFitWidth = YES;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [container addSubview:_titleLabel];
        [_titleLabel aa_pinUnderView:_iconImageView offset:3];
        [_titleLabel aa_superviewFitWidth];
        [_titleLabel aa_superviewBottom:0];
    }
    return self;
}

- (void)setSelected:(BOOL)selected {
    if (selected) {
        self.contentView.layer.borderWidth = 1.f;
        self.contentView.layer.borderColor = [UIColor whiteColor].CGColor;
        self.contentView.backgroundColor = [[UIColor fromRGB:0x184977] colorWithAlphaComponent:1.f];
    } else {
        self.contentView.layer.borderWidth = 0.f;
        self.contentView.layer.borderColor = [UIColor clearColor].CGColor;
        self.contentView.backgroundColor = [[UIColor fromRGB:0x184977] colorWithAlphaComponent:0.25f];
    }
}

@end
