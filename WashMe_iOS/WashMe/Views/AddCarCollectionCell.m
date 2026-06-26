//
//  AddCarCollectionCell.m
//  WashMe
//
//  Created by Almas Adilbek on 3/30/16.
//  Copyright (c) 2016 Almas Adilbek. All rights reserved.
//

#import "AddCarCollectionCell.h"
#import "UIView+ConcisePureLayout.h"

@implementation AddCarCollectionCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {

        UIImageView *addView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iconCirclePlus.png"]];
        [self addSubview:addView];
        [addView aa_setDimensions];
        [addView aa_centerInSuperview];

    }
    return self;
}

@end
