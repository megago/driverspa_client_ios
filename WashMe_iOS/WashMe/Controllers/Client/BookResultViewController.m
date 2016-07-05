//
//  BookResultViewController.m
//  WashMe
//
//  Created by Almas Adilbek on 10/9/14.
//  Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

#import "BookResultViewController.h"
#import "UIViewController+Ext.h"
#import "UIScrollView+Ext.h"
#import "AAButton+Styles.h"
#import "CarwashComplex.h"
#import "TitleValueView.h"
#import "BookObject.h"
#import "User.h"
#import "CarwashRefs.h"
#import "Cache.h"
#import "CarwashesViewController.h"
#import "UserBookingsViewController.h"
#import "FavoritesViewController.h"

@interface BookResultViewController ()
@end

@implementation BookResultViewController

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
    [self configAction];
}

- (void)configAction
{

}

#pragma mark -
#pragma mark Actions

- (void)okTapped {
    NSArray *viewControllers = self.navigationController.viewControllers;
    for(id vc in viewControllers)
    {
        BOOL isUserBookingsVC = [vc isKindOfClass:[UserBookingsViewController class]];
        if([vc isKindOfClass:[CarwashesViewController class]] || [vc isKindOfClass:[FavoritesViewController class]] || isUserBookingsVC)
        {
            if(isUserBookingsVC) {
                // Send notification to userBookingsVC to refresh the list
                [[NSNotificationCenter defaultCenter] postNotificationName:kUserBookEditedNotification object:nil];
            }
            [self.navigationController popToViewController:vc animated:YES];
            break;
        }
    }
}

#pragma mark -

-(void)configUI
{
    [super configUI];

    [self setBlueBackground];
    [self setNavigationTitle:@"Бронирование успешно"];

    UILabel *subtitle = [sv setNavigationSubtitle:_bookObject.carwash.name];
    subtitle.y = 10;

    User *user = [User currentUser];
    CarwashRefs *carwashRefs = [Cache carwashRefs];

    // Infos
    CGFloat rowWidth = [ASize screenWidth] - 50;
    CGFloat rowsSpacing = 10;

    TitleValueView *row1 = [[TitleValueView alloc] initWithTitle:@"Адрес:" value:_bookObject.carwash.address width:rowWidth];
    row1.centerX = sv.centerX;
    row1.y = subtitle.bottom + 20;
    [sv addSubview:row1];

    TitleValueView *row2 = [[TitleValueView alloc] initWithTitle:@"Телефон:" value:_bookObject.carwash.contactsMobilePhone width:rowWidth];
    row2.centerX = sv.centerX;
    row2.y = row1.bottom + rowsSpacing;
    [sv addSubview:row2];

    TitleValueView *row3 = [[TitleValueView alloc] initWithTitle:@"Имя:" value:[user fio] width:rowWidth];
    row3.centerX = sv.centerX;
    row3.y = row2.bottom + 30;
    [sv addSubview:row3];

    TitleValueView *row4 = [[TitleValueView alloc] initWithTitle:@"Телефон: " value:user.mobile width:rowWidth];
    row4.centerX = sv.centerX;
    row4.y = row3.bottom + rowsSpacing;
    [sv addSubview:row4];

    TitleValueView *row5 = [[TitleValueView alloc] initWithTitle:@"Гос.номер " value:@"user.carNumber" width:rowWidth];
    row5.centerX = sv.centerX;
    row5.y = row4.bottom + rowsSpacing;
    [sv addSubview:row5];

    TitleValueView *row6 = [[TitleValueView alloc] initWithTitle:@"Марка авто: " value:@"user.carModel" width:rowWidth];
    row6.centerX = sv.centerX;
    row6.y = row5.bottom + rowsSpacing;
    [sv addSubview:row6];

    TitleValueView *row7 = [[TitleValueView alloc] initWithTitle:@"Тип авто: " value:[carwashRefs carTypeTitle:@(_bookObject.carType)] width:rowWidth];
    row7.centerX = sv.centerX;
    row7.y = row6.bottom + rowsSpacing;
    [sv addSubview:row7];

    TitleValueView *row8 = [[TitleValueView alloc] initWithTitle:@"Услуги: " value:[_bookObject servicesTitles] width:rowWidth];
    row8.centerX = sv.centerX;
    row8.y = row7.bottom + rowsSpacing;
    [sv addSubview:row8];

    TitleValueView *row9 = [[TitleValueView alloc] initWithTitle:@"Стоимость: " value:[_bookObject localizedPrice] width:rowWidth];
    row9.centerX = sv.centerX;
    row9.y = row8.bottom + rowsSpacing;
    [sv addSubview:row9];

    TitleValueView *row10 = [[TitleValueView alloc] initWithTitle:@"Дата и время: " value:[_bookObject prettyTime] width:rowWidth];
    row10.centerX = sv.centerX;
    row10.y = row9.bottom + rowsSpacing;
    [sv addSubview:row10];

    UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, row10.bottom + 30, 250, 1)];
    messageLabel.backgroundColor = [UIColor clearColor];
    messageLabel.font = [UIFont robotoRegular:14];
    messageLabel.textColor = [UIColor whiteColor];
    messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
    messageLabel.numberOfLines = 0;
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.text = @"На указанный Вами мобильный телефон придет СМС-сообщение с деталями брони. \n"
            "Для подтверждения брони вам позвонит администратор автомойки.\n"
            "\n"
            "Спасибо, что выбрали нас!";
    [messageLabel sizeToFit];
    messageLabel.centerX = sv.centerX;
    [sv addSubview:messageLabel];

    __weak BookResultViewController *wSelf = self;
    AAButton *okButton = [[AAButton alloc] initWithWidth:100 onTap:^(UIView *_self) {
        [wSelf okTapped];
    }];
    [okButton commonStyleButtonWithTitle:@"OK"];
    [okButton setTitleFont:[UIFont robotoRegular:18]];
    okButton.centerX = self.view.centerX;
    okButton.y = messageLabel.bottom + 30;
    okButton.height = 40;
    [sv addSubview:okButton];

    [sv setContentSizeHeight:okButton.bottom + 20];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc {

}

@end
