//
// Created by Almas Adilbek on 9/25/14.
// Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

#import "IconTitleView.h"
#import "UIFont+Custom.h"


@implementation IconTitleView {

}
- (IconTitleView *)initWithIcon:(NSString *)iconName title:(NSString *)title {
    self = [super initWithFrame:CGRectZero];
    if(self) {
        UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:iconName]];
        [self addSubview:iconView];

        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont robotoRegular:14];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.text = title;
        [_titleLabel sizeToFit];
        [self addSubview:_titleLabel];

        _titleLabel.x = 20;

        self.width = _titleLabel.right;
        self.height = MAX(iconView.height, _titleLabel.height);

        _titleLabel.centerY = self.centerY;
        iconView.centerY = self.centerY;
    }
    return self;
}

@end