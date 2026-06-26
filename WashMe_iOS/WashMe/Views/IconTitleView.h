//
// Created by Almas Adilbek on 9/25/14.
// Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface IconTitleView : UIView

@property(nonatomic, strong) UILabel *titleLabel;

-(IconTitleView *)initWithIcon:(NSString *)iconName title:(NSString *)title;

@end