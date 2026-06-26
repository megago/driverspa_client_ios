//
//  TitleValueView.m
//  Puzzle
//
//  Created by Almas Adilbek on 6/20/14.
//  Copyright (c) 2014 Crystal Spring. All rights reserved.
//

#import "TitleValueView.h"
#import "Version.h"
#import "UIFont+Custom.h"

@implementation TitleValueView {
    UILabel *titleLabel;
    UILabel *valueLabel;
}

-(id)initWithTitle:(NSString *)title value:(NSString *)value width:(CGFloat)width
{
    self = [super initWithFrame:CGRectMake(0, 0, width, 1)];
    if(self) {
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 1)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.alpha = 0.8;
        titleLabel.font = [UIFont robotoRegular:13];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.numberOfLines = 0;
        titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        titleLabel.text = title;
        [titleLabel sizeToFit];
        [self addSubview:titleLabel];

        valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, titleLabel.bottom, width, 1)];
        valueLabel.backgroundColor = [UIColor clearColor];
        valueLabel.font = [UIFont robotoRegular:15];
        valueLabel.textColor = [UIColor whiteColor];
        valueLabel.numberOfLines = 0;
        valueLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self addSubview:valueLabel];
        [self setValue:value];
    }
    return self;
}

- (void)setValue:(NSString *)value
{
    valueLabel.text = value;
    valueLabel.width = self.width;
    [valueLabel sizeToFit];

    valueLabel.y = titleLabel.bottom + 2;

    self.height = valueLabel.bottom;
}

- (NSString *)value {
    return valueLabel.text;
}


@end
