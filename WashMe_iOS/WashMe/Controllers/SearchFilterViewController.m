//
//  SearchFilterViewController.m
//  WashMe
//
//  Created by Almas Adilbek on 3/30/16.
//  Copyright (c) 2016 Almas Adilbek. All rights reserved.
//

#import <ConcisePureLayout/UIView+ConcisePureLayout.h>
#import <UIActionSheet+Blocks/UIActionSheet+Blocks.h>
#import "SearchFilterViewController.h"
#import "FilterManager.h"
#import "UIViewController+Ext.h"
#import "UIViewController+NavigationBar.h"
#import "ALView+PureLayout.h"
#import "RowButtonDropdownView.h"
#import "NSNumber+ObjectiveSugar.h"
#import "NSArray+ObjectiveSugar.h"
#import "Cache.h"
#import "CarwashRefs.h"
#import "RowButtonCheckmarkView.h"
#import "IdTitleObject.h"
#import "AAButton+Styles.h"

#define kDefaultDistance 30

@interface SearchFilterViewController ()
@property(nonatomic, assign) CGFloat maxPrice;
@property(nonatomic, copy) NSString *ratingStars;
@property(nonatomic, strong) NSMutableArray *selectedAdditionalInfos;
@end

@implementation SearchFilterViewController {
    UILabel *_distanceLabel;
    RowButtonDropdownView *_priceList;
    RowButtonDropdownView *_ratingRow;
}

- (id)init
{
    self = [super init];
    if(self) {
        [self initVars];
    }
    return self;
}


-(void)initVars {
    self.selectedAdditionalInfos = [[NSMutableArray alloc] init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    __weak SearchFilterViewController * weakSelf = self;
    [Cache carwashRefs:^(id obj) {
        [weakSelf buildUI];
        [weakSelf setValues];
    }];
}

- (void)setValues {
    // Distance
    CGFloat distance;
    if(self.filterManager.maxDistance) {
        distance = self.filterManager.maxDistance.floatValue;
    } else {
        distance = [@(kDefaultDistance) floatValue];
    }
    _distanceLabel.text = [NSString stringWithFormat:@"%.01f км", distance];

    // Max price
    if(self.filterManager.maxPrice) {
        self.maxPrice = [self.filterManager.maxPrice floatValue];
    } else {
        self.maxPrice = 1000;
    }

    // Rating
    NSMutableString *stars = [NSMutableString new];
    if(self.filterManager.rating) {
        [self.filterManager.rating times:^{
            [stars appendString:@"★"];
        }];
        self.ratingStars = stars;
    } else {
        self.ratingStars = @"★★★★★";
    }

    // Comforts
    if(self.filterManager.comforts) {
        self.selectedAdditionalInfos = self.filterManager.comforts;
    }
}

#pragma mark -
#pragma mark Actions

- (void)sliderChanged:(UISlider *)slider {
    _distanceLabel.text = [NSString stringWithFormat:@"%.01f км", slider.value];
}

- (void)tapMaxPrice {
    NSMutableArray *prices = [NSMutableArray array];
    [@10 timesWithIndex:^(NSUInteger index) {
        [prices addObject:[NSString stringWithFormat:@"%@", @(1000 + index * 500)]];
    }];

    [UIActionSheet showInView:self.view
                    withTitle:@"Максимальная цена"
            cancelButtonTitle:@"Отмена"
       destructiveButtonTitle:nil
            otherButtonTitles:prices
                     tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
        if(buttonIndex != actionSheet.cancelButtonIndex) {
            NSString *option = prices[buttonIndex];
            [self setMaxPrice:option.floatValue];
        }
    }];
}

- (void)tapRating {
    NSMutableArray * options = [NSMutableArray array];
    [@5 timesWithIndex:^(NSUInteger index) {
        NSMutableString *option = [@"" mutableCopy];
        [@(index + 1) timesWithIndex:^(NSUInteger index2) {
            [option appendString:@"★"];
        }];
        [options addObject:option];
    }];

    options = [[options reverse] mutableCopy];

    [UIActionSheet showInView:self.view
                    withTitle:@"Рейтинг"
            cancelButtonTitle:@"Отмена"
       destructiveButtonTitle:nil
            otherButtonTitles:options
                     tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
        if(buttonIndex != actionSheet.cancelButtonIndex) {
            self.ratingStars = options[buttonIndex];
        }
    }];
}

- (void)additionalInfoRowTapped:(RowButtonCheckmarkView *)row {
    if(row.isChecked) {
        [self.selectedAdditionalInfos addObject:row.data];
    } else {
        [self.selectedAdditionalInfos removeObject:row.data];
    }
}

- (void)tapSearch
{
    self.filterManager.maxPrice = @(self.maxPrice);
    self.filterManager.rating = @(self.ratingStars.length);

    if(self.selectedAdditionalInfos.count > 0) {
        self.filterManager.comforts = self.selectedAdditionalInfos;
    } else {
        self.filterManager.comforts = nil;
    }

    [self.delegate SearchFilterViewControllerSearchWithFilter:self.filterManager];
}

