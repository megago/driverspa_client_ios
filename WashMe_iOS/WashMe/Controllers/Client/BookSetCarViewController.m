//
//  BookSetCarViewController.m
//  WashMe
//
//  Created by Almas Adilbek on 10/5/14.
//  Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

#import "BookSetCarViewController.h"
#import "UIViewController+Ext.h"
#import "UIScrollView+Ext.h"
#import "InputTextField.h"
#import "RowButtonDisclosureView.h"
#import "CarwashComplex.h"
#import "AAButton+Styles.h"
#import "BookChooseBoxViewController.h"
#import "User.h"
#import "M13BadgeView.h"
#import "CarwashMenuItem.h"
#import "BookObject.h"
#import "IdTitleObject.h"
#import "InputTextField+Validation.h"
#import "UserApi.h"
#import "BookObject.h"

@interface BookSetCarViewController ()
@end

@implementation BookSetCarViewController {
    CarTypesTabbarView *carTypesTabbarView;
    InputTextField *fioField;
    InputTextField *telField;
    InputTextField *carNumberField;
    InputTextField *carBrandField;
    RowButtonDisclosureView *servicesButton;

    NSArray *carTypeServices;
    NSArray *checkedServices;
    M13BadgeView *priceView;
}

-(id)init {
    self = [super init];
    if(self) {
        [self initVars];
    }
    return self;
}

-(void)initVars {
    checkedServices = [[NSArray alloc] init];
    self.bookObject = [[BookObject alloc] init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configUI];

    User *user = [User currentUser];

    [fioField setValue:[user fio]];
    [telField setValue:user.mobile];
//    [carBrandField setValue:user.carModel];
//    [carNumberField setValue:user.carNumber];

    if(self.editMode)
    {
        carTypesTabbarView.carType = _bookObject.carType;
        priceView.text = [_bookObject localizedPrice];
        checkedServices = _bookObject.services;
        [self setServicesButtonTitle];
    }
    else
    {
        [carTypesTabbarView setCarType:CarTypeSedan];
    }
}

#pragma mark -
#pragma mark Actions

- (void)continueTapped
{
//    if(![fioField validate]) {
//        [UIHelper showAlertFillRequiredField];
//        return;
//    }

    if(![carNumberField validate]) {
        [UIHelper showAlertFillRequiredField];
        return;
    }

//    if(![carBrandField validate]) {
//        [UIHelper showAlertFillRequiredField];
//        return;
//    }

    if(![carNumberField validate]) {
        [UIHelper showAlertFillRequiredField];
        return;
    }

    if(checkedServices.count == 0) {
        [UIHelper showAlertWithMessage:@"Выберите услуги"];
        return;
    }

    [Toast showHudWithTitle:@"Ждите"];
    [UserApi updateProfileWithName:[fioField value] lastname:nil cars:nil success:^(id response) {
        // Update user datas
        [User instanceFromDictionary:response];

        // Set book objects
        _bookObject.carwash = self.carwash;
        _bookObject.services = checkedServices;
        _bookObject.carType = carTypesTabbarView.carType;
//        _bookObject.clientKey = [User currentUser].carNumber;
        _bookObject.bookDate = nil;
        _bookObject.bookTime = nil;

        BookChooseBoxViewController *v = [[BookChooseBoxViewController alloc] init];
        v.bookObject = _bookObject;
        v.editMode = self.editMode;
        [self.navigationController pushViewController:v animated:YES];

    } failure:^(NSInteger code, NSString *message) {

    }];
}

- (void)servicesTapped {
    BookingCarwashServicesViewController *v = [[BookingCarwashServicesViewController alloc] init];
    v.delegate = self;
    v.carwashServices = carTypeServices;
    v.checkedServices = [NSMutableArray arrayWithArray:checkedServices];
    [self.navigationController pushViewController:v animated:YES];
}

#pragma mark -
#pragma mark CarTypesTabbarView

- (void)carTypesTabbarViewDidChangeTabWithType:(CarType)carType
{
    NSDictionary *menu = self.carwash.menu;
    NSDictionary *prices = menu[[NSString stringWithFormat:@"%d", carType]];

    NSMutableArray *serviceIds = [NSMutableArray array];
    for(id key in prices) [serviceIds addObject:key];
    carTypeServices = serviceIds;

    checkedServices = @[];
    [self setServicesButtonTitle];
    [self resetPrice];
}

#pragma mark -
#pragma mark CarwashServicesViewController

