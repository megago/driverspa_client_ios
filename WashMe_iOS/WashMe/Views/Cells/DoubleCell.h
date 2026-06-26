//
//  DoubleCell.h
//  WashMe
//
//  Created by Almas Adilbek on 4/5/16.
//  Copyright (c) 2016 Almas Adilbek. All rights reserved.
//



@interface DoubleCell : UITableViewCell

@property(nonatomic, strong) UIView *leftView;
@property(nonatomic, strong) UIView *rightView;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;

@end
