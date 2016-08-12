//
//  CenterTitle.m
//  WashMe
//
//  Created by Ivan Korotkikh on 11.08.16.
//  Copyright © 2016 Almas Adilbek. All rights reserved.
//

#import "CenterTitle.h"

@implementation CenterTitle

-(id)initWithTitle:(NSString *)title width:(CGFloat)width
{
    self = [super initWithFrame:CGRectMake(0, 0, width, 1)];
    if(self) {
        self.backgroundColor = [UIColor clearColor];
        self.font = [UIFont robotoRegular:14];
        self.textColor = [UIColor whiteColor];
        self.textAlignment = NSTextAlignmentCenter;
        self.numberOfLines = 0;
        self.lineBreakMode = NSLineBreakByWordWrapping;
        self.text = title;
    }
    return self;
}

@end
