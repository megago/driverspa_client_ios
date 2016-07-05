//
//  SimpleDisclosureCell.m
//  WashMe
//
//  Created by Almas Adilbek on 10/25/14.
//  Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

#import "SimpleDisclosureCell.h"

@implementation SimpleDisclosureCell

-(id)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if(self) {
        UIImageView *disclosureIndicator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-disclosure-indicator-white"]];
        self.accessoryView = disclosureIndicator;
    }
    return self;
}

@end
