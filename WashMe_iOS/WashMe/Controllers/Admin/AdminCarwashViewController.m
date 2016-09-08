//
//  AdminCarwashViewController.m
//  WashMe
//
//  Created by Almas Adilbek on 10/20/14.
//  Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <MWPhotoBrowser/MWPhotoBrowser.h>
#import "AdminCarwashViewController.h"
#import "UIViewController+Ext.h"
#import "InputTextField.h"
#import "RowButtonDisclosureView.h"
#import "AAButton+Styles.h"
#import "CarwashComplex.h"
#import "SetCarwashAddressViewController.h"
#import "SetCarwashCarTypesViewController.h"
#import "SetCarwashServicesViewController.h"
#import "SerCarwashCartypePricesViewController.h"
#import "SetCarwashBoxesCountViewController.h"
#import "SetCarwashOtherInfosViewController.h"
#import "SetCarwashScheduleViewController.h"
#import "InputTextField+Validation.h"
#import "CreateCarwashDraft.h"
#import "CarwashApi.h"
#import "AdminApi.h"
#import "Cache.h"
#import "CompanyCarwashRefs.h"
#import "CarwashContact.h"
#import "CarwashSchedule.h"
#import "SchedulePeriod.h"
#import "IdTitleObject.h"
#import "UIActionSheet+Blocks.h"
#import "CarwashPhotosViewerView.h"
#import "RowButtonDropdownView.h"
#import "City.h"
#import "UIViewController+NavigationBar.h"
#import "AdminApi.h"
#import "User.h"
#import "CarwashComplex.h"

@interface AdminCarwashViewController () 
@end

@implementation AdminCarwashViewController {
    InputTextField *nameField;
    CarwashComplex *_carwashComplex;
    CarwashPhotosViewerView *photosViewerView;
    RowButtonDropdownView *publishCarwashButton;
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
    [self loadCarwashes];
    
    CreateCarwashDraft *draft = [CreateCarwashDraft sharedInstance];
    [nameField setValue:draft.carwashName];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self hideKeyboard];
}

- (void)loadCarwashes
{
    [Toast showHudLoading];
    [AdminApi myCarwashes:^(id response) {
        [self onCarwashesLoaded:response];
    } failure:^(NSInteger code, NSString *message) {
        
    }];
}

- (void)onCarwashesLoaded:(id)response
{
    NSArray *arr = response;
    if(arr.count == 0) {
        [Toast showHudLoading];
        NSMutableDictionary *o = [NSMutableDictionary dictionary];
        
        o[@"is_public"] = @(_carwash.isPublic);
        o[@"city"] = @"astana";
        o[@"name"] = @"";
        o[@"lonlat"] = @[@(0), @(0)];
        o[@"address"] = @"";
        
        NSLog(@"info: %@", o);

        [AdminApi createCarwash:o success:^(id response) {
            _carwash = response;
            [self loadCarwash];
        } failure:^(NSInteger code, NSString *message) {
            
        }];
    } else {
        //load detail carwash
        _carwash = arr.firstObject;
        [self loadCarwash];
    }
}

