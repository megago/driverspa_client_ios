//
//  CarTypesTabbarView.m
//  WashMe
//
//  Created by Almas Adilbek on 10/5/14.
//  Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

#import "CarTypesTabbarView.h"
#import "UIFont+Custom.h"
#import "CarwashRefs.h"
#import "Cache.h"
#import "IdTitleObject.h"

@implementation CarTypesTabbarView {
    UIScrollView *sv;
}

-(id)initWithCarTypeIds:(NSArray *)carTypesIds
{
    self = [super initWithFrame:CGRectMake(0, 0, [ASize screenWidth], 85)];
    if(self)
    {
        sv = [[UIScrollView alloc] initWithFrame:self.bounds];
        [sv setAlwaysBounceHorizontal:YES];
        sv.showsHorizontalScrollIndicator = NO;
        sv.showsVerticalScrollIndicator = NO;
        [self addSubview:sv];

        NSDictionary *carTypesDictionary = [[Cache carwashRefs] carTypesDictionary];

        CGFloat nextX = 10;
        CGFloat contentWidth = 0;

        for(id carTypeId in carTypesIds)
        {
            NSString *iconName = [NSString stringWithFormat:@"cartype%@", carTypeId];
            UIImage *normalImage = [UIImage imageWithName:[NSString stringWithFormat:@"btn_%@_normal", iconName]];
            UIImage *selectedImage = [UIImage imageWithName:[NSString stringWithFormat:@"btn_%@_selected", iconName]];

            // Normal
            UIView *normalButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 97, self.height)];
            normalButtonView.opaque = NO;

            UIImageView *normalImageView = [[UIImageView alloc] initWithImage:normalImage];
            normalImageView.alpha = 0.5;
            normalImageView.y = 15;
            normalImageView.centerX = normalButtonView.middleX;
            [normalButtonView addSubview:normalImageView];

            // Selected
            UIView *selectedButtonView = [[UIView alloc] initWithFrame:normalButtonView.bounds];
            selectedButtonView.opaque = NO;
            selectedButtonView.layer.borderWidth = 1;
            selectedButtonView.layer.borderColor = [UIColor whiteColor].CGColor;

            UIImageView *selectedImageView = [[UIImageView alloc] initWithImage:selectedImage];
            selectedImageView.y = normalImageView.y;
            selectedImageView.centerX = normalButtonView.middleX;
            [selectedButtonView addSubview:selectedImageView];


            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = [carTypeId integerValue];
            button.width = normalButtonView.width;
            button.height = self.height;
            button.x = nextX;

            [button setImage:[UIImage imageWithView:normalButtonView] forState:UIControlStateNormal];
            [button setImage:[UIImage imageWithView:selectedButtonView] forState:UIControlStateSelected];
            [button setImage:[UIImage imageWithView:selectedButtonView] forState:UIControlStateHighlighted];

            [sv addSubview:button];

            // Select default tab
            if([carTypeId integerValue] == self.carType) {
                button.selected = YES;
            }

            IdTitleObject *carType = carTypesDictionary[carTypeId];

            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, selectedButtonView.width - 15, 1)];
            titleLabel.backgroundColor = [UIColor clearColor];
            titleLabel.font = [UIFont robotoRegular:10];
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
            titleLabel.numberOfLines = 0;
            titleLabel.textColor = [UIColor whiteColor];
            titleLabel.text = carType.title;
            [titleLabel sizeToFit];
            titleLabel.centerX = button.middleX + button.x;
            titleLabel.y = 50;
            [sv addSubview:titleLabel];

            contentWidth = button.right;
            nextX = button.right - 1;
        }

        CGSize size = sv.contentSize;
        size.width = contentWidth + 10;
        sv.contentSize = size;
    }
    return self;
}

- (void)setCarType:(CarType)carType
{
    if(carType > 0) {
        UIButton *button = [sv viewWithTag:carType];
        if(button) {
            _carType = carType;
            button.selected = YES;
            [self.delegate carTypesTabbarViewDidChangeTabWithType:carType];
        }
    }
}

#pragma mark -
#pragma mark Actions

- (void)buttonTapped:(UIButton *)buttonTapped
{
    CarType type = (CarType) buttonTapped.tag;
    if(_carType != type) {
        self.carType = type;
        [self unselectAllButtons];
        buttonTapped.selected = YES;

        [self.delegate carTypesTabbarViewDidChangeTabWithType:type];
    }
}

#pragma mark -
#pragma mark Helper

-(void)unselectAllButtons {
    for(id subview in sv.subviews) {
        if([subview isKindOfClass:[UIButton class]]) {
            [(UIButton *)subview setSelected:NO];
        }
    }
}

@end
