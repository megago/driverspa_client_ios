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
        
        self.contentView.layer.cornerRadius = 10;
        self.contentView.clipsToBounds = YES;
    
        UIView *container = [UIView newAutoLayoutView];
        [self addSubview:container];
        [container aa_superviewFitWidthWithInset:10];
        [container aa_centerVertical];
        
        self.serviceLabel = [UILabel newAutoLayoutView];
        _serviceLabel.backgroundColor = [UIColor clearColor];
        _serviceLabel.font = [UIFont robotoRegular:10];
        _serviceLabel.textColor = [UIColor whiteColor];
        _serviceLabel.textAlignment = NSTextAlignmentCenter;
        _serviceLabel.numberOfLines = 0;
        _serviceLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [container addSubview:_serviceLabel];
        [_serviceLabel aa_superviewFillWithInset:0];
        
        [self.contentView addSubview:container];
        
        self.contentView.layer.borderWidth = 0.f;
        self.contentView.layer.borderColor = [UIColor clearColor].CGColor;
        self.contentView.backgroundColor = [[UIColor fromRGB:0x184977] colorWithAlphaComponent:0.25f];
    }
    return self;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
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
