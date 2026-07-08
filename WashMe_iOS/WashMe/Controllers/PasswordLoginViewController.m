//
//  PasswordLoginViewController.m
//  WashMe
//
//  See header. Returning users with a password log in here via account/login_password.
//

#import "PasswordLoginViewController.h"
#import "UIViewController+Ext.h"
#import "UIFont+Custom.h"
#import "InputTextField.h"
#import "AAButton.h"
#import "AAButton+Styles.h"
#import "NSString+Ext.h"
#import "Toast.h"
#import "AccountApi.h"
#import "UIHelper.h"
#import "User.h"
#import "UserSettings.h"
#import "AppDelegate.h"
#import "RegisterProfileViewController.h"

@interface PasswordLoginViewController () <UITextFieldDelegate>
@end

@implementation PasswordLoginViewController {
    InputTextField *passwordField;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configUI];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [passwordField focus];
}

#pragma mark - Actions

- (void)loginTapped
{
    [self.view endEditing:YES];

    NSString *password = [passwordField value];
    if(password.length == 0) {
        [UIHelper showAlertWithMessage:@"Введите пароль"];
        return;
    }

    [Toast showHudWithTitle:@"Вход"];
    [AccountApi loginPassword:self.phoneNumber password:password success:^(id response) {
        [self signInWithUserData:response];
    } failure:^(NSInteger code, NSString *message) {
        [passwordField setValue:@""];
        [passwordField focus];
    }];
}

- (void)signInWithUserData:(NSDictionary *)data
{
    User *user = [User instanceFromDictionary:data];

    // Store session — same pattern as the WhatsApp / SMS OTP flows.
    [User storeUserMobile:user.mobile];
    [User storeTokenInKeychain:user.token forMobile:user.mobile];
    [User setAuthorizedUserData:data withMobile:user.mobile];
    [UserSettings setCurrentCity:user.city];

    BOOL profileComplete = user.cars.count > 0 && user.fio.length > 0 && user.cityCode.length > 0;
    if(profileComplete) {
        [User setRegistrationProfileEntered:[User currentUser].mobile];
        [[UIHelper appDelegate] setUserAuthorizedTabbarController];
    } else {
        RegisterProfileViewController *v = [[RegisterProfileViewController alloc] init];
        [self.navigationController pushViewController:v animated:YES];
    }
}

#pragma mark - UI

- (void)configUI
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
    titleLabel.text = @"Введите пароль:";
    titleLabel.width = 260;
    [titleLabel sizeToFit];
    titleLabel.centerX = self.view.centerX;
    titleLabel.y = 135;
    [sv addSubview:titleLabel];

    InputTextField *telField = [[InputTextField alloc] initWithWidth:kContentWidth height:45];
    telField.centerX = self.view.centerX;
    telField.y = titleLabel.bottom + 30;
    [telField setValue:[self.phoneNumber phoneNumberPresentation]];
    [telField setRightText:@"KZ"];
    [telField enabled:NO];
    [sv addSubview:telField];

    passwordField = [[InputTextField alloc] initWithWidth:kContentWidth height:telField.height];
    passwordField.textField.delegate = self;
    passwordField.centerX = self.view.centerX;
    passwordField.y = telField.bottom + 10;
    passwordField.textField.secureTextEntry = YES;
    [passwordField setPlaceholder:@"Пароль"];
    [sv addSubview:passwordField];

    [self addKeyboardControlFields:@[passwordField]];

    __weak PasswordLoginViewController *wSelf = self;
    AAButton *okButton = [[AAButton alloc] initWithWidth:160 onTap:^(UIView *_self) {
        [wSelf loginTapped];
    }];
    [okButton commonStyleButtonWithTitle:@"ВОЙТИ"];
    [okButton setTitleFont:[UIFont robotoRegular:20]];
    okButton.centerX = self.view.centerX;
    okButton.y = passwordField.bottom + 20;
    [sv addSubview:okButton];
}

@end
