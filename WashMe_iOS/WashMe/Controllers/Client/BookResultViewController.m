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
#import "UIAlertView+Blocks.h"

#import "UIView+ConcisePureLayout.h"
#import "CarwashBook.h"
#import "CenterTitle.h"
#import "IconTitleView.h"
#import "NSString+Ext.h"
#import "CarwashApi.h"

@interface BookResultViewController ()
@end

@implementation BookResultViewController {
    CarwashComplex *carwash;
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
    //[self configUI];
    self.navigationItem.hidesBackButton = YES;
    [self showBook];
}

- (void)showBook {
    [Cache carwashRefs:^(id obj) {
        _carwashRefs = obj;
        [Toast showHudLoading];
        NSString *url = [self.carwashBook.carwash stringByReplacingOccurrencesOfString:@"/api/v1/" withString:@""];
        [CarwashApi getCarwashWithResource:url success:^(id response) {
            carwash = response;
            [self configUI];
        } failure:^(NSInteger code, NSString *message) {
            
        }];
    }];
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
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateBooksBadge" object:nil];
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

- (void)userTappedOnGroups:(UIGestureRecognizer*)gestureRecognizer {
    [UIAlertView showWithTitle:[_carwashBook groupsTitlesArCarwash:carwash] message:[_carwashBook goupServicesTitles] cancelButtonTitle:@"ОК" otherButtonTitles:nil tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {}];
}

#pragma mark -

-(void)configUI
{
    [super configUI];
    //[self setBackButtonInNavigation];
    [self setBlueBackground];
    [self setNavigationTitle:@"Бронь отправлена"];
    
    User *user = [User currentUser];
    //CarwashRefs *carwashRefs = [Cache carwashRefs];
    
    // Infos
    CGFloat rowWidth = [ASize screenWidth] - 50;
    CGFloat rowsSpacing = 10;
    
    CenterTitle *subtitleLabel = [[CenterTitle alloc] initWithTitle:@"Администратор автомойки в течении 15 минут обработает вашу бронь, а вам прийдет push-уведомление" width:rowWidth];
    [subtitleLabel sizeToFit];
    subtitleLabel.centerX = sv.centerX;
    subtitleLabel.y = rowsSpacing;
    [sv addSubview:subtitleLabel];

    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, subtitleLabel.bottom + rowsSpacing, rowWidth, 0.5)];
    [line1 setBackgroundColor:[UIColor whiteColor]];
    line1.alpha = 0.2;
    line1.centerX = sv.centerX;
    [sv addSubview:line1];
    
    
    
    
    CenterTitle *secondBlockTitle = [[CenterTitle alloc] initWithTitle:@"Бронь на имя" width:rowWidth];
    [secondBlockTitle setFont:[UIFont robotoRegular:18.f]];
    [secondBlockTitle sizeToFit];
    secondBlockTitle.centerX = sv.centerX;
    secondBlockTitle.y = line1.bottom + rowsSpacing;
    [sv addSubview:secondBlockTitle];
    
    CenterTitle *nameLabel = [[CenterTitle alloc] initWithTitle:[NSString stringWithFormat:@"%@ %@", [user fio], user.mobile] width:rowWidth];
    [nameLabel sizeToFit];
    nameLabel.centerX = sv.centerX;
    nameLabel.y = secondBlockTitle.bottom + 2*rowsSpacing;
    [sv addSubview:nameLabel];

    CenterTitle *carLabel = [[CenterTitle alloc] initWithTitle:[NSString stringWithFormat:@"%@ %@", [_carwashBook carTypeTitle], [_carwashBook localizedCarNumber]] width:rowWidth];
    [carLabel sizeToFit];
    carLabel.centerX = sv.centerX;
    carLabel.y = nameLabel.bottom;
    [sv addSubview:carLabel];
    
    CenterTitle *serviceLabel = [[CenterTitle alloc] initWithTitle:@"" width:rowWidth];
    NSMutableAttributedString *titleAttr = [[NSMutableAttributedString alloc] init];
    if (_carwashBook.groupServices.count > 0){
        [titleAttr appendAttributedString:[[NSAttributedString alloc] initWithString:[_carwashBook groupsTitlesArCarwash:carwash] attributes:@{
                                                                                                                       NSFontAttributeName : [UIFont robotoRegular:14],NSForegroundColorAttributeName: [UIColor whiteColor],
                                                                                                                       NSUnderlineStyleAttributeName: @(NSUnderlineStyleNone)
                                                                                                                       }]];
    }
    
    if (_carwashBook.groupServices.count > 0 && _carwashBook.services.count > 0){
        [titleAttr appendAttributedString:[[NSAttributedString alloc] initWithString:@" + "
                                                                          attributes:@{                                                                                       NSFontAttributeName : [UIFont robotoRegular:14],NSForegroundColorAttributeName: [UIColor whiteColor],
                                                                                                                                                                              }]];
    }
    
    [titleAttr appendAttributedString:[[NSAttributedString alloc] initWithString:[_carwashBook servicesTitles]
                                                                      attributes:@{
                                                                                   NSFontAttributeName : [UIFont robotoRegular:14],NSForegroundColorAttributeName: [UIColor whiteColor],
                                                                                   }]];
    
    NSString *str = [NSString new];
    if (_carwashBook.discount.intValue > 0){
        str = [NSString stringWithFormat:@" за %@\nсо скидкой %i %%", [_carwashBook localizedPrice], _carwashBook.discount.intValue];
    } else {
        str = [NSString stringWithFormat:@" за %@", [_carwashBook localizedPrice]];
    }
    [titleAttr appendAttributedString:[[NSAttributedString alloc] initWithString:str
                                                                      attributes:@{
                                                                                   NSFontAttributeName : [UIFont robotoRegular:14],NSForegroundColorAttributeName: [UIColor whiteColor],
                                                                                   }]];
    
    serviceLabel.attributedText = titleAttr;
    [serviceLabel sizeToFit];
    serviceLabel.centerX = sv.centerX;
    serviceLabel.y = carLabel.bottom;
    [sv addSubview:serviceLabel];
    
