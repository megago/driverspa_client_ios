//
//  RowButtonDropdownView.m
//  WashMe
//
//  Created by Almas Adilbek on 1/3/15.
//  Copyright (c) 2015 Almas Adilbek. All rights reserved.
//

#import "RowButtonDropdownView.h"

@implementation RowButtonDropdownView

-(id)initWithIcon:(NSString *)iconName title:(NSString *)title target:(id)target selector:(SEL)_selector {
    self = [super initWithIcon:iconName title:title target:target selector:_selector];
    if(self) {

    }
    return self;
}

-(id)initWithWidth:(CGFloat)width icon:(NSString *)iconName title:(NSString *)title target:(id)target selector:(SEL)_selector
{
    self = [super initWithWidth:width icon:iconName title:title target:target selector:_selector];
    if(self) {
        UIImageView *disclosureArrow = [[UIImageView alloc] initWithImage:[UIImage imageWithName:@"icon-disclosure-indicator-white"]];
        CGPoint center = disclosureArrow.center;
        disclosureArrow.transform = CGAffineTransformMakeRotation(M_PI_2);
        disclosureArrow.center = center;
        disclosureArrow.x = self.width - disclosureArrow.width - kRowButtonViewSidePadding;
        disclosureArrow.centerY = self.centerY;
        [self addSubview:disclosureArrow];
    }
    return self;
}

@end
