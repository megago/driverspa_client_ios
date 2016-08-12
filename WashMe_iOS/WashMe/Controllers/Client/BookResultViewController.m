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

#import "UIView+ConcisePureLayout.h"
#import "CarwashBook.h"
#import "CenterTitle.h"
#import "NSString+Ext.h"

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
//    NSArray *viewControllers = self.navigationController.viewControllers;
//    for(id vc in viewControllers)
//    {
//        BOOL isUserBookingsVC = [vc isKindOfClass:[UserBookingsViewController class]];
//        if([vc isKindOfClass:[CarwashesViewController class]] || [vc isKindOfClass:[FavoritesViewController class]] || isUserBookingsVC)
//        {
//            if(isUserBookingsVC) {
//                // Send notification to userBookingsVC to refresh the list
//                [[NSNotificationCenter defaultCenter] postNotificationName:kUserBookEditedNotification object:nil];
//            }
//            [self.navigationController popToViewController:vc animated:YES];
//            break;
//        }
//    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)telTapped
{
    NSString *tel = [_bookObject.carwash contactsMobilePhone];
    if(tel) {
        [UIActionSheet showInView:self.view withTitle:@"Позвонить?" cancelButtonTitle:@"Отмена" destructiveButtonTitle:nil otherButtonTitles:@[tel] tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
            if(buttonIndex != actionSheet.cancelButtonIndex) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", [tel phoneNumberValidForCall]]]];
            }
        }];
    }
}

#pragma mark -

-(void)configUI
{
    [super configUI];
    [self setBackButtonInNavigation];
    [self setBlueBackground];
    [self setNavigationTitle:@"Бронь отправлена"];
    
    User *user = [User currentUser];
    //CarwashRefs *carwashRefs = [Cache carwashRefs];
    
    // Infos
    CGFloat rowWidth = [ASize screenWidth] - 50;
    CGFloat rowsSpacing = 10;
    
    CenterTitle *subtitleLabel = [[CenterTitle alloc] initWithTitle:@"Администратор автомойки в течении 15 минут обработает вашу бронь, а вам прийдет push-уведомление" width:rowWidth];
    subtitleLabel.centerX = sv.centerX;
    subtitleLabel.y = rowsSpacing;
    [sv addSubview:subtitleLabel];

    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, subtitleLabel.bottom + rowsSpacing, rowWidth, 0.5)];
    [line1 setBackgroundColor:[UIColor whiteColor]];
    line1.alpha = 0.2;
    line1.centerX = sv.centerX;
    [sv addSubview:line1];
    
    
    
    
    CenterTitle *secondBlockTitle = [[CenterTitle alloc] initWithTitle:@"Бронь на имя" width:rowWidth];
    secondBlockTitle.centerX = sv.centerX;
    secondBlockTitle.y = line1.bottom + rowsSpacing;
    [sv addSubview:secondBlockTitle];
    
    CenterTitle *nameLabel = [[CenterTitle alloc] initWithTitle:[NSString stringWithFormat:@"%@ %@", [user fio], user.mobile] width:rowWidth];
    nameLabel.centerX = sv.centerX;
    nameLabel.y = secondBlockTitle.bottom + rowsSpacing;
    [sv addSubview:nameLabel];

    CenterTitle *carLabel = [[CenterTitle alloc] initWithTitle:[NSString stringWithFormat:@"%@ %@", [_carwashBook carTypeTitle], _bookObject.clientKey] width:rowWidth];
    carLabel.centerX = sv.centerX;
    carLabel.y = nameLabel.bottom + rowsSpacing;
    [sv addSubview:carLabel];
    
    
    CenterTitle *serviceLabel = [[CenterTitle alloc] initWithTitle:[NSString stringWithFormat:@"%@ за %@", [_bookObject servicesTitles], [_bookObject localizedPrice]] width:rowWidth];
    serviceLabel.centerX = sv.centerX;
    serviceLabel.y = carLabel.bottom + rowsSpacing;
    [sv addSubview:serviceLabel];
    
    CenterTitle *dateLabel = [[CenterTitle alloc] initWithTitle:[NSString stringWithFormat:@"%@ (%@) в %@", [_carwashBook localizedDaysAgo], [_carwashBook localizedBookDate], [_carwashBook bookTime]] width:rowWidth];
    dateLabel.centerX = sv.centerX;
    dateLabel.y = serviceLabel.bottom + rowsSpacing;
    [sv addSubview:dateLabel];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, dateLabel.bottom + rowsSpacing, rowWidth, 0.5)];
    [line2 setBackgroundColor:[UIColor whiteColor]];
    line2.alpha = 0.2;
    line2.centerX = sv.centerX;
    [sv addSubview:line2];
    
    
    
    
    CenterTitle *carwashLabel = [[CenterTitle alloc] initWithTitle:[NSString stringWithFormat:@"Автомойка %@", _carwashBook.carwashName] width:rowWidth];
    carwashLabel.centerX = sv.centerX;
    carwashLabel.y = line2.bottom + rowsSpacing;
    [sv addSubview:carwashLabel];
    
    CenterTitle *addressLabel = [[CenterTitle alloc] initWithTitle:_bookObject.carwash.address width:rowWidth];
    addressLabel.centerX = sv.centerX;
    addressLabel.y = carwashLabel.bottom + rowsSpacing;
    [sv addSubview:addressLabel];
    
    __weak BookResultViewController *wSelf = self;
    AAButton *phoneButton = [[AAButton alloc] initWithWidth:250 onTap:^(UIView *_self) {
        [wSelf telTapped];
    }];
    [phoneButton noBorderStyleButtonWithTitle:[_bookObject.carwash  contactsMobilePhone]];
    [phoneButton setTitleFont:[UIFont robotoRegular:14]];
    [phoneButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    phoneButton.centerX = self.view.centerX;
    phoneButton.y = addressLabel.bottom + 30;
    phoneButton.height = 40;
    [sv addSubview:phoneButton];
    
    UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(0, phoneButton.bottom + rowsSpacing, rowWidth, 0.5)];
    [line3 setBackgroundColor:[UIColor whiteColor]];
    line3.alpha = 0.2;
    line3.centerX = sv.centerX;
    [sv addSubview:line3];

    AAButton *okButton = [[AAButton alloc] initWithWidth:250 onTap:^(UIView *_self) {
        [wSelf okTapped];
    }];
    [okButton commonStyleButtonWithTitle:@"ВЕРНУТЬСЯ В МЕНЮ"];
    [okButton setTitleFont:[UIFont robotoRegular:18]];
    okButton.centerX = self.view.centerX;
    okButton.y = line3.bottom + 30;
    okButton.height = 40;
    [sv addSubview:okButton];

    [sv setContentSizeHeight:okButton.bottom + 20];