//    if (_carwashBook.groupServices.count > 0){
//        UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userTappedOnGroups:)];
//        [serviceLabel setUserInteractionEnabled:YES];
//        [serviceLabel addGestureRecognizer:gesture];
//    }
    
    CenterTitle *dateLabel = [[CenterTitle alloc] initWithTitle:[NSString stringWithFormat:@"%@ (%@) в %@", [_carwashBook localizedDaysAgo], [_carwashBook localizedBookDate], [_carwashBook localBookTime]] width:rowWidth];
    [dateLabel sizeToFit];
    dateLabel.centerX = sv.centerX;
    dateLabel.y = serviceLabel.bottom + 2*rowsSpacing;
    [sv addSubview:dateLabel];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, dateLabel.bottom + rowsSpacing, rowWidth, 0.5)];
    [line2 setBackgroundColor:[UIColor whiteColor]];
    line2.alpha = 0.2;
    line2.centerX = sv.centerX;
    [sv addSubview:line2];
    
    CenterTitle *carwashLabel = [[CenterTitle alloc] initWithTitle:[NSString stringWithFormat:@"Автомойка %@", _carwashBook.carwashName] width:rowWidth];
    [carwashLabel setFont:[UIFont robotoRegular:18.f]];
    [carwashLabel sizeToFit];
    carwashLabel.centerX = sv.centerX;
    carwashLabel.y = line2.bottom + rowsSpacing;
    [sv addSubview:carwashLabel];
    
    CenterTitle *addressLabel = [[CenterTitle alloc] initWithTitle:_bookObject.carwash.address width:rowWidth];
    [addressLabel sizeToFit];
    addressLabel.centerX = sv.centerX;
    addressLabel.y = carwashLabel.bottom + 2*rowsSpacing;
    [sv addSubview:addressLabel];
    
    __weak BookResultViewController *wSelf = self;
    AAButton *phoneButton = [[AAButton alloc] initWithWidth:250 onTap:^(UIView *_self) {
        [wSelf telTapped];
    }];
    [phoneButton noBorderStyleButtonWithTitle:[_bookObject.carwash  contactsMobilePhone]];
    [phoneButton setTitleFont:[UIFont robotoRegular:14]];
    [phoneButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    phoneButton.centerX = self.view.centerX;
    phoneButton.y = addressLabel.bottom;
    phoneButton.height = 40;
    [sv addSubview:phoneButton];
    
    float nextY = phoneButton.bottom + rowsSpacing;
    if (![_carwashBook.comment isEqualToString:@""]) {
        IconTitleView *commentLabel = [[IconTitleView alloc] initWithIcon:@"ic_comment_book" title:_carwashBook.comment];
        commentLabel.x = [ASize screenWidth]/2 - commentLabel.frame.size.width/2;
        commentLabel.y = nextY;
        [commentLabel.titleLabel  sizeToFit];
        commentLabel.width = commentLabel.titleLabel.right;
        commentLabel.centerX = sv.centerX;
        [sv addSubview:commentLabel];
        nextY = commentLabel.bottom + rowsSpacing;
    }
    
    UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(0, nextY, rowWidth, 0.5)];
    [line3 setBackgroundColor:[UIColor whiteColor]];
    line3.alpha = 0.2;
    line3.centerX = sv.centerX;
    [sv addSubview:line3];

    AAButton *okButton = [[AAButton alloc] initWithWidth:250 onTap:^(UIView *_self) {
        [wSelf okTapped];
    }];
    [okButton commonStyleButtonWithTitle:@"ВЕРНУТЬСЯ К СПИСКУ"];
    [okButton setTitleFont:[UIFont robotoRegular:18]];
    okButton.centerX = self.view.centerX;
    okButton.y = line3.bottom + rowsSpacing;
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
