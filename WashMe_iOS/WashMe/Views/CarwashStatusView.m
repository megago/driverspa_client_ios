//
// Created by Almas Adilbek on 9/15/14.
// Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

#import "CarwashStatusView.h"


@implementation CarwashStatusView {
    UIImageView *statusImageView;
}

-(id)init {
    self = [super initWithFrame:CGRectMake(0, 0, 80, 15)];
    if(self) {
        self.textAlignment = NSTextAlignmentCenter;
        self.font = [UIFont robotoRegular:11.f];
        self.text = @"online запись";
        self.textColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor colorWithRed:37.f/255.f green:195.f/255.f blue:91.f/255.f alpha:1.f];
        
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = self.frame.size.height / 2;
    }
    return self;
}

-(void)setIsAvailable:(BOOL)isAvailable {
    _isAvailable = isAvailable;
    if (isAvailable){
        self.hidden = NO;
    } else {
        self.hidden = YES;
    }
}

@end