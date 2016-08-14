//
// Created by Almas Adilbek on 9/7/14.
// Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

#import "ConfirmSmsViewController.h"
#import "UIViewController+Ext.h"
#import "UIFont+Custom.h"
#import "InputTextField.h"
#import "AAButton.h"
#import "AAButton+Styles.h"
#import "NSString+Ext.h"
#import "Toast.h"
#import "AccountApi.h"
#import "InputTextField+Validation.h"
#import "UIHelper.h"
#import "User.h"
#import "NSObject+Json.h"
#import "CarwashesViewController.h"
#import "AdminCarwashesViewController.h"
#import "AdminMainViewController.h"
#import "UserSettings.h"
#import "AppDelegate.h"
#import "RegisterProfileViewController.h"


@interface ConfirmSmsViewController () <UITextFieldDelegate>
@end

@implementation ConfirmSmsViewController {
    InputTextField *codeField;
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
}

-(void)viewDidAppear:(BOOL)animated {
    [codeField focus];
}

#pragma mark -
#pragma mark Actions

- (void)resendTapped
{
    [self.view endEditing:YES];

    [Toast showHudWithTitle:@"Отправка"];
    [AccountApi register:self.phoneNumber companyName:self.companyName success:^(id response) {
        [Toast showSuccessToastWithMessage:@"Отправлено"];
    } failure:^(NSInteger code, NSString *message) {

    }];
}

- (void)confirmTapped
{
    [self.view endEditing:YES];

    if(![codeField validate]) {
        [UIHelper showAlertWithMessage:@"Введите код активации"];
        return;
    }

    [Toast showHudWithTitle:@"Активация"];
    [AccountApi confirmRegistration:self.phoneNumber activationCode:[codeField value] success:^(id response) {

        User *user = [User instanceFromDictionary:response];

        // Store user mobile
        [User storeUserMobile:user.mobile];

        // Store token in keychain
        [User storeTokenInKeychain:user.token forMobile:user.mobile];

        // Store user data
        [User setAuthorizedUserData:response withMobile:user.mobile];

        // Goto carwashes list if user or admin main page
        if([UserSettings isAdmin]) {
            //AdminMainViewController *v = [[AdminMainViewController alloc] init];
            //[self.navigationController pushViewController:v animated:YES];
            
            // Set that user entered profile in registration.
            [User setRegistrationProfileEntered:[User currentUser].mobile];
            [[UIHelper appDelegate] setAdminAuthorizedTabbarController];
        } else {
            if (user.cars.count > 0 && user.fio.length > 0 && user.cityCode.length > 0){
                // Set that user entered profile in registration.
                [User setRegistrationProfileEntered:[User currentUser].mobile];
                // User authorized, goto main page.
                [[UIHelper appDelegate] setUserAuthorizedTabbarController];
            } else {
                RegisterProfileViewController *v = [[RegisterProfileViewController alloc] init];
                [self.navigationController pushViewController:v animated:YES];
            }
        }
    } failure:^(NSInteger code, NSString *message) {
        [codeField setValue:@""];
        [codeField focus];
    }];
}

#pragma mark -

-(void)configUI
{
    [super configUI];

    sv.y = 0;
    sv.height = [ASize screenHeight];

    [self setBlueBackground];
    [self createWashMeWhiteLogo];
    [self setBackButton];
    [sv addSubview:[self whiteLogo]];

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont robotoThin:22];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    titleLabel.numberOfLines = 0;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"Пожалуйста, введите код, отправленный по смс:";
    titleLabel.width = 260;
    [titleLabel sizeToFit];
    titleLabel.centerX = self.view.centerX;
    titleLabel.y = 135;
    [sv addSubview:titleLabel];

    __weak ConfirmSmsViewController *wSelf = self;

    AAButton *resendButton = [[AAButton alloc] initWithWidth:250 onTap:^(UIView *_self) {
        [wSelf resendTapped];
    }];
    [resendButton noBorderStyleButtonWithTitle:@"Отправить код еще раз"];
    [resendButton setTitleFont:[UIFont robotoRegular:13]];
    resendButton.centerX = self.view.centerX;
    resendButton.y = titleLabel.bottom + 10;
    [sv addSubview:resendButton];

    InputTextField *telField = [[InputTextField alloc] initWithWidth:kContentWidth height:45];
    telField.centerX = self.view.centerX;
    telField.y = resendButton.bottom + 40;
    telField.textField.keyboardType = UIKeyboardTypeNumberPad;
    [telField setValue:[self.phoneNumber phoneNumberPresentation]];
    [telField setRightText:@"KZ"];
    [telField enabled:NO];
    [sv addSubview:telField];

    codeField = [[InputTextField alloc] initWithWidth:kContentWidth height:telField.height];
    codeField.textField.delegate = self;
    codeField.centerX = self.view.centerX;
    codeField.y = telField.bottom + 10;
    codeField.textField.keyboardType = UIKeyboardTypeNumberPad;
    [codeField setPlaceholder:@"Код подтверждения"];
    if(kDEBUGMODE) [codeField setValue:@"000000"]; // TODO: for testing
    [sv addSubview:codeField];

    [self addKeyboardControlFields:@[telField]];

    // Button
    AAButton *okButton = [[AAButton alloc] initWithWidth:160 onTap:^(UIView *_self) {
        [wSelf confirmTapped];
    }];
    [okButton commonStyleButtonWithTitle:@"ПОДТВЕРДИТЬ"];
    [okButton setTitleFont:[UIFont robotoRegular:20]];
    okButton.centerX = self.view.centerX;
    okButton.y = codeField.bottom + 20;
    [sv addSubview:okButton];

    [self addKeyboardControlFields:@[codeField]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc {

}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == codeField.textField) {
        //calculate new length
        NSInteger moddedLength = textField.text.length-(range.length-string.length);
        
        // max size.
        if (moddedLength > 6) {
            return NO;
        }
    }
    return YES;
}


@end