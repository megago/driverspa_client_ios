//
// Created by Almas Adilbek on 9/27/14.
// Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

#import "RowButtonDisclosureView.h"


@implementation RowButtonDisclosureView {

}

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
        disclosureArrow.x = self.width - disclosureArrow.width - kRowButtonViewSidePadding;
        disclosureArrow.centerY = self.centerY;
        [self addSubview:disclosureArrow];
    }
    return self;
}

@end