- (void)loadCarwash {
    // If edit mode
    if(_carwash) {
        [Toast showHudWithTitle:@"Загрузка мойки"];
        [AdminApi getCarwashDetails:_carwash.carwashId success:^(id response) {
            _carwashComplex = response;
            [self buildUI];
            [self onCarwashComplex];
        } failure:^(NSInteger code, NSString *message) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
}

- (void)onCarwashComplex
{
    CreateCarwashDraft *draft = [CreateCarwashDraft sharedInstance];
    [nameField setValue:_carwashComplex.name];

    [Cache companyCarwashRefs:^(id obj) {

        // Photos
        [photosViewerView setPhotos:_carwashComplex.carwashImages];

        // Carwash status


        // Services
        NSDictionary *servicesDic = [(CompanyCarwashRefs *)obj servicesDictionary];
        NSDictionary *carTypesDic = [(CompanyCarwashRefs *)obj carTypesDictionary];

        // Carwash car types
        NSMutableArray * carwashCarTypes = [NSMutableArray array];
        for(NSString *carTypeId in _carwashComplex.cartypes) {
            [carwashCarTypes addObject:carTypesDic[carTypeId]];
        }

        // Services
        NSMutableArray * carwashServices = [NSMutableArray array];
        for(NSString *serviceId in _carwashComplex.services) {
            [carwashServices addObject:servicesDic[serviceId]];
        }

        draft.carwashName = _carwashComplex.name;
        draft.address = _carwashComplex.address;
        draft.coordinate = _carwashComplex.coordinate;
        draft.carTypes = [NSMutableArray arrayWithArray:carwashCarTypes];
        draft.services = [NSMutableArray arrayWithArray:carwashServices];
        draft.boxesCount = _carwashComplex.boxSettings.count;

        // Menu
        NSMutableDictionary *menuDic = [NSMutableDictionary dictionary];
        for(NSNumber *carType in [_carwashComplex.menu allKeys])
        {
            NSMutableArray *prices = [NSMutableArray array];

            NSDictionary *pricesDic = _carwashComplex.menu[carType];
            for(NSString *serviceType in [pricesDic allKeys]) {
                [prices addObject:pricesDic[serviceType]];
            }

            menuDic[carType] = prices;
        }
        draft.menu = menuDic;

        // Schedule
        draft.scheduleComment = _carwashComplex.schedule.comment;
        NSMutableArray *schedule = [NSMutableArray array];
        [schedule addObject:[(SchedulePeriod *)_carwashComplex.schedule.mon[0] workingTime]];
        [schedule addObject:[(SchedulePeriod *)_carwashComplex.schedule.tue[0] workingTime]];
        [schedule addObject:[(SchedulePeriod *)_carwashComplex.schedule.wed[0] workingTime]];
        [schedule addObject:[(SchedulePeriod *)_carwashComplex.schedule.thu[0] workingTime]];
        [schedule addObject:[(SchedulePeriod *)_carwashComplex.schedule.fri[0] workingTime]];
        [schedule addObject:[(SchedulePeriod *)_carwashComplex.schedule.sat[0] workingTime]];
        [schedule addObject:[(SchedulePeriod *)_carwashComplex.schedule.sun[0] workingTime]];
        draft.schedule = schedule;

        // Pay options
        NSMutableArray * payOptions = [NSMutableArray array];
        for(IdTitleObject *payoption in [(CompanyCarwashRefs *)obj payoptions]) {
            if([_carwashComplex.payoptions containsObject:payoption.objectId]) {
                [payOptions addObject:payoption];
            }
        }
        draft.payOptions = payOptions;

        // Additional info
        NSMutableArray * addInfos = [NSMutableArray array];
        for(IdTitleObject *addInfo in [(CompanyCarwashRefs *)obj additionalInfo]) {
            if([_carwashComplex.additionalInfos containsObject:addInfo.objectId]) {
                [addInfos addObject:addInfo];
            }
        }
        draft.additionalInfos = addInfos;

        // Contacts
        for(CarwashContact *contact in _carwashComplex.contacts) {
            if([contact isEmail]) draft.email = contact.value;
            else if([contact isPhone]) draft.telephone = contact.value;
            else if([contact isWebsite]) draft.website = contact.value;
        }

        // City
        City *city = [_carwash cityObject];
        if(city) draft.city = city;

    }];
}

#pragma mark -
#pragma mark Actions

- (void)goBackTapped {
    CreateCarwashDraft *draft = [CreateCarwashDraft sharedInstance];
    draft.carwashName = [nameField value];
//    [CreateCarwashDraft clear];

    [super goBackTapped];
}

- (void)submitTapped
{
    CreateCarwashDraft *draft = [CreateCarwashDraft sharedInstance];

    if(![nameField validate]) {
        [UIHelper showAlertFillRequiredField];
        return;
    }

    if(![draft issetAddress]) {
        [UIHelper showAlertWithMessage:@"Укажите адрес мойки!"];
        [self addressTapped];
        return;
    }

    NSMutableDictionary *o = [NSMutableDictionary dictionary];

    o[@"is_public"] = @(_carwash.isPublic);
    o[@"city"] = @"astana";
    o[@"name"] = [nameField value];
    o[@"lonlat"] = @[@(draft.coordinate.longitude), @(draft.coordinate.latitude)];
    o[@"address"] = [draft address];
    o[@"payoptions"] = [draft payoptionkeys];
    o[@"additional_info"] = [draft additionalInfosArray];
    o[@"contacts"] = [draft contactValues];
    o[@"services"] = [draft serviceIds];
    o[@"cartypes"] = [draft carTypeIds];
    if(!_carwashComplex) o[@"box_settings"] = [draft boxSettings];
    o[@"menu"] = [draft menuDictionary];
    o[@"schedule"] = [draft scheduleDictionary];
    o[@"city"] = [draft.city code];

    NSLog(@"info: %@", o);

    if(_carwash) {
        [Toast showHudWithTitle:@"Сохранение"];
        [AdminApi updateCarwash:_carwash.carwashId params:o success:^(id response) {
            [CarwashComplex setAuthorizedCarwashData:response withMobile:[User currentUser].mobile];
            [self.delegate adminCarwashViewControllerCarwashUpdated:response];
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(NSInteger code, NSString *message) {

        }];
    } else {
        [Toast showHudLoading];
        [AdminApi createCarwash:o success:^(id response) {
            [self.delegate adminCarwashViewControllerCarwashCreated:response];
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(NSInteger code, NSString *message) {

        }];
    }
}

- (void)publishCarwashTapped
{
    NSString *title = nil;
    NSString *buttonTitle = nil;
    if(_carwash.isPublic) {
        title = @"Мойка опубликована.\nХотите скрыть мойку?";
        buttonTitle = @"Скрыть мойку";
    } else {
        title = @"Мойка еще не опубликована.\nХотите опубликовать мойку?";
        buttonTitle = @"Опубликовать";
    }
    [UIActionSheet showInView:self.view withTitle:title cancelButtonTitle:@"Отмена" destructiveButtonTitle:_carwash.isPublic?buttonTitle:nil otherButtonTitles:_carwash.isPublic?nil:@[buttonTitle] tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
        if(actionSheet.cancelButtonIndex != buttonIndex)
        {
            [Toast showHudWithTitle:@"Ждите"];
            [CarwashApi makeCarwash:_carwash.carwashId public:!_carwash.isPublic success:^(id response) {
                _carwash = response;
                [self updateCarwashStatus];
                [self.delegate adminCarwashViewControllerCarwashUpdated:response];
                [CarwashComplex setAuthorizedCarwashData:response withMobile:[User currentUser].mobile];
            } failure:^(NSInteger code, NSString *message) {

            }];
        }
    }];
}

- (void)addressTapped {
    SetCarwashAddressViewController *v = [[SetCarwashAddressViewController alloc] init];
    [self.navigationController pushViewController:v animated:YES];
}

- (void)otherInfoTapped {
    SetCarwashOtherInfosViewController *v = [[SetCarwashOtherInfosViewController alloc] init];
    [self.navigationController pushViewController:v animated:YES];
}

- (void)boxesTapped {
    SetCarwashBoxesCountViewController *v = [[SetCarwashBoxesCountViewController alloc] init];
    [self.navigationController pushViewController:v animated:YES];
}

- (void)pricesTapped {
    SerCarwashCartypePricesViewController *v = [[SerCarwashCartypePricesViewController alloc] init];
    [self.navigationController pushViewController:v animated:YES];
}

- (void)servicesTapped {
    SetCarwashServicesViewController *v = [[SetCarwashServicesViewController alloc] init];
    [self.navigationController pushViewController:v animated:YES];
}

- (void)scheduleTaped {
    SetCarwashScheduleViewController *v = [[SetCarwashScheduleViewController alloc] init];
    [self.navigationController pushViewController:v animated:YES];
}

- (void)carTypesTapped {
    SetCarwashCarTypesViewController *v = [[SetCarwashCarTypesViewController alloc] init];
    [self.navigationController pushViewController:v animated:YES];
}

#pragma mark -
#pragma mark Helper

- (void)updateCarwashStatus
{
    NSString *icon = nil;
    NSString *title = nil;
    if(_carwash.isPublic) {
        icon = @"carwash-status-published";
        title = @"Мойка опубликована";
    } else {
        icon = @"carwash-status-unpublished";
        title = @"Мойка не опубликована";
    }
    [publishCarwashButton setIcon:icon];
    [publishCarwashButton setTitle:title];
}

#pragma mark -

-(void)configUI
{
    [super configUI];
    [self setBlueBackground];
    [self showMenuButton];
    [self setNavigationBarTransparent];
    
    //[sv setFrame:CGRectMake(0, 64, [ASize screenWidth], [ASize screenHeightWithoutStatusBarAndNavigationBar])];
}

- (void)buildUI {
    CGFloat nexty = 0;
    if(_carwash)
    {
        [self setNavigationTitle:@"Мойка"];
        photosViewerView = [[CarwashPhotosViewerView alloc] init];
        photosViewerView.carwashId = _carwash.carwashId;
        [sv addSubview:photosViewerView];
        
        // Status
        publishCarwashButton = [[RowButtonDropdownView alloc] initWithWidth:kContentWidth icon:nil title:@"" target:self selector:@selector(publishCarwashTapped)];
        publishCarwashButton.y = photosViewerView.bottom + 20;
        [publishCarwashButton removeTopLine];
        [sv addSubview:publishCarwashButton];
        
        [self updateCarwashStatus];
        
        nexty = publishCarwashButton.bottom + 15;
    }
    else
    {
        [self setNavigationTitle:@"+ Добавить автомойку"];
        
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, (CGFloat) ([ASize screenWidth] * 0.7), 1)];
        messageLabel.backgroundColor = [UIColor clearColor];
        messageLabel.font = [UIFont robotoRegular:16];
        messageLabel.textColor = [UIColor whiteColor];
        messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.text = @"Пожалуйста, введите все данные автомойки.";
        [messageLabel sizeToFit];
        messageLabel.centerX = self.view.middleX;
        messageLabel.y = 15;
        [sv addSubview:messageLabel];
        
        nexty = messageLabel.bottom + 30;
    }
    
    nameField = [[InputTextField alloc] initWithWidth:kContentWidth height:45];
    nameField.centerX = self.view.centerX;
    nameField.y = nexty;
    nameField.textField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
    [nameField setPlaceholder:@"Название мойки"];
    [sv addSubview:nameField];
    
    RowButtonDisclosureView *addressButton = [[RowButtonDisclosureView alloc] initWithWidth:kContentWidth icon:nil title:@"Адрес" target:self selector:@selector(addressTapped)];
    addressButton.y = nameField.bottom + 10;
    [addressButton removeTopLine];
    [sv addSubview:addressButton];
    
    RowButtonDisclosureView *carTypesButton = [[RowButtonDisclosureView alloc] initWithWidth:kContentWidth icon:nil title:@"Типы машин" target:self selector:@selector(carTypesTapped)];
    carTypesButton.y = addressButton.bottom;
    [sv addSubview:carTypesButton];
    
    RowButtonDisclosureView *servicesButton = [[RowButtonDisclosureView alloc] initWithWidth:kContentWidth icon:nil title:@"Услуги" target:self selector:@selector(servicesTapped)];
    servicesButton.y = carTypesButton.bottom;
    [sv addSubview:servicesButton];
    
    RowButtonDisclosureView *pricesButton = [[RowButtonDisclosureView alloc] initWithWidth:kContentWidth icon:nil title:@"Цены" target:self selector:@selector(pricesTapped)];
    pricesButton.y = servicesButton.bottom;
    [sv addSubview:pricesButton];
    
    RowButtonDisclosureView *boxesButton = [[RowButtonDisclosureView alloc] initWithWidth:kContentWidth icon:nil title:@"Боксы" target:self selector:@selector(boxesTapped)];
    boxesButton.y = pricesButton.bottom;
    [sv addSubview:boxesButton];
    
    RowButtonDisclosureView *scheduleButton = [[RowButtonDisclosureView alloc] initWithWidth:kContentWidth icon:nil title:@"Время работы" target:self selector:@selector(scheduleTaped)];
    scheduleButton.y = boxesButton.bottom;
    [sv addSubview:scheduleButton];
    
    RowButtonDisclosureView *otherInfoButton = [[RowButtonDisclosureView alloc] initWithWidth:kContentWidth icon:nil title:@"Дополнительная информация" target:self selector:@selector(otherInfoTapped)];
    otherInfoButton.y = scheduleButton.bottom;
    [sv addSubview:otherInfoButton];
    
    // Button
    __weak AdminCarwashViewController *wSelf = self;
    AAButton *addButton = [[AAButton alloc] initWithWidth:200 onTap:^(UIView *_self) {
        [wSelf submitTapped];
    }];
    if(_carwash) {
        [addButton commonStyleButtonWithTitle:@"СОХРАНИТЬ"];
    } else {
        [addButton commonStyleButtonWithTitle:@"Создать мойку"];
    }
    [addButton setTitleFont:[UIFont robotoRegular:18]];
    addButton.centerX = sv.centerX;
    addButton.y = otherInfoButton.bottom + 25;
    addButton.height = 40;
    [sv addSubview:addButton];
    
    // -----
    [sv setContentSizeHeight:addButton.bottom + 40];
    [self addKeyboardControlFields:@[nameField.textField]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Dealloc

- (void)dealloc
{
    NSLog(@"dealloc");
    [CreateCarwashDraft clear];
}

@end