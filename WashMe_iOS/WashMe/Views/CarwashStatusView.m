//
// Created by Almas Adilbek on 9/15/14.
// Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

#import "CarwashStatusView.h"


@implementation CarwashStatusView {
    UIImageView *statusImageView;
}

-(id)init {
    self = [super initWithFrame:CGRectMake(0, 0, 11, 11)];
    if(self) {
        statusImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:statusImageView];
    }
    return self;
}

-(void)setIsAvailable:(BOOL)isAvailable {
    _isAvailable = isAvailable;
    statusImageView.image = [UIImage imageNamed:isAvailable?@"icon-status-green":@"icon-status-red"];
}

@end