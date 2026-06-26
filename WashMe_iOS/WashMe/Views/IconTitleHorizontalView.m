//
//  IconTitleHorizontalView.m
//  Zenge
//
//  Created by Almas Adilbek on 11/25/15.
//  Copyright (c) 2015 Zenge. All rights reserved.
//

#import <PureLayout/ALView+PureLayout.h>
#import "UIView+ConcisePureLayout.h"
#import "IconTitleHorizontalView.h"

@implementation IconTitleHorizontalView

- (id)initWithIcon:(NSString *)iconName title:(NSString *)title {
    return [self initWithIcon:iconName title:title spacing:5];
}

- (id)initWithIcon:(NSString *)iconName title:(NSString *)title spacing:(CGFloat)spacing {
    self = [super init];
    if(self) {

        self.translatesAutoresizingMaskIntoConstraints = NO;
        
        self.iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:iconName]];
        [self addSubview:_iconView];
        [_iconView aa_setDimensions];
        [_iconView aa_superviewLeft:0];
        [_iconView aa_superviewFitHeight];
        
        self.titleLabel = [UILabel newAutoLayoutView];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont systemFontOfSize:12];
        _titleLabel.textColor = [UIColor blackColor];
        [self addSubview:_titleLabel];
        [_titleLabel aa_pinAfterView:_iconView offset:spacing];
        [_titleLabel aa_superviewRight:0];
        [_titleLabel aa_verticalAlignWithView:_iconView];
        
    }
    return self;
}

- (void)setText:(NSString *)text {
    self.titleLabel.text = text;
}

@end
