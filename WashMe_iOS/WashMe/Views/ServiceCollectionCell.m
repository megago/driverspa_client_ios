//
//  ServiceCollectionCell.m
//  WashMe
//
//  Created by Ivan Korotkikh on 07.08.16.
//  Copyright © 2016 Almas Adilbek. All rights reserved.
//

#import "ServiceCollectionCell.h"
#import "UIFont+Custom.h"
#import "ALView+PureLayout.h"
#import "UIView+ConcisePureLayout.h"

@implementation ServiceCollectionCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        
        self.contentView.alpha = 0.25;
        
        UIView *container = [UIView newAutoLayoutView];
        [self addSubview:container];
        [container aa_superviewFitWidthWithInset:10];
        [container aa_centerVertical];
        
        self.titleLabel = [UILabel newAutoLayoutView];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont robotoRegular:10];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.numberOfLines = 0;
        _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [container addSubview:_titleLabel];
        [_titleLabel aa_superviewFitWidth];
        [_titleLabel aa_superviewFitHeight];
    }
    return self;
}

- (void)setSelected:(BOOL)selected {
    if (selected) {
        self.contentView.layer.borderWidth = 1.f;
        self.contentView.layer.borderColor = [UIColor whiteColor].CGColor;
    } else {
        self.contentView.layer.borderWidth = 0.f;
        self.contentView.layer.borderColor = [UIColor clearColor].CGColor;
    }
}

@end
