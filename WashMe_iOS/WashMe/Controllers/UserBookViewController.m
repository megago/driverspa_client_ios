//
//  UserBookViewController.m
//  WashMe
//
//  Created by Almas Adilbek on 11/8/14.
//  Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

#import "UserBookViewController.h"
#import "CarwashBook.h"
#import "UIViewController+Ext.h"
#import "UserApi.h"
#import "CarwashApi.h"
#import "Carwash.h"
#import "CarwashMapView.h"
#import "UIScrollView+Ext.h"
#import "TitleValueView.h"
#import "CarwashComplex.h"
#import "CarwashRefs.h"
#import "Cache.h"
#import "AAButton+Styles.h"
#import "UIAlertView+Blocks.h"
#import "CarwashesMapViewController.h"
#import "Toast.h"
#import "BookSetCarViewController.h"
#import "NSString+Ext.h"
#import "BookObject.h"

@interface UserBookViewController ()
@end

@implementation UserBookViewController {
    CarwashComplex *carwash;
    CarwashMapView *carwashMapView;
    CarwashRefs *_carwashRefs;
}

-(id)init {
    self = [super init];
    if(self) {
        [self initVars];
    }
    return self;
}

-(void)initVars {}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configUI];

    [Cache carwashRefs:^(id obj) {
        _carwashRefs = obj;
        [Toast showHudLoading];
        [CarwashApi getCarwashWithResource:self.book.carwash success:^(id response) {
            carwash = response;
            [self buildUI];
            [self configAction];
        } failure:^(NSInteger code, NSString *message) {

        }];
    }];
}

- (void)configAction
{
    // Carwash map tap
    UITapGestureRecognizer *mapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mapTapped)];
    [carwashMapView addGestureRecognizer:mapGes];
}

#pragma mark -
#pragma mark Actions

- (void)mapTapped {
    CarwashesMapViewController *v = [[CarwashesMapViewController alloc] init];
    v.carwashes = @[carwash];
    v.annotationsEnabled = NO;
    v.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:v animated:YES completion:nil];
}
#pragma mark -
#pragma mark Actions

- (void)cancelTapped {
    [UIAlertView showWithTitle:@"Отменить бронирование?" message:@"" cancelButtonTitle:@"Нет" otherButtonTitles:@[@"Да"] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if(buttonIndex != alertView.cancelButtonIndex) {
            [Toast showHudLoading];
            [UserApi cancelBooking:self.book.carwashBookId success:^(id response) {
                [Toast showSuccessToastWithMessage:@"Бронь отменена!"];
                if([self.delegate respondsToSelector:@selector(clientBookViewControllerBookCanceled:)]) {
                    [self.delegate clientBookViewControllerBookCanceled:self.book.carwashBookId];
                }
                [self.navigationController popViewControllerAnimated:YES];
            } failure:^(NSInteger code, NSString *message) {
                [UIHelper showAlertTryAgain];
            }];
        }
    }];
}

- (void)editTapped
{
    BookObject *bookObject = [[BookObject alloc] init];
    bookObject.carType = (CarType) [_book.cartype integerValue];
    bookObject.price = _book.price;
    bookObject.services = [CarwashRefs serviceObjectsWithServiceIds:_book.services];
    bookObject.bookDate = [_book bookDate];
    bookObject.bookTime = [_book bookTime];
    bookObject.bookId = [_book carwashBookId];

    BookSetCarViewController *v = [[BookSetCarViewController alloc] init];
    v.editMode = YES;
    v.carwash = carwash;
    v.bookObject = bookObject;
    [self.navigationController pushViewController:v animated:YES];
}

#pragma mark -

- (void)buildUI
{
    UILabel *nameLabel = [sv setNavigationSubtitle:carwash.name];

    carwashMapView = [[CarwashMapView alloc] initWithCoordinate:carwash.coordinate];
    carwashMapView.centerX = sv.centerX;
    carwashMapView.y = nameLabel.bottom + 15;
    [sv addSubview:carwashMapView];

    // Infos
    CGFloat rowWidth = [ASize screenWidth] - 50;
    CGFloat rowsSpacing = 10;

    TitleValueView *row1 = [[TitleValueView alloc] initWithTitle:@"Адрес:" value:carwash.address width:rowWidth];
    row1.centerX = sv.centerX;
    row1.y = carwashMapView.bottom + 25;
    [sv addSubview:row1];

    TitleValueView *row2 = [[TitleValueView alloc] initWithTitle:@"Телефон:" value:carwash.contactsMobilePhone width:rowWidth];
    row2.centerX = sv.centerX;
    row2.y = row1.bottom + rowsSpacing;
    [sv addSubview:row2];

    TitleValueView *row3 = [[TitleValueView alloc] initWithTitle:@"Дата и время:" value:[self.book localizedPrettyDate] width:rowWidth];
    row3.centerX = sv.centerX;
    row3.y = row2.bottom + rowsSpacing;
    [sv addSubview:row3];

    TitleValueView *row4 = [[TitleValueView alloc] initWithTitle:@"Стоимость:" value:[NSString stringWithFormat:@"%@ тг.", [NSString numberFormattedNumberText:self.book.price]] width:rowWidth];
    row4.centerX = sv.centerX;
    row4.y = row3.bottom + rowsSpacing;
    [sv addSubview:row4];

    TitleValueView *row5 = [[TitleValueView alloc] initWithTitle:@"Услуги:" value:[self.book servicesTitles] width:rowWidth];
    row5.centerX = sv.centerX;
    row5.y = row4.bottom + rowsSpacing;
    [sv addSubview:row5];

    if([_book.status isEqual:kBookStatusPending]) {
        // Edit button
        __weak UserBookViewController *wSelf = self;
        AAButton *editButton = [[AAButton alloc] initWithWidth:kButtonWidth onTap:^(UIView *_self) {
            [wSelf editTapped];
        }];
        [editButton commonStyleButtonWithTitle:@"Изменить бронь"];
        [editButton setTitleFont:[UIFont robotoRegular:18]];
        editButton.centerX = sv.centerX;
        editButton.y = row5.bottom + 25;
        editButton.height = 40;
        [sv addSubview:editButton];

        // Cancel button
        AAButton *cancelButton = [[AAButton alloc] initWithWidth:kButtonWidth onTap:^(UIView *_self) {
            [wSelf cancelTapped];
        }];
        [cancelButton commonStyleButtonWithTitle:@"Отменить бронь"];
        [cancelButton setTitleFont:[UIFont robotoRegular:18]];
        cancelButton.centerX = sv.centerX;
        cancelButton.y = editButton.bottom + 10;
        cancelButton.height = 40;
        [sv addSubview:cancelButton];

        [sv setContentSizeHeight:cancelButton.bottom + 20];
    }
    else
    {
        [sv setContentSizeHeight:row5.bottom + 20];
    }
}

-(void)configUI
{
    [super configUI];
    [self setBackButton];
    [self setBlueBackground];
    [self setNavigationTitle:@"Моя бронь"];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc {

}

@end