//    UILabel *subtitle = [sv setNavigationSubtitle:_bookObject.carwash.name];
//    subtitle.y = 10;
//
//    // Infos
//    CGFloat rowWidth = [ASize screenWidth] - 50;
//    CGFloat rowsSpacing = 10;
//
//    TitleValueView *row1 = [[TitleValueView alloc] initWithTitle:@"Адрес:" value:_bookObject.carwash.address width:rowWidth];
//    row1.centerX = sv.centerX;
//    row1.y = subtitle.bottom + 20;
//    [sv addSubview:row1];
//
//    TitleValueView *row2 = [[TitleValueView alloc] initWithTitle:@"Телефон:" value:_bookObject.carwash.contactsMobilePhone width:rowWidth];
//    row2.centerX = sv.centerX;
//    row2.y = row1.bottom + rowsSpacing;
//    [sv addSubview:row2];
//
//    TitleValueView *row3 = [[TitleValueView alloc] initWithTitle:@"Имя:" value:[user fio] width:rowWidth];
//    row3.centerX = sv.centerX;
//    row3.y = row2.bottom + 30;
//    [sv addSubview:row3];
//
//    TitleValueView *row4 = [[TitleValueView alloc] initWithTitle:@"Телефон: " value:user.mobile width:rowWidth];
//    row4.centerX = sv.centerX;
//    row4.y = row3.bottom + rowsSpacing;
//    [sv addSubview:row4];
//
//    TitleValueView *row5 = [[TitleValueView alloc] initWithTitle:@"Гос.номер " value:@"user.carNumber" width:rowWidth];
//    row5.centerX = sv.centerX;
//    row5.y = row4.bottom + rowsSpacing;
//    [sv addSubview:row5];
//
//    TitleValueView *row6 = [[TitleValueView alloc] initWithTitle:@"Марка авто: " value:@"user.carModel" width:rowWidth];
//    row6.centerX = sv.centerX;
//    row6.y = row5.bottom + rowsSpacing;
//    [sv addSubview:row6];
//
//    TitleValueView *row7 = [[TitleValueView alloc] initWithTitle:@"Тип авто: " value:[carwashRefs carTypeTitle:@(_bookObject.carType)] width:rowWidth];
//    row7.centerX = sv.centerX;
//    row7.y = row6.bottom + rowsSpacing;
//    [sv addSubview:row7];
//
//    TitleValueView *row8 = [[TitleValueView alloc] initWithTitle:@"Услуги: " value:[_bookObject servicesTitles] width:rowWidth];
//    row8.centerX = sv.centerX;
//    row8.y = row7.bottom + rowsSpacing;
//    [sv addSubview:row8];
//
//    TitleValueView *row9 = [[TitleValueView alloc] initWithTitle:@"Стоимость: " value:[_bookObject localizedPrice] width:rowWidth];
//    row9.centerX = sv.centerX;
//    row9.y = row8.bottom + rowsSpacing;
//    [sv addSubview:row9];
//
//    TitleValueView *row10 = [[TitleValueView alloc] initWithTitle:@"Дата и время: " value:[_bookObject prettyTime] width:rowWidth];
//    row10.centerX = sv.centerX;
//    row10.y = row9.bottom + rowsSpacing;
//    [sv addSubview:row10];
//
//    UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, row10.bottom + 30, 250, 1)];
//    messageLabel.backgroundColor = [UIColor clearColor];
//    messageLabel.font = [UIFont robotoRegular:14];
//    messageLabel.textColor = [UIColor whiteColor];
//    messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
//    messageLabel.numberOfLines = 0;
//    messageLabel.textAlignment = NSTextAlignmentCenter;
//    messageLabel.text = @"На указанный Вами мобильный телефон придет СМС-сообщение с деталями брони. \n"
//            "Для подтверждения брони вам позвонит администратор автомойки.\n"
//            "\n"
//            "Спасибо, что выбрали нас!";
//    [messageLabel sizeToFit];
//    messageLabel.centerX = sv.centerX;
//    [sv addSubview:messageLabel];
//
//    __weak BookResultViewController *wSelf = self;
//    AAButton *okButton = [[AAButton alloc] initWithWidth:100 onTap:^(UIView *_self) {
//        [wSelf okTapped];
//    }];
//    [okButton commonStyleButtonWithTitle:@"OK"];
//    [okButton setTitleFont:[UIFont robotoRegular:18]];
//    okButton.centerX = self.view.centerX;
//    okButton.y = messageLabel.bottom + 30;
//    okButton.height = 40;
//    [sv addSubview:okButton];
//
//    [sv setContentSizeHeight:okButton.bottom + 20];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc {

}

@end
