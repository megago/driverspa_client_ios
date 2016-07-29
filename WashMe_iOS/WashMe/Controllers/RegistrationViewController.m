//
// Created by Almas Adilbek on 9/7/14.
// Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

#import "RegistrationViewController.h"
#import "UIViewController+Ext.h"
#import "UIFont+Custom.h"
#import "InputTextField.h"
#import "AAButton.h"
#import "AAButton+Styles.h"
#import "ConfirmSmsViewController.h"
#import "InputTextField+Validation.h"
#import "AccountApi.h"
#import "Toast.h"
#import "UserSettings.h"


@interface RegistrationViewController ()
@end

@implementation RegistrationViewController {
    InputTextField *telField;
    InputTextField *companyNameField;
    InputTextField *cityField;
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
    [self configAction];
}

- (void)configAction
{

}

#pragma mark -
#pragma mark ACtions

- (void)okTapped 
{
    [self.view endEditing:YES];

    if(![telField validatePhoneNumber]) return;
//    if([UserSettings isAdmin] && ![companyNameField validate]) {
//        [UIHelper showAlertFillRequiredField];
//        return;
//    }

    NSString *phoneNumber = [telField validPhoneNumber];
    NSString *companyName = [UserSettings isAdmin] ? [companyNameField value] : nil;

    [Toast showHudWithTitle:@"Регистрация"];
    [AccountApi register:phoneNumber companyName:companyName success:^(id response) {

        ConfirmSmsViewController *v = [[ConfirmSmsViewController alloc] init];
        v.phoneNumber = phoneNumber;
        v.companyName = companyName;
        [self.navigationController pushViewController:v animated:YES];

    } failure:^(NSInteger code, NSString *message) {

    }];
}

#pragma mark -

-(void)configUI
{
    [super configUI];

    [self setBlueBackground];
    [self createWashMeWhiteLogo];
    [self setBackButtonInNavigation];
    [sv addSubview:[self whiteLogo]];

    sv.y = 0;
    sv.height = [ASize screenHeight];

    NSMutableArray *editableFields = [NSMutableArray array];

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont robotoThin:24];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    titleLabel.numberOfLines = 0;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"Пожалуйста, введите Ваш номер телефона:";
    titleLabel.width = 260;
    [titleLabel sizeToFit];
    titleLabel.centerX = self.view.centerX;
    titleLabel.y = 125;
    [sv addSubview:titleLabel];

//    if([UserSettings isAdmin]) {
//        companyNameField = [[InputTextField alloc] initWithWidth:kContentWidth height:45];
//        companyNameField.centerX = self.view.centerX;
//        companyNameField.y = titleLabel.bottom + 50;
//        [companyNameField setPlaceholder:@"Введите название компании"];
//        companyNameField.textField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
//        if([AppUtils isAlmas]) [companyNameField setValue:@"AlmasWash"]; // TODO: for testing
//        [sv addSubview:companyNameField];
//
//        [editableFields addObject:companyNameField];
//    }
    
    if ([UserSettings isAdmin]){
        cityField = [[InputTextField alloc] initWithWidth:kContentWidth height:45];
        cityField.centerX = self.view.centerX;
        cityField.y = titleLabel.bottom + 50;
        [cityField setValue:@"Астана"];
        [cityField enabled:NO];
        [sv addSubview:cityField];
    }
    
    InputTextField *countryCodeField = [[InputTextField alloc] initWithWidth:kContentWidth height:45];
    countryCodeField.centerX = self.view.centerX;
    countryCodeField.y = ([UserSettings isAdmin]) ? cityField.bottom : titleLabel.bottom + 50;
    [countryCodeField setValue:@"Казахстан (+7)"];
    [countryCodeField enabled:NO];
    [sv addSubview:countryCodeField];

    telField = [[InputTextField alloc] initWithWidth:kContentWidth height:countryCodeField.height];
    telField.centerX = self.view.centerX;
    telField.y = countryCodeField.bottom;
    telField.textField.keyboardType = UIKeyboardTypePhonePad;
    [telField setPlaceholder:@"Введите номер телефона"];
    if([AppUtils isAlmas]) [telField setValue:![UserSettings isAdmin]?@"+77019852754":@"+70000000000"]; // TODO: for testing
    [sv addSubview:telField];
    [editableFields addObject:telField];

    [self addKeyboardControlFields:editableFields];
    
    // Button
    
    __weak RegistrationViewController *wSelf = self;

    AAButton *okButton = [[AAButton alloc] initWithWidth:130 onTap:^(UIView *_self) {
        [wSelf okTapped];
    }];
    [okButton commonStyleButtonWithTitle:@"Далее"];
    [okButton setTitleFont:[UIFont robotoRegular:20]];
    okButton.centerX = self.view.centerX;
    okButton.y = telField.bottom + 20;
    [sv addSubview:okButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc {

}

@end