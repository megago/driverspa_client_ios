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
#import "WhatsAppLoginViewController.h"
#import "PasswordLoginViewController.h"
#import "InputTextField+Validation.h"
#import "AccountApi.h"
#import "Toast.h"
#import "UserSettings.h"


@interface RegistrationViewController () <UITextFieldDelegate>
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

    NSString *phoneNumber = [telField validPhoneNumber];

    // Matches Android DriverSpa client: returning users who already set a password log
    // in with a password (no WhatsApp); everyone else verifies via WhatsApp.
    [Toast showHudLoading];
    [AccountApi checkPhone:phoneNumber success:^(id response) {
        BOOL hasPassword = [response[@"has_password"] boolValue];
        if(hasPassword) {
            PasswordLoginViewController *v = [[PasswordLoginViewController alloc] init];
            v.phoneNumber = phoneNumber;
            [self.navigationController pushViewController:v animated:YES];
        } else {
            WhatsAppLoginViewController *v = [[WhatsAppLoginViewController alloc] init];
            v.phoneNumber = phoneNumber;
            [self.navigationController pushViewController:v animated:YES];
        }
    } failure:^(NSInteger code, NSString *message) {
        // On check failure, fall back to WhatsApp verification.
        WhatsAppLoginViewController *v = [[WhatsAppLoginViewController alloc] init];
        v.phoneNumber = phoneNumber;
        [self.navigationController pushViewController:v animated:YES];
    }];
}

#pragma mark -

-(void)configUI
{
    [super configUI];

    [self setBlueBackground];
    [self createWashMeWhiteLogo];
    //[self setBackButton];
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
    telField.textField.delegate = self;
    telField.centerX = self.view.centerX;
    telField.y = countryCodeField.bottom;
    telField.textField.keyboardType = UIKeyboardTypeNumberPad;
    [telField setPlaceholder:@"Введите номер телефона"];
    //if([AppUtils isAlmas]) [telField setValue:![UserSettings isAdmin]?@"+77019852754":@"+70000000000"]; // TODO: for testing
    if(kDEBUGMODE) [telField setValue:![UserSettings isAdmin]?@"+77019852754":@"+70000000000"]; // TODO: for testing
    [sv addSubview:telField];
    [editableFields addObject:telField];

    [self addKeyboardControlFields:editableFields];

    // Button
    
    __weak RegistrationViewController *wSelf = self;

    AAButton *okButton = [[AAButton alloc] initWithWidth:130 onTap:^(UIView *_self) {
        [wSelf okTapped];
    }];
    [okButton commonStyleButtonWithTitle:@"ДАЛЕЕ"];
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

#pragma mark - UITextFieldDelegate

-(NSString*) formatPhoneString:(NSString*) preFormatted
{    //delegate only allows numbers to be entered, so '-' is the only non-legal char.
    NSString* workingString = [preFormatted stringByReplacingOccurrencesOfString:@"(" withString:@""];
    workingString = [workingString stringByReplacingOccurrencesOfString:@")" withString:@""];
    workingString = [workingString stringByReplacingOccurrencesOfString:@"-" withString:@""];
    workingString = [workingString stringByReplacingOccurrencesOfString:@" " withString:@""];
    workingString = [workingString stringByReplacingOccurrencesOfString:@"+7" withString:@""];
    
    //insert '('
    if(workingString.length > 1 && [preFormatted length] > 0)
    {
        workingString = [workingString stringByReplacingCharactersInRange:NSMakeRange(0, 0) withString:@"("];
    }
    
    //insert ')'
    if(workingString.length > 4 && [preFormatted length] > 0)
    {
        workingString = [workingString stringByReplacingCharactersInRange:NSMakeRange(4, 0) withString:@")"];
    }
    
    //insert ' '
    if(workingString.length > 5 && [preFormatted length] > 0)
    {
        workingString = [workingString stringByReplacingCharactersInRange:NSMakeRange(5, 0) withString:@" "];
    }
    
    //insert first '-'
    if(workingString.length > 9 && [preFormatted length] > 0)
    {
        workingString = [workingString stringByReplacingCharactersInRange:NSMakeRange(9, 0) withString:@"-"];
    }
    
    //insert second '-'
    if(workingString.length > 12 && [preFormatted length] > 0)
    {
        workingString = [workingString stringByReplacingCharactersInRange:NSMakeRange(12, 0) withString:@"-"];
    }
    
    workingString =[NSString stringWithFormat:@"+7 %@", workingString];
    return workingString;
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == telField.textField) {
        //calculate new length
        NSInteger moddedLength = textField.text.length-(range.length-string.length);

        // max size.
        if (moddedLength > 18) {
            return NO;
        }

        // Reject non-number characters (string is empty on deletion, so guard the index access)
        if (string.length > 0 && ![[NSCharacterSet decimalDigitCharacterSet] characterIsMember:[string characterAtIndex:0]]) {
            return NO;
        }

        textField.text = [self formatPhoneString:[textField.text stringByReplacingCharactersInRange:range withString:string]];
        return NO;
    }
    
    return YES;
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (telField.textField.text.length == 0) {
        telField.textField.text = @"+7";
    }
    return YES;
}

@end
