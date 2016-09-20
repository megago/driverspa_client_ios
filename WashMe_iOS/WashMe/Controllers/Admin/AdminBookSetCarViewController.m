//
//  BookSetCarViewController.m
//  WashMe
//
//  Created by Almas Adilbek on 10/5/14.
//  Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

#import "AdminBookSetCarViewController.h"
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
#import "BoxSetting.h"
#import "CarwashServiceCollectionView.h"
#import "Cache.h"
#import "CarwashRefs.h"
#import "IconTitleView.h"
#import "CenterTitle.h"
#import "CarwashApi.h"

@interface AdminBookSetCarViewController () <CarTypesTabbarViewDelegate, CarwashServiceCollectionDelegate>
@property (nonatomic, strong) NSMutableArray *cars;
@property (nonatomic, strong) NSMutableArray *checkedServices;
@end

@implementation AdminBookSetCarViewController {
    
    IconTitleView *washDelay;
    CenterTitle *priceLabel;
    
    CarTypesTabbarView *carTypesTabbarView;
    CarwashServiceCollectionView *carwashServiceCollectionView;
    InputTextField *fioField;
    InputTextField *telField;
    InputTextField *carNumberField;
    //InputTextField *carBrandField;

    NSArray *carTypeServices;
    NSArray *services;
}

-(id)init {
    self = [super init];
    if(self) {
        [self initVars];
    }
    return self;
}

-(void)initVars {
    self.checkedServices = [[NSMutableArray alloc] init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configUI];

    if(self.editMode)
    {
        carTypesTabbarView.carType = _bookObject.carType;
        self.checkedServices = [NSMutableArray arrayWithArray:_bookObject.services];
    }
    else
    {
        [carTypesTabbarView setCarType:CarTypeSedan];
        //[self carTypesTabbarViewDidChangeTabWithType:CarTypeSedan];
    }
}

#pragma mark -
#pragma mark Actions

- (void)continueTapped
{
    if(![fioField validate]) {
        [UIHelper showAlertFillRequiredField];
        return;
    }

    if(![carNumberField validate]) {
        [UIHelper showAlertFillRequiredField];
        return;
    }

    if(self.checkedServices.count == 0) {
        [UIHelper showAlertWithMessage:@"Выберите услуги"];
        return;
    }
        
    [CarwashApi getCarwashDetails:self.carwash.carwashId success:^(id response) {
        // Set book objects
        _bookObject.carwash = response;
        _bookObject.boxSetting = _boxSetting;
        _bookObject.services = self.checkedServices;
        _bookObject.carType = carTypesTabbarView.carType;
        _bookObject.clientKey = [NSString stringWithFormat:@"%@ (%@)", carNumberField.textField.text, fioField.textField.text];
        _bookObject.isOffline = YES;
        
        [Toast showHudWithTitle:@"Бронирование"];
        [UserApi bookWithBookObject:_bookObject success:^(id response) {
            [Toast showSuccessToastWithMessage:@"Забронированно"];
            [self.navigationController popToRootViewControllerAnimated:YES];
        } failure:^(NSInteger code, NSString *message) {
            
        }];
    } failure:^(NSInteger code, NSString *message) {
        
    }];
}

-(void)updatePrice {
    NSDictionary *menu = self.carwash.menu;
    NSDictionary *prices = menu[[NSString stringWithFormat:@"%ld", carTypesTabbarView.carType]];
    CGFloat totalPrice = 0;
    CGFloat totalTime = 0;
    
    for(IdTitleObject *obj in self.checkedServices) {
        CarwashMenuItem *menuItem = prices[obj.objectId];
        if(menuItem) {
            totalPrice += [menuItem.price floatValue];
            totalTime += [menuItem.time floatValue];
        }
        //NSLog(@"%d - %d - %d", menuItem.type.intValue, menuItem.price.intValue, menuItem.time.intValue);
    }
    
    _bookObject.price = @(totalPrice);
    _bookObject.bookTime = [NSString stringWithFormat:@"%d", (int)totalTime];
    priceLabel.text = [_bookObject localizedPrice];
    washDelay.titleLabel.text = [NSString stringWithFormat:@" %d мин.", (int)totalTime];
    washDelay.width = washDelay.titleLabel.right;
    washDelay.centerX = sv.centerX;
}


- (void)resetPrice {
    priceLabel.text = @" 0 тг.";
}

- (void)resetTime {
    washDelay.titleLabel.text = @" 0 мин.";
    washDelay.width = washDelay.titleLabel.right;
    washDelay.centerX = sv.centerX;
}

#pragma mark -
#pragma mark CarTypesTabbarView

- (void)carTypesTabbarViewDidChangeTabWithType:(CarType)carType
{
    NSDictionary *menu = self.carwash.menu;
    NSDictionary *prices = menu[[NSString stringWithFormat:@"%ld", (long)carType]];
    
    NSMutableArray *serviceIds = [NSMutableArray array];
    for(id key in prices) [serviceIds addObject:key];
    carTypeServices = serviceIds;
    
    [self.checkedServices removeAllObjects];
    [self resetPrice];
    [self resetTime];
    
    [Cache carwashRefs:^(id obj) {
        NSMutableArray *array = [NSMutableArray array];
        NSDictionary *servicesDictionary = [(CarwashRefs *)obj servicesDictionary];
        
        for(id serviceId in carTypeServices) {
            if(servicesDictionary[serviceId] != nil) {
                [array addObject:servicesDictionary[serviceId]];
            }
        }
        
        services = array;
        
        if(services.count > 0) {
            [carwashServiceCollectionView adminRefreshServices:services];
        } else {
            NSLog(@"services not found");
        }
    }];
}

