//
//  RowButtonCheckmarkView.m
//  WashMe
//
//  Created by Almas Adilbek on 10/5/14.
//  Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

#import "RowButtonCheckmarkView.h"

#define kCheckmarkInactiveAlpha 0.08

@implementation RowButtonCheckmarkView {
    UIImageView *checkmark;
    RowButtonViewOnTapBlock _onTapBlock;
}

- (id)initWithTitle:(NSString *)title onTap:(RowButtonViewOnTapBlock)block {
    return [self initWithIcon:nil title:title onTap:block];
}

- (id)initWithIcon:(NSString *)iconName title:(NSString *)title onTap:(RowButtonViewOnTapBlock)block
{
    self = [super initWithIcon:iconName title:title target:self selector:@selector(onCheckmarkRowTap)];
    if(self) {
        _onTapBlock = block;

        checkmark = [[UIImageView alloc] initWithImage:[UIImage imageWithName:@"icon-checkmark"]];
        checkmark.x = self.width - checkmark.width - kRowButtonViewSidePadding;
        checkmark.centerY = self.centerY;
        checkmark.alpha = kCheckmarkInactiveAlpha;
        [self addSubview:checkmark];
    }
    return self;
}

#pragma mark -
#pragma mark Actions

- (void)onCheckmarkRowTap {
    [self setIsChecked:!self.isChecked];
    if(_onTapBlock) {
        _onTapBlock(self);
    }
}

#pragma mark -
#pragma mark Methods

-(void)setIsChecked:(BOOL)isChecked {
    _isChecked = isChecked;
    checkmark.alpha = (CGFloat) (isChecked?1:kCheckmarkInactiveAlpha);
}

@end