#pragma mark -
#pragma mark Helper

- (void)setMaxPrice:(CGFloat)price {
    _maxPrice = price;
    [_priceList setTitle:[NSString stringWithFormat:@"%@ ₸", @(price)]];
}

- (void)setRatingStars:(NSString *)ratingStars {
    _ratingStars = ratingStars;
    [_ratingRow setTitle:[NSString stringWithFormat:@"Рейтинг:  %@", ratingStars]];
}

#pragma mark -

- (void)buildUI {
    UILabel *textLabel = [UILabel newAutoLayoutView];
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.font = [UIFont systemFontOfSize:14];
    textLabel.textColor = [UIColor whiteColor];
    textLabel.text = @"Отображать мойки в радиусе:";
    textLabel.numberOfLines = 0;
    textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.contentView addSubview:textLabel];
    [textLabel aa_superviewTop:10];
    [textLabel aa_superviewLeft:kViewControllerPadding];
    [textLabel aa_setWidth:180 relation:NSLayoutRelationGreaterThanOrEqual];

    _distanceLabel = [UILabel newAutoLayoutView];
    _distanceLabel.backgroundColor = [UIColor clearColor];
    _distanceLabel.font = [UIFont boldSystemFontOfSize:15];
    _distanceLabel.textColor = [UIColor whiteColor];
    [self.contentView addSubview:_distanceLabel];
    [_distanceLabel aa_top:textLabel];
    [_distanceLabel aa_superviewRight:kViewControllerPadding];
    [textLabel aa_pinBeforeView:_distanceLabel offset:15];

    UISlider *slider = [UISlider newAutoLayoutView];
    [slider addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
    slider.tintColor = [UIColor yellowColor];
    slider.minimumValue = 0.5;
    slider.maximumValue = 100;
    slider.value = kDefaultDistance;
    [self.contentView addSubview:slider];
    [slider aa_pinUnderView:textLabel offset:15];
    [slider aa_superviewFitWidthWithInset:kViewControllerPadding];

    UILabel *priceTitleLabel = [UILabel newAutoLayoutView];
    priceTitleLabel.backgroundColor = [UIColor clearColor];
    priceTitleLabel.font = [UIFont systemFontOfSize:11];
    priceTitleLabel.textColor = [UIColor whiteColor];
    priceTitleLabel.text = @"Максимальная цена";
    [self.contentView addSubview:priceTitleLabel];
    [priceTitleLabel aa_pinUnderView:slider offset:20];
    [priceTitleLabel aa_superviewFitWidthWithInset:kViewControllerPadding];

    _priceList = [[RowButtonDropdownView alloc] initWithWidth:kContentWidth icon:nil title:@"" target:self selector:@selector(tapMaxPrice)];
    [_priceList removeTopLine];
    [_priceList aa_setDimensions];
    [self.contentView addSubview:_priceList];
    [_priceList aa_pinUnderView:priceTitleLabel];
    [_priceList aa_centerHorizontal];

    _ratingRow = [[RowButtonDropdownView alloc] initWithTitle:@"" target:self selector:@selector(tapRating)];
    [_ratingRow removeTopLine];
    [self.contentView addSubview:_ratingRow];
    [_ratingRow aa_setDimensions];
    [_ratingRow aa_pinUnderView:_priceList];
    [_ratingRow aa_superviewFitWidthWithInset:kViewControllerPadding];

    NSArray *addInfos = [Cache carwashRefs].additionalInfos;
    __block UIView *prevView = _ratingRow;
    __weak SearchFilterViewController * weakSelf = self;

    [addInfos eachWithIndex:^(IdTitleObject *object, NSUInteger index)
    {
        RowButtonCheckmarkView *row = [[RowButtonCheckmarkView alloc] initWithTitle:object.title onTap:^(id rowButtonView) {
            [weakSelf additionalInfoRowTapped:rowButtonView];
        }];
        row.data = object;
        row.translatesAutoresizingMaskIntoConstraints = NO;
        [row aa_setDimensions];
        [weakSelf.contentView addSubview:row];
        [row aa_pinUnderView:prevView offset:![prevView isEqual:_ratingRow] ? 0 : 15];
        [row aa_leadingAndTrailing:_ratingRow];

        if([prevView isEqual:_ratingRow]) {
            [row removeTopLine];
        }

        prevView = row;
    }];

    AAButton *addButton = [[AAButton alloc] initWithWidth:150 onTap:^(UIView *_self) {
        [weakSelf tapSearch];
    }];
    [addButton commonStyleButtonWithTitle:@"Поиск"];
    [addButton setTitleFont:[UIFont robotoRegular:18]];
    addButton.height = 40;
    [self.contentView addSubview:addButton];
    [addButton aa_setDimensions];
    [addButton aa_pinUnderView:prevView offset:25];
    [addButton aa_centerHorizontal];
    [addButton aa_superviewBottom:15];
}

-(void)configUI
{
    [super configUI];
    [self setBlueBackground];
    [self setNavigationBarTransparent];
    [self setNavigationCloseAtLeft:NO];
    self.title = @"Фильтры";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc {

}

@end
