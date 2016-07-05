//
//  SimpleBaseCell.h
//  WashMe
//
//  Created by Almas Adilbek on 11/26/14.
//  Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

#define kPaddingTitleLeft 15
#define kPaddingTitleRight 45
#define kTitleFont [UIFont robotoRegular:16]
#define kTitlePaddingTop 12

@interface SimpleBaseCell : UITableViewCell {
    UIView *line;
    UILabel *titleLabel;
}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;

+ (CGFloat)titleWidth;

@end
