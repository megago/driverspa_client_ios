//
//  SimpleCheckboxCell.m
//  WashMe
//
//  Created by Almas Adilbek on 10/5/14.
//  Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

#import "SimpleCheckboxCell.h"
#import "UIView+Ext.h"
#import "UIFont+Custom.h"
#import "IdTitleObject.h"

@implementation SimpleCheckboxCell {

}

-(void)setIsChecked:(BOOL)isChecked {
    _isChecked = isChecked;
    if(_isChecked) {
//        self.accessoryType = UITableViewCellAccessoryCheckmark;
        self.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageWithName:@"icon-checkmark"]];
    } else {
//        self.accessoryType = UITableViewCellAccessoryNone;
        self.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageWithName:@"icon-checkmark-off"]];
    }
}

@end
