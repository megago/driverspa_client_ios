//
//  CarwashMarkerInfoWindowView.m
//  WashMe
//
//  Created by Almas Adilbek on 4/4/16.
//  Copyright (c) 2016 Almas Adilbek. All rights reserved.
//

#import <ConcisePureLayout/UIView+ConcisePureLayout.h>
#import <ObjectiveSugar/NSArray+ObjectiveSugar.h>
#import "CarwashComplex.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <AMRatingControl/AMRatingControl.h>
#import "CarwashMarkerInfoWindowView.h"
#import "DoubleCell.h"
#import "IconTitleHorizontalView.h"
#import "UIColor+Chameleon.h"
#import "UIView+Loader.h"
#import "ImageBundle.h"
#import "ObjectImage.h"
#import "CarwashApi.h"

#define kPadding 10

@interface CarwashMarkerInfoWindowView()<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, strong) UITableView *list;
@property(nonatomic, strong) NSArray *heights;
@end

@implementation CarwashMarkerInfoWindowView {
    UILabel *_loadingLabel;
}

- (id)init {
    self = [super initWithFrame:CGRectMake(0, 0, 290, 1)];
    if(self) {

        self.heights = @[@(35), @(66), @(40), @(40)];
        CGFloat padding = 5;
        CGFloat arrowOffset = 10;

        __block CGFloat listHeight = 0;
        [self.heights each:^(NSNumber *object) {
            listHeight += object.integerValue;
        }];

        self.height = listHeight + arrowOffset + 2 * padding;
        [self aa_setDimensions];

        self.list = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _list.delegate = self;
        _list.dataSource = self;
        _list.separatorColor = [UIColor clearColor];
        _list.allowsSelection = NO;
        _list.layer.cornerRadius = 6;
        _list.clipsToBounds = YES;
        [self addSubview:_list];
        [_list aa_superviewTop:padding left:padding bottom:arrowOffset + padding right:padding];

        UIImageView *arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shapeMarkerArrow.png"]];
        [arrow aa_setDimensions];
        [self insertSubview:arrow belowSubview:_list];
        [arrow aa_centerHorizontal];
        [arrow aa_superviewBottom:padding];
        
        // Loading text.
        _loadingLabel = [UILabel newAutoLayoutView];
        _loadingLabel.backgroundColor = [UIColor clearColor];
        _loadingLabel.font = [UIFont systemFontOfSize:14];
        _loadingLabel.textColor = [UIColor grayColor];
        _loadingLabel.text = @"Загрузка";
        [self addSubview:_loadingLabel];
        [_loadingLabel aa_centerInSuperview];

        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowRadius = 3;
        self.layer.shadowOffset = CGSizeMake(0, 5);
        self.layer.shadowOpacity = 0.25;
    }
    return self;
}

- (void)setCarwash:(CarwashComplex *)carwash
{
    [_loadingLabel removeFromSuperview];

    _carwash = carwash;
    [self removeLoader];
    [self.list reloadData];
    
//    NSLog(@"%@", _carwash);
//    __weak CarwashMarkerInfoWindowView * weakSelf = self;
//    [CarwashApi getCarwashDetails:carwash.carwashId success:^(id response) {
//        _carwash = response;
//        [weakSelf.list reloadData];
//    } failure:^(NSInteger code, NSString *message) {
//        
//    }];
}

