//
//  RegisterProfileViewController.m
//  WashMe
//
//  Created by Almas Adilbek on 3/30/16.
//  Copyright (c) 2016 Almas Adilbek. All rights reserved.
//

#import <SVProgressHUD/SVProgressHUD.h>
#import "RegisterProfileViewController.h"
#import "UIViewController+Ext.h"
#import "UIViewController+NavigationBar.h"
#import "InputTextField.h"
#import "UIView+ConcisePureLayout.h"
#import "RowButtonDropdownView.h"
#import "CarsCollectionView.h"
#import "AAButton+Styles.h"
#import "AddCarViewController.h"
#import "UIActionSheet+Blocks.h"
#import "InputTextField+Validation.h"
#import "UserApi.h"
#import "CarwashRefs.h"
#import "Cache.h"
#import "NSArray+ObjectiveSugar.h"
#import "City.h"
#import "AppDelegate.h"
#import "User.h"
#import "UserSettings.h"

@interface RegisterProfileViewController ()
@property(nonatomic, strong) NSMutableArray *cars;
@property(nonatomic, strong) City *selectedCity;
@end

@implementation RegisterProfileViewController {
    CarsCollectionView *_carsCollectionView;
    InputTextField *_nameField;
    InputTextField *_telField;
    RowButtonDropdownView *_cityRowButton;
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
    self.cars = [[NSMutableArray alloc] init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    User *user = [User currentUser];

    [_telField setValue:user.mobile];

    self.cars = [user.cars mutableCopy];
    [_carsCollectionView addCars:_cars];

    self.selectedCity = user.city;
    if (_selectedCity) {
        [_cityRowButton setTitle:_selectedCity.title];
        [UserSettings setCurrentCity:_selectedCity];
    }

    if(kDEBUGMODE) {
        [_nameField setValue:@"Roman"];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

#pragma mark -
#pragma mark Actions

- (void)tapSave {
    if(!_nameField.validate) return;
    if(!_telField.validate) return;
    if(self.cars.count == 0) {
        [UIHelper showAlertWithMessage:@"Добавьте автомобиль"];
        return;
    }
    if(!_selectedCity) {
        [UIHelper showAlertWithMessage:@"Выберите город"];
        return;
    }

    [SVProgressHUD showWithStatus:@"Сохранение"];
    [UserApi updateProfileWithName:_nameField.value lastname:nil cars:self.cars city:_selectedCity success:^(id response) {

        [SVProgressHUD dismiss];

        // Set that user entered profile in registration.
        [User setRegistrationProfileEntered:[User currentUser].mobile];

        // User authorized, goto main page.
        [[UIHelper appDelegate] setUserAuthorizedTabbarController];

    } failure:^(NSInteger code, NSString *message) {
        [SVProgressHUD dismiss];
    }];
}

- (void)tapCity
{
    NSArray *cities = @[[Cache carwashRefs].cities.lastObject];
    NSArray *cityNames = [cities map:^id(City *object) {
        return object.title;
    }];

    [UIActionSheet showInView:self.view
                    withTitle:@"Выберите город"
            cancelButtonTitle:@"Отмена"
       destructiveButtonTitle:nil
            otherButtonTitles:cityNames
                     tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
        if(buttonIndex != actionSheet.cancelButtonIndex) {
            self.selectedCity = cities[buttonIndex];
            [_cityRowButton setTitle:_selectedCity.title];
        }
    }];
}

#pragma mark -
#pragma mark carsCollectionView

- (void)CarsCollectionViewAddTapped {
    AddCarViewController *v = [AddCarViewController new];
    v.delegate = self;
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:v];
    [self presentViewController:nc animated:YES completion:nil];
}

#pragma mark -
#pragma mark AddCarViewController

- (void)AddCarViewControllerCarAdded:(Car *)car {
    [_carsCollectionView addCar:car];

    [self.cars addObject:car];
}

#pragma mark -

-(void)configUI
{
    [super configUI];
    [self hideBackButton];
    [self setBlueBackground];
    [self setNavigationBarTransparent];
    self.title = @"Введите Ваши данные";

    _nameField = [[InputTextField alloc] initWithWidth:kContentWidth height:45];
    [_nameField setPlaceholder:@"Имя"];
    [self.contentView addSubview:_nameField];
    [_nameField aa_setDimensions];
    [_nameField aa_superviewTop:20];
    [_nameField aa_centerHorizontal];

    _telField = [[InputTextField alloc] initWithWidth:kContentWidth height:45];
    _telField.textField.keyboardType = UIKeyboardTypePhonePad;
    [_telField setPlaceholder:@"Номер телефона"];
    [_telField enabled:NO];
    [self.contentView addSubview:_telField];
    [_telField aa_setDimensions];
    [_telField aa_pinUnderView:_nameField offset:5];
    [_telField aa_centerHorizontal];

    UILabel *addAutoTitleLabel = [UILabel newAutoLayoutView];
    addAutoTitleLabel.backgroundColor = [UIColor clearColor];
    addAutoTitleLabel.font = [UIFont systemFontOfSize:14];
    addAutoTitleLabel.textColor = [UIColor whiteColor];
    addAutoTitleLabel.text = @"Мой автомобиль:";
    [self.contentView addSubview:addAutoTitleLabel];
    [addAutoTitleLabel aa_pinUnderView:_telField offset:20];
    [addAutoTitleLabel aa_leading:_telField];

    _carsCollectionView = [CarsCollectionView newAutoLayoutView];
    _carsCollectionView.delegate = self;
    [_carsCollectionView addAddButton];
    [self.contentView addSubview:_carsCollectionView];
    [_carsCollectionView aa_pinUnderView:addAutoTitleLabel offset:8];
    [_carsCollectionView aa_superviewFitWidth];

    _cityRowButton = [[RowButtonDropdownView alloc] initWithWidth:kContentWidth icon:nil title:@"Город" target:self selector:@selector(tapCity)];
    [_cityRowButton aa_setDimensions];
    [self.contentView addSubview:_cityRowButton];
    [_cityRowButton aa_pinUnderView:_carsCollectionView offset:20];
    [_cityRowButton aa_centerHorizontal];

    __weak RegisterProfileViewController * weakSelf = self;
    AAButton *addButton = [[AAButton alloc] initWithWidth:170 onTap:^(UIView *_self) {
        [weakSelf tapSave];
    }];
    [addButton commonStyleButtonWithTitle:@"Сохранить"];
    [addButton setTitleFont:[UIFont robotoRegular:18]];
    addButton.height = 40;
    [self.contentView addSubview:addButton];
    [addButton aa_setDimensions];
    [addButton aa_pinUnderView:_cityRowButton offset:30];
    [addButton aa_centerHorizontal];
    [addButton aa_superviewBottom:25];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc {

}

@end