-(void)carwashServicesViewControllerSelectedServices:(NSArray *)_checkedServices {
    checkedServices = [_checkedServices mutableCopy];
    [self setServicesButtonTitle];

    NSDictionary *menu = self.carwash.menu;
    NSDictionary *prices = menu[[NSString stringWithFormat:@"%d", carTypesTabbarView.carType]];
    CGFloat totalPrice = 0;

    for(IdTitleObject *obj in checkedServices) {
        CarwashMenuItem *menuItem = prices[obj.objectId];
        if(menuItem) {
            totalPrice += [menuItem.price floatValue];
        }
    }

    _bookObject.price = @(totalPrice);
    priceView.text = [_bookObject localizedPrice];
}

-(void)setServicesButtonTitle {
    if(checkedServices.count > 0) {
        [servicesButton setTitle:[NSString stringWithFormat:@"Выбрано услуг (%i)", checkedServices.count]];
    } else {
        [servicesButton setTitle:@"Выберите услуги"];
    }
}

- (void)resetPrice {
    priceView.text = @"0 тг.";
}

#pragma mark -

-(void)configUI
{
    [super configUI];

    [self setBlueBackground];
    [self setBackButton];
    [self setNavigationTitle:@"Информация об авто"];

    sv.y = 64;
    sv.height = [ASize screenHeightWithoutStatusBarAndNavigationBar] - 44;

    UILabel *subtitle = [sv setNavigationSubtitle:self.carwash.name];
    subtitle.y = 10;

    carTypesTabbarView = [[CarTypesTabbarView alloc] initWithCarTypeIds:self.carwash.cartypes];
    carTypesTabbarView.delegate = self;
    carTypesTabbarView.y = subtitle.bottom + 15;
    [sv addSubview:carTypesTabbarView];

    // Fields
    CGFloat h = 40;

    fioField = [[InputTextField alloc] initWithWidth:kContentWidth height:h];
    fioField.userInteractionEnabled = NO;
    fioField.centerX = sv.centerX;
    fioField.y = carTypesTabbarView.bottom + 20;
    [fioField setValue:@""];
    [fioField setPlaceholder:@"Имя"];
    [sv addSubview:fioField];

    telField = [[InputTextField alloc] initWithWidth:kContentWidth height:h];
    telField.userInteractionEnabled = NO;
    telField.centerX = sv.centerX;
    telField.y = fioField.bottom;
    [telField setValue:@""];
    [telField setPlaceholder:@"Мобильный телефон"];
    [sv addSubview:telField];

    carNumberField = [[InputTextField alloc] initWithWidth:kContentWidth height:h];
    carNumberField.userInteractionEnabled = NO;
    carNumberField.centerX = sv.centerX;
    carNumberField.y = telField.bottom;
    [carNumberField setValue:@""];
    [carNumberField setPlaceholder:@"Гос. номер"];
    carNumberField.textField.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    [sv addSubview:carNumberField];

    carBrandField = [[InputTextField alloc] initWithWidth:kContentWidth height:h];
    carBrandField.userInteractionEnabled = NO;
    carBrandField.centerX = sv.centerX;
    carBrandField.y = carNumberField.bottom;
    [carBrandField setValue:@""];
    [carBrandField setPlaceholder:@"Марка автомобиля"];
    [sv addSubview:carBrandField];

    servicesButton = [[RowButtonDisclosureView alloc] initWithWidth:kContentWidth icon:nil title:nil target:self selector:@selector(servicesTapped)];
    servicesButton.y = carBrandField.bottom + 30;
    [self setServicesButtonTitle];
    [sv addSubview:servicesButton];
    
    // Badge
    priceView = [[M13BadgeView alloc] initWithFrame:CGRectZero];
    [self resetPrice];
    priceView.badgeBackgroundColor = [UIColor whiteColor];
    priceView.textColor = [UIColor blackColor];
    priceView.horizontalAlignment = M13BadgeViewHorizontalAlignmentNone;
    priceView.verticalAlignment = M13BadgeViewVerticalAlignmentNone;
    priceView.cornerRadius = 5;
    priceView.x = kViewControllerPadding + 10;
    priceView.y = servicesButton.bottom + 10;
    [sv addSubview:priceView];

    // Bron
    __weak BookSetCarViewController *wSelf = self;
    AAButton *continueButton = [[AAButton alloc] initWithWidth:kButtonWidth onTap:^(UIView *_self) {
        [wSelf continueTapped];
    }];
    [continueButton commonStyleButtonWithTitle:@"Продолжить"];
    [continueButton setTitleFont:[UIFont robotoRegular:18]];
    continueButton.centerX = self.view.centerX;
    continueButton.y = priceView.bottom + 30;
    continueButton.height = 40;
    [sv addSubview:continueButton];

    [self setScrollContentHeight:continueButton.bottom];
    [self addKeyboardControlFields:@[fioField.textField, telField.textField, carNumberField.textField, carBrandField.textField]];
}

-(void)dealloc {

}

@end