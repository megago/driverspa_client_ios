//
//  SimpleBaseCell.m
//  WashMe
//
//  Created by Almas Adilbek on 11/26/14.
//  Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

#import "SimpleBaseCell.h"
#import "UIView+Ext.h"

@implementation SimpleBaseCell

-(id)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if(self) {

        self.backgroundColor = [UIColor clearColor];
        self.selectedBackgroundView = [UIView cellSelectionBackground];

        line = [[UIView alloc] initWithFrame:CGRectMake(10, 0, [ASize screenWidth] - 20, 0.5)];
        [line setBackgroundColor:[UIColor whiteColor]];
        line.alpha = 0.2;
        [self addSubview:line];

    }
    return self;
}

+(CGFloat)titleWidth {
    return [ASize screenWidth] - kPaddingTitleLeft - kPaddingTitleRight;
}

@end
