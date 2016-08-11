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
    //[self configUI];
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
    [self setBackButtonInNavigation];
    [self setBlueBackground];
    [self setNavigationTitle:@"Бронь отправлена"];
    
    User *user = [User currentUser];
    CarwashRefs *carwashRefs = [Cache carwashRefs];
    
    UILabel *subtitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    subtitleLabel.backgroundColor = [UIColor clearColor];
    subtitleLabel.font = [UIFont robotoRegular:14];
    subtitleLabel.textColor = [UIColor whiteColor];
    subtitleLabel.textAlignment = NSTextAlignmentCenter;
    subtitleLabel.numberOfLines = 0;
    subtitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    subtitleLabel.text = @"Администратор автомойки в течении 15 минут обработает вашу бронь, а вам прийдет push-уведомление";
    [subtitleLabel sizeToFit];
    [self.contentView addSubview:subtitleLabel];
    [subtitleLabel aa_setDimensions];
    [subtitleLabel aa_superviewTop:10];
    [subtitleLabel aa_leading:self.contentView offset:10.f];
    [subtitleLabel aa_trailing:self.contentView offset:10.f];
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectZero];
    [line1 setBackgroundColor:[UIColor whiteColor]];
    line1.alpha = 0.2;
    line1.height = 0.5;
    [self.contentView addSubview:line1];
    [line1 aa_setDimensions];
    [line1 aa_leading:self.contentView offset:10.f];
    [line1 aa_trailing:self.contentView offset:10.f];
    [line1 aa_pinUnderView:subtitleLabel offset:10];
    
    UILabel *secondBlockTitle = [[UILabel alloc] initWithFrame:CGRectZero];
    secondBlockTitle.backgroundColor = [UIColor clearColor];
    secondBlockTitle.font = [UIFont robotoRegular:16];
    secondBlockTitle.textColor = [UIColor whiteColor];
    secondBlockTitle.textAlignment = NSTextAlignmentCenter;
    secondBlockTitle.numberOfLines = 0;
    secondBlockTitle.lineBreakMode = NSLineBreakByWordWrapping;
    secondBlockTitle.text = @"Бронь на имя";
    [secondBlockTitle sizeToFit];
    [self.contentView addSubview:secondBlockTitle];
    [secondBlockTitle aa_setDimensions];
    [secondBlockTitle aa_pinUnderView:line1 offset:20];
    [secondBlockTitle aa_leading:self.contentView offset:10.f];
    [secondBlockTitle aa_trailing:self.contentView offset:10.f];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.font = [UIFont robotoRegular:14];
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.numberOfLines = 0;
    nameLabel.lineBreakMode = NSLineBreakByWordWrapping;
    nameLabel.text = [NSString stringWithFormat:@"%@ %@", [user fio], user.mobile];
    [nameLabel sizeToFit];
    [self.contentView addSubview:nameLabel];
    [nameLabel aa_setDimensions];
    [nameLabel aa_pinUnderView:secondBlockTitle offset:10];
    [nameLabel aa_leading:self.contentView offset:10.f];
    [nameLabel aa_trailing:self.contentView offset:10.f];

    UILabel *carLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    carLabel.backgroundColor = [UIColor clearColor];
    carLabel.font = [UIFont robotoRegular:14];
    carLabel.textColor = [UIColor whiteColor];
    carLabel.textAlignment = NSTextAlignmentCenter;
    carLabel.numberOfLines = 0;
    carLabel.lineBreakMode = NSLineBreakByWordWrapping;
    carLabel.text = [NSString stringWithFormat:@"%@ %@", [_carwashBook carTypeTitle], _bookObject.clientKey];
    [carLabel sizeToFit];
    [self.contentView addSubview:carLabel];
    [carLabel aa_setDimensions];
    [carLabel aa_pinUnderView:nameLabel offset:10];
    [carLabel aa_leading:self.contentView offset:10.f];
    [carLabel aa_trailing:self.contentView offset:10.f];
    
    UILabel *serviceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    serviceLabel.backgroundColor = [UIColor clearColor];
    serviceLabel.font = [UIFont robotoRegular:14];
    serviceLabel.textColor = [UIColor whiteColor];
    serviceLabel.textAlignment = NSTextAlignmentCenter;
    serviceLabel.numberOfLines = 0;
    serviceLabel.lineBreakMode = NSLineBreakByWordWrapping;
    serviceLabel.text = [NSString stringWithFormat:@"%@ за %@", [_bookObject servicesTitles], [_bookObject localizedPrice]];
    [serviceLabel sizeToFit];
    [self.contentView addSubview:serviceLabel];
    [serviceLabel aa_setDimensions];
    [serviceLabel aa_pinUnderView:carLabel offset:10];
    [serviceLabel aa_leading:self.contentView offset:10.f];
    [serviceLabel aa_trailing:self.contentView offset:10.f];
    
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    dateLabel.backgroundColor = [UIColor clearColor];
    dateLabel.font = [UIFont robotoRegular:14];
    dateLabel.textColor = [UIColor whiteColor];
    dateLabel.textAlignment = NSTextAlignmentCenter;
    dateLabel.numberOfLines = 0;
    dateLabel.lineBreakMode = NSLineBreakByWordWrapping;
    dateLabel.text = [NSString stringWithFormat:@"%@ (%@) в %@", [_carwashBook localizedDaysAgo], [_carwashBook localizedBookDate], [_carwashBook bookTime]];
    [dateLabel sizeToFit];
    [self.contentView addSubview:dateLabel];
    [dateLabel aa_setDimensions];
    [dateLabel aa_pinUnderView:serviceLabel offset:20];
    [dateLabel aa_leading:self.contentView offset:10.f];
    [dateLabel aa_trailing:self.contentView offset:10.f];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectZero];
    [line2 setBackgroundColor:[UIColor whiteColor]];
    line2.alpha = 0.2;
    line2.height = 0.5;
    [self.contentView addSubview:line2];
    [line2 aa_setDimensions];
    [line2 aa_leading:self.contentView offset:10.f];
    [line2 aa_trailing:self.contentView offset:10.f];
    [line2 aa_pinUnderView:dateLabel offset:20];
    
    UILabel *carwashLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    carwashLabel.backgroundColor = [UIColor clearColor];
    carwashLabel.font = [UIFont robotoRegular:14];
    carwashLabel.textColor = [UIColor whiteColor];
    carwashLabel.textAlignment = NSTextAlignmentCenter;
    carwashLabel.numberOfLines = 0;
    carwashLabel.lineBreakMode = NSLineBreakByWordWrapping;
    carwashLabel.text = [NSString stringWithFormat:@"Автомойка %@", _carwashBook.carwashName];
    [carwashLabel sizeToFit];
    [self.contentView addSubview:carwashLabel];
    [carwashLabel aa_setDimensions];
    [carwashLabel aa_pinUnderView:line2 offset:20];
    [carwashLabel aa_leading:self.contentView offset:10.f];
    [carwashLabel aa_trailing:self.contentView offset:10.f];
    
    UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    addressLabel.backgroundColor = [UIColor clearColor];
    addressLabel.font = [UIFont robotoRegular:14];
    addressLabel.textColor = [UIColor whiteColor];
    addressLabel.textAlignment = NSTextAlignmentCenter;
    addressLabel.numberOfLines = 0;
    addressLabel.lineBreakMode = NSLineBreakByWordWrapping;
    addressLabel.text = _bookObject.carwash.address;
    [addressLabel sizeToFit];
    [self.contentView addSubview:addressLabel];
    [addressLabel aa_setDimensions];
    [addressLabel aa_pinUnderView:carwashLabel offset:10];
    [addressLabel aa_leading:self.contentView offset:10.f];
    [addressLabel aa_trailing:self.contentView offset:10.f];
    
    UILabel *phoneLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    phoneLabel.backgroundColor = [UIColor clearColor];
    phoneLabel.font = [UIFont robotoRegular:14];
    phoneLabel.textColor = [UIColor whiteColor];
    phoneLabel.textAlignment = NSTextAlignmentCenter;
    phoneLabel.numberOfLines = 0;
    phoneLabel.lineBreakMode = NSLineBreakByWordWrapping;
    phoneLabel.text = [_bookObject.carwash  contactsMobilePhone];
    [phoneLabel sizeToFit];
    [self.contentView addSubview:phoneLabel];
    [phoneLabel aa_setDimensions];
    [phoneLabel aa_pinUnderView:addressLabel offset:0];
    [phoneLabel aa_leading:self.contentView offset:10.f];
    [phoneLabel aa_trailing:self.contentView offset:10.f];
    
    UIView *line3 = [[UIView alloc] initWithFrame:CGRectZero];
    [line3 setBackgroundColor:[UIColor whiteColor]];
    line3.alpha = 0.2;
    line3.height = 0.5;
    [self.contentView addSubview:line3];
    [line3 aa_setDimensions];
    [line3 aa_leading:self.contentView offset:10.f];
    [line3 aa_trailing:self.contentView offset:10.f];
    [line3 aa_pinUnderView:phoneLabel offset:10];

    __weak BookResultViewController * weakSelf = self;
    AAButton *okButton = [[AAButton alloc] initWithWidth:170 onTap:^(UIView *_self) {
        [weakSelf okTapped];
    }];
    [okButton commonStyleButtonWithTitle:@"ВЕРНУТЬСЯ В МЕНЮ"];
    [okButton setTitleFont:[UIFont robotoRegular:18]];
    okButton.height = 40;
    [self.contentView addSubview:okButton];
    [okButton aa_setDimensions];
    [okButton aa_pinUnderView:line3 offset:20];
    [okButton aa_centerHorizontal];
    [okButton aa_superviewBottom:15];

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
