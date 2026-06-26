//
//  DoubleCell.m
//  WashMe
//
//  Created by Almas Adilbek on 4/5/16.
//  Copyright (c) 2016 Almas Adilbek. All rights reserved.
//

#import <ConcisePureLayout/UIView+ConcisePureLayout.h>
#import "DoubleCell.h"
#import "ALView+PureLayout.h"

@interface DoubleCell()
@end

@implementation DoubleCell

-(id)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if(self) {

        self.leftView = [UIView newAutoLayoutView];
        [self.contentView addSubview:_leftView];
        [_leftView aa_superviewLeft:0];
        [_leftView aa_superviewFitHeight];
        [_leftView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.contentView withMultiplier:0.5];

        self.rightView = [UIView newAutoLayoutView];
        [self.contentView addSubview:_rightView];
        [_rightView aa_superviewRight:0];
        [_rightView aa_superviewFitHeight];
        [_rightView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.contentView withMultiplier:0.5];

    }
    return self;
}

@end