#pragma mark -
#pragma mark UITableView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.carwash ? self.heights.count : 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSNumber *object = self.heights[indexPath.row];
    return object.floatValue;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch(indexPath.row)
    {
        case 0:
        {
            static NSString* CellIdentifier1 = @"row1";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier1];
                
                UILabel *priceLabel = [UILabel newAutoLayoutView];
                priceLabel.tag = 10;
                priceLabel.backgroundColor = [UIColor clearColor];
                priceLabel.font = [UIFont robotoRegular:14];
                priceLabel.textColor = [UIColor blackColor];
                [cell.contentView addSubview:priceLabel];
                [priceLabel aa_superviewLeft:kPadding];
                [priceLabel aa_centerVertical];

                [self insertButtomLineInCell:cell];
            }

            UILabel *priceLabel = [cell.contentView viewWithTag:10];
            priceLabel.text = [NSString stringWithFormat:@"от %@ тг.", self.carwash.price];

            return cell;
        }

        case 1:
        {
            static NSString *CellIdentifier2 = @"row2";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier2];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

                UIImageView *imageView = [UIImageView newAutoLayoutView];
                imageView.tag = 10;
                imageView.contentMode = UIViewContentModeScaleAspectFill;
                [cell.contentView addSubview:imageView];
                [imageView aa_setWidth:60];
                [imageView aa_superviewTop:kPadding];
                [imageView aa_superviewLeft:kPadding];
                [imageView aa_superviewBottom:kPadding];

                UILabel *titleLabel = [UILabel newAutoLayoutView];
                titleLabel.tag = 11;
                titleLabel.backgroundColor = [UIColor clearColor];
                titleLabel.font = [UIFont robotoBold:14];
                titleLabel.textColor = [UIColor blackColor];
                titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
                [cell.contentView addSubview:titleLabel];
                [titleLabel aa_pinAfterView:imageView offset:kPadding];
                [titleLabel aa_top:imageView];
                [titleLabel aa_superviewRight:35];

                UILabel *descLabel = [UILabel newAutoLayoutView];
                descLabel.tag = 12;
                descLabel.backgroundColor = [UIColor clearColor];
                descLabel.font = [UIFont systemFontOfSize:14];
                descLabel.textColor = [UIColor lightGrayColor];
                descLabel.numberOfLines = 2;
                descLabel.lineBreakMode = NSLineBreakByWordWrapping;
                [cell.contentView addSubview:descLabel];
                [descLabel aa_pinUnderView:titleLabel offset:0];
                [descLabel aa_leadingAndTrailing:titleLabel];

                [self insertButtomLineInCell:cell];
            }

            UIImageView *imageView = [cell.contentView viewWithTag:10];
            UILabel *titleLabel = [cell.contentView viewWithTag:11];
            UILabel *descLabel = [cell.contentView viewWithTag:12];

            if(self.carwash.carwashImages.count > 0) {
                ImageBundle *imageBundle = self.carwash.carwashImages[0];
                [imageView sd_setImageWithURL:imageBundle.medium.URL];
            }
            titleLabel.text = self.carwash.name;
            descLabel.text = self.carwash.address;

            return cell;
        }

        case 2:
        {
            static NSString *CellIdentifier3 = @"row3";
            DoubleCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier3];

            if (cell == nil) {
                cell = [[DoubleCell alloc] initWithReuseIdentifier:CellIdentifier3];

                IconTitleHorizontalView *view1 = [[IconTitleHorizontalView alloc] initWithIcon:@"iconTelBlue" title:@""];
                view1.tag = 10;
                view1.titleLabel.textColor = [UIColor flatBlackColor];
                [cell.leftView addSubview:view1];
                [view1 aa_superviewLeft:kPadding];
                [view1 aa_centerVertical];

                IconTitleHorizontalView *view2 = [[IconTitleHorizontalView alloc] initWithIcon:@"iconTimetableBlue" title:@""];
                view2.tag = 11;
                view2.titleLabel.textColor = [UIColor flatBlackColor];
                [cell.rightView addSubview:view2];
                [view2 aa_superviewLeft:kPadding];
                [view2 aa_centerVertical];

                [self insertButtomLineInCell:cell];
            }

            IconTitleHorizontalView *view1 = [cell viewWithTag:10];
            view1.titleLabel.text = self.carwash.contactsMobilePhone;

            IconTitleHorizontalView *view2 = [cell viewWithTag:11];
            view2.titleLabel.text = @"Круглосуточно";

            return cell;
        }
            break;

        case 3:
        {
            static NSString *CellIdentifier4 = @"row4";
            DoubleCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier4];

            if (cell == nil) {
                cell = [[DoubleCell alloc] initWithReuseIdentifier:CellIdentifier4];

                AMRatingControl *ratingView = [[AMRatingControl alloc] initWithLocation:CGPointMake(kPadding, 0)
                                                                 emptyImage:[UIImage imageNamed:@"starYellow"]
                                                                 solidImage:[UIImage imageNamed:@"starYellowSelected"]
                                                               andMaxRating:5];
                ratingView.tag = 10;
                ratingView.userInteractionEnabled = NO;
                [cell.leftView addSubview:ratingView];
                ratingView.translatesAutoresizingMaskIntoConstraints = NO;
                [ratingView aa_setDimensions];
                [ratingView aa_superviewLeft:kPadding];
                [ratingView aa_centerVertical];

                IconTitleHorizontalView *view2 = [[IconTitleHorizontalView alloc] initWithIcon:@"iconComment" title:@""];
                view2.tag = 11;
                view2.titleLabel.textColor = [UIColor flatBlackColor];
                [cell.rightView addSubview:view2];
                [view2 aa_superviewLeft:0];
                [view2 aa_centerVertical];
            }

            AMRatingControl *ratingView = [cell.leftView viewWithTag:10];
            ratingView.rating = [self.carwash.rating integerValue];

            IconTitleHorizontalView *view2 = [cell viewWithTag:11];
            view2.titleLabel.text = [NSString stringWithFormat:@"%@ отзывов", @(self.carwash.reviews.count)];

            return cell;
        }

        default:
        {
            static NSString* CellIdentifier2 = @"row2";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier2];
            }
            cell.textLabel.text = @"";
            return cell;
        }
            break;
    }

    return nil;
}

- (void)insertButtomLineInCell:(UITableViewCell *)cell {
    UIView * line = [UIView newAutoLayoutView];
    [line aa_setHeight:1];
    [line setBackgroundColor:[UIColor fromRGB:0xeeeeee]];
    [cell addSubview:line];
    [line aa_superviewBottom:0];
    [line aa_superviewFitWidthWithInset:kPadding];
}

@end
