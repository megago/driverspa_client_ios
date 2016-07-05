//
// Created by Almas Adilbek on 9/27/14.
// Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

#import "RowButtonView.h"
#import "UIFont+Custom.h"
#import "ButtonView.h"


@implementation RowButtonView {
    UIView *topLine;
    UILabel *titleLabel;
    UIImageView *iconView;

    BOOL hasIcon;
    RowButtonViewOnTapBlock _buttonViewOnTapBlock;
}

#pragma mark -
#pragma mark With selector

- (id)initWithTitle:(NSString *)title target:(id)target selector:(SEL)_selector {
    return [self initWithIcon:nil title:title target:target selector:_selector];
}

- (id)initWithIcon:(NSString *)iconName title:(NSString *)title target:(id)target selector:(SEL)_selector {
    return [self initWithWidth:kContentWidth icon:iconName title:title target:target selector:_selector];
}

- (id)initWithWidth:(CGFloat)width icon:(NSString *)iconName title:(NSString *)title target:(id)target selector:(SEL)_selector {
    return [self initWithWidth:width icon:iconName title:title onTap:nil target:target selector:_selector];
}

#pragma mark -
#pragma mark With block

- (id)initWithTitle:(NSString *)title onTap:(RowButtonViewOnTapBlock)block {
    return [self initWithIcon:nil title:title onTap:block];
}

- (id)initWithIcon:(NSString *)iconName title:(NSString *)title onTap:(RowButtonViewOnTapBlock)block {
    return [self initWithWidth:kContentWidth icon:iconName title:title onTap:block];
}

- (id)initWithWidth:(CGFloat)width icon:(NSString *)iconName title:(NSString *)title onTap:(RowButtonViewOnTapBlock)block {
    return [self initWithWidth:width icon:iconName title:title onTap:block target:nil selector:nil];
}

- (id)initWithWidth:(CGFloat)width icon:(NSString *)iconName title:(NSString *)title onTap:(RowButtonViewOnTapBlock)block target:(id)target selector:(SEL)_selector
{
    self = [super initWithFrame:CGRectMake(0, 0, width, 40)];
    if(self)
    {
        _buttonViewOnTapBlock = block;

        if(!title || (title.length == 0)) {
            title = @" ";
        }

        ButtonView *buttonView;
        if(block) {
            buttonView = [[ButtonView alloc] initWithTarget:self selector:@selector(onTap)];
        } else {
            buttonView = [[ButtonView alloc] initWithTarget:target selector:_selector];
        }
        buttonView.y = 1;
        buttonView.width = self.width;
        buttonView.height = self.height - 1;
        [self addSubview:buttonView];

        topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 1)];
        [topLine setBackgroundColor:[UIColor whiteColor]];
        topLine.alpha = 0.1;
        [self addSubview:topLine];

        if(iconName)
        {
            hasIcon = YES;
            [self setIcon:iconName];
        }

        titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont robotoRegular:16];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        titleLabel.text = title;
        [titleLabel sizeToFit];
        [self addSubview:titleLabel];

        titleLabel.x = [self titleMarginLeft];

        titleLabel.centerY = self.centerY;

        UIView * line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 1)];
        [line2 setBackgroundColor:[UIColor whiteColor]];
        line2.alpha = 0.1;
        line2.y = self.height;
        [self addSubview:line2];

        self.centerX = (CGFloat) ([ASize screenWidth] * 0.5);
    }
    return self;
}

#pragma mark -
#pragma mark Actions

- (void)onTap {
    if(_buttonViewOnTapBlock) {
        _buttonViewOnTapBlock(self);
    }
}


#pragma mark -
#pragma mark Methods

- (void)removeTopLine {
    [topLine removeFromSuperview];
}

- (void)setTitle:(NSString *)title {
    titleLabel.text = title;
    [titleLabel sizeToFit];
    titleLabel.x = [self titleMarginLeft];
}

- (void)setIcon:(NSString *)iconName
{
    if(iconView) {
        [iconView removeFromSuperview];
        iconView = nil;
    }

    if(iconName) {
        hasIcon = YES;
        iconView = [[UIImageView alloc] initWithImage:[UIImage imageWithName:iconName]];
        iconView.centerX = (CGFloat) ([self titleMarginLeft] * 0.5);
        iconView.centerY = self.middleY;
        [self addSubview:iconView];

        titleLabel.x = [self titleMarginLeft];
    } else {
        hasIcon = NO;
    }
}

#pragma mark -
#pragma mark Helper

-(CGFloat)titleMarginLeft {
    return hasIcon?45:kRowButtonViewSidePadding;
}

#pragma mark - Dealloc

- (void)dealloc {
    _buttonViewOnTapBlock = nil;
}


@end