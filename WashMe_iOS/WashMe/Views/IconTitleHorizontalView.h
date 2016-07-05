//
//  IconTitleHorizontalView.h
//  Zenge
//
//  Created by Almas Adilbek on 11/25/15.
//  Copyright (c) 2015 Zenge. All rights reserved.
//



@interface IconTitleHorizontalView : UIView

@property(nonatomic, strong) UIImageView *iconView;
@property(nonatomic, strong) UILabel *titleLabel;

- (id)initWithIcon:(NSString *)iconName title:(NSString *)title;
- (id)initWithIcon:(NSString *)iconName title:(NSString *)title spacing:(CGFloat)spacing;

- (void)setText:(NSString *)text;

@end
