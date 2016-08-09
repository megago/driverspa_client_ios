//
//  CarsCollectionCell.m
//  WashMe
//
//  Created by Almas Adilbek on 3/30/16.
//  Copyright (c) 2016 Almas Adilbek. All rights reserved.
//

#import "CarsCollectionCell.h"

@implementation CarsCollectionCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.layer.cornerRadius = 10;
        self.contentView.clipsToBounds = YES;
        //self.contentView.backgroundColor = [UIColor fromRGB:0x184977];
        self.contentView.backgroundColor = [[UIColor fromRGB:0x184977] colorWithAlphaComponent:0.25f];
    }

    return self;
}

@end
