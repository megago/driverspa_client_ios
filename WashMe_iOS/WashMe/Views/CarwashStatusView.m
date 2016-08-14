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
        self.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:0.5f];
        
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