#pragma mark -
#pragma mark CarwashServiceCollection Delegate

- (void)carwashServiceCollectionViewSelectedServices:(NSArray *)selectedServices {
    self.checkedServices = [NSMutableArray arrayWithArray:selectedServices];
    [self updatePrice];
}

#pragma mark -

-(void)configUI
{
    [super configUI];

    [self setBlueBackground];
    [self setBackButtonInNavigation];
    [self setNavigationTitle:[NSString stringWithFormat:@"%@ - %@ в %@", _boxSetting.boxName, _bookObject.localizedDaysAgo, _bookObject.bookTime]];
    
    [sv setFrame:CGRectMake(0, 64, [ASize screenWidth], [ASize screenHeightWithoutStatusBarAndNavigationBar])];

    washDelay = [[IconTitleView alloc] initWithIcon:@"icon-orders" title:@"     0 мин."];
    washDelay.x = [ASize screenWidth]/2 - washDelay.frame.size.width/2;
    washDelay.y = 5;
    washDelay.titleLabel.font = [UIFont robotoRegular:18.f];
    [washDelay.titleLabel  sizeToFit];
    washDelay.width = washDelay.titleLabel.right;
    washDelay.centerX = sv.centerX;
    [sv addSubview:washDelay];
    
    priceLabel = [[CenterTitle alloc] initWithTitle:@"0 тг." width:250];
    priceLabel.centerX = sv.centerX;
    priceLabel.y = washDelay.bottom + 5;
    priceLabel.font = [UIFont robotoRegular:18.f];
    [sv addSubview:priceLabel];
    
    carTypesTabbarView = [[CarTypesTabbarView alloc] initWithCarTypeIds:self.carwash.cartypes];
    carTypesTabbarView.delegate = self;
    carTypesTabbarView.y = priceLabel.bottom + 15;
    [sv addSubview:carTypesTabbarView];
    
    // Fields
    CGFloat h = 40;

    fioField = [[InputTextField alloc] initWithWidth:kContentWidth height:h];
    fioField.userInteractionEnabled = YES;
    fioField.centerX = sv.centerX;
    fioField.y = carTypesTabbarView.bottom + 20;
    [fioField setValue:@""];
    [fioField setPlaceholder:@"Имя"];
    [sv addSubview:fioField];

    telField = [[InputTextField alloc] initWithWidth:kContentWidth height:h];
    telField.userInteractionEnabled = YES;
    telField.centerX = sv.centerX;
    telField.y = fioField.bottom;
    [telField setValue:@""];
    [telField setPlaceholder:@"Мобильный телефон"];
    [sv addSubview:telField];

    carNumberField = [[InputTextField alloc] initWithWidth:kContentWidth height:h];
    carNumberField.userInteractionEnabled = YES;
    carNumberField.centerX = sv.centerX;
    carNumberField.y = telField.bottom;
    [carNumberField setValue:@""];
    [carNumberField setPlaceholder:@"Гос. номер"];
    carNumberField.textField.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    [sv addSubview:carNumberField];

//    carBrandField = [[InputTextField alloc] initWithWidth:kContentWidth height:h];
//    carBrandField.userInteractionEnabled = YES;
//    carBrandField.centerX = sv.centerX;
//    carBrandField.y = carNumberField.bottom;
//    [carBrandField setValue:@""];
//    [carBrandField setPlaceholder:@"Марка автомобиля"];
//    [sv addSubview:carBrandField];
    
    carwashServiceCollectionView = [[CarwashServiceCollectionView alloc] initWithFrame:CGRectMake(0, carNumberField.bottom + 5, [ASize screenWidth], 50)];
    carwashServiceCollectionView.delegate = self;
    [sv addSubview:carwashServiceCollectionView];

    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, carwashServiceCollectionView.bottom + 5, [ASize screenWidth], 0.5)];
    [line setBackgroundColor:[UIColor whiteColor]];
    line.alpha = 0.2;
    [sv addSubview:line];

    // Bron
    __weak AdminBookSetCarViewController *wSelf = self;
    AAButton *continueButton = [[AAButton alloc] initWithWidth:kButtonWidth onTap:^(UIView *_self) {
        [wSelf continueTapped];
    }];
    [continueButton commonStyleButtonWithTitle:@"БРОНИРОВАТЬ"];
    [continueButton setTitleFont:[UIFont robotoRegular:18]];
    continueButton.centerX = self.view.centerX;
    continueButton.y = line.bottom + 30;
    continueButton.height = 40;
    [sv addSubview:continueButton];

    [self setScrollContentHeight:carwashServiceCollectionView.bottom];
    //[self addKeyboardControlFields:@[fioField.textField, telField.textField, carNumberField.textField, carBrandField.textField]];
    [self addKeyboardControlFields:@[fioField.textField, telField.textField, carNumberField.textField]];
}

-(void)dealloc {

}

@end