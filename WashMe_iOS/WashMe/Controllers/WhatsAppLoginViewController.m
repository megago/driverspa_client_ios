//
//  WhatsAppLoginViewController.m
//  WashMe
//
//  See header. WhatsApp-only login: request → open WhatsApp → poll → sign in.
//

#import "WhatsAppLoginViewController.h"
#import "UIViewController+Ext.h"
#import "UIFont+Custom.h"
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

// Poll every 3s, give up after ~2.5 min and offer Retry — matches Android.
static const NSTimeInterval kPollIntervalSeconds = 3.0;
static const NSTimeInterval kPollTimeoutSeconds = 150.0;

@implementation WhatsAppLoginViewController {
    UILabel *statusLabel;
    UIActivityIndicatorView *spinner;
    AAButton *openButton;
    AAButton *retryButton;

    NSString *waToken;         // short token used for polling
    NSString *waLink;          // wa.me link (token pre-filled) from the backend
    NSString *whatsappNumber;  // destination WhatsApp number

    NSTimer *pollTimer;
    NSDate *pollStartTime;
    BOOL requestInFlight;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configUI];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if(!requestInFlight && waToken.length == 0) {
        [self startWhatsappRequest];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self stopPolling];
}

- (void)dealloc
{
    [self stopPolling];
}

#pragma mark - WhatsApp request

- (void)startWhatsappRequest
{
    requestInFlight = YES;
    retryButton.hidden = YES;
    statusLabel.text = @"Подготовка...";
    statusLabel.hidden = NO;
    [spinner startAnimating];

    __weak WhatsAppLoginViewController *wSelf = self;
    [AccountApi whatsappRequest:self.phoneNumber
                      pushToken:[UserSettings currentPushToken]
                          email:self.email
                        success:^(id response) {
        [wSelf onWhatsappRequestResponse:response];
    } failure:^(NSInteger code, NSString *message) {
        [wSelf onWhatsappRequestFailed];
    }];
}

- (void)onWhatsappRequestResponse:(id)response
{
    requestInFlight = NO;

    waToken = response[@"token"];
    waLink = response[@"wa_link"];
    whatsappNumber = response[@"whatsapp_number"];

    if(waToken.length == 0 || waLink.length == 0) {
        [self onWhatsappRequestFailed];
        return;
    }

    if(kDEBUGMODE) {
        NSLog(@"=== WhatsApp registration ===");
        NSLog(@"Send to number : %@", whatsappNumber);
        NSLog(@"wa_link (open) : %@", waLink);
        NSLog(@"Poll token     : %@", waToken);
        NSLog(@"=============================");
    }

    openButton.hidden = NO;
    [self openWhatsapp];
    [self startPolling];
}

- (void)onWhatsappRequestFailed
{
    requestInFlight = NO;
    [spinner stopAnimating];
    statusLabel.text = @"Не удалось начать регистрацию через WhatsApp.";
    statusLabel.hidden = NO;
    retryButton.hidden = NO;
    openButton.hidden = YES;
}

#pragma mark - Open WhatsApp

- (void)openWhatsapp
{
    if(waLink.length == 0) return;

    NSURL *url = [NSURL URLWithString:waLink];
    UIApplication *app = [UIApplication sharedApplication];
    if([app canOpenURL:url]) {
        [app openURL:url];
    } else {
        [UIHelper showAlertWithMessage:@"Установите WhatsApp, чтобы продолжить"];
    }
}

#pragma mark - Polling

- (void)startPolling
{
    [self stopPolling];
    pollStartTime = [NSDate date];
    statusLabel.text = @"Ожидание подтверждения из WhatsApp...";
    statusLabel.hidden = NO;
    retryButton.hidden = YES;
    [spinner startAnimating];
    pollTimer = [NSTimer scheduledTimerWithTimeInterval:kPollIntervalSeconds
                                                 target:self
                                               selector:@selector(pollTick)
                                               userInfo:nil
                                                repeats:YES];
}

- (void)stopPolling
{
    [pollTimer invalidate];
    pollTimer = nil;
    [spinner stopAnimating];
}

- (void)pollTick
{
    if([[NSDate date] timeIntervalSinceDate:pollStartTime] >= kPollTimeoutSeconds) {
        [self onTimeout];
        return;
    }
    if(waToken.length == 0) return;

    __weak WhatsAppLoginViewController *wSelf = self;
    [AccountApi whatsappStatus:waToken success:^(id response) {
        [wSelf onStatusResponse:response];
    } failure:^(NSInteger code, NSString *message) {
        // Transient poll error — the timer will retry on the next tick.
    }];
}

- (void)onStatusResponse:(id)response
{
    NSString *token = response[@"token"];
    if(token.length > 0) {
        // Verified — response is the full user object with the real api_key.
        [self stopPolling];
        [self signInWithUserData:response];
    }
    // else still pending: keep waiting.
}

- (void)onTimeout
{
    [self stopPolling];
    statusLabel.text = [NSString stringWithFormat:@"Мы не получили ваше сообщение с номера %@. Убедитесь, что WhatsApp установлен на этой SIM, и повторите.", [self.phoneNumber phoneNumberPresentation]];
    statusLabel.hidden = NO;
    retryButton.hidden = NO;
}

#pragma mark - Sign in

- (void)signInWithUserData:(NSDictionary *)data
{
    User *user = [User instanceFromDictionary:data];

    // Store session — same pattern as the SMS OTP flow (ConfirmSmsViewController).
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

#pragma mark - Actions

- (void)openTapped
{
    [self openWhatsapp];
    if(pollTimer == nil && waToken.length > 0) {
        [self startPolling];
    }
}

- (void)retryTapped
{
    waToken = nil;
    waLink = nil;
    whatsappNumber = nil;
    [self startWhatsappRequest];
}

// DEBUG-only: WhatsApp verification can't be exercised in the simulator (needs a real
// SIM). This shortcut signs in via the still-present activate endpoint using the test
// code, yielding a real session so the authenticated screens can be developed.
- (void)debugSkipTapped
{
    [self stopPolling];
    [Toast showHudWithTitle:@"Debug вход"];
    [AccountApi register:self.phoneNumber companyName:nil success:^(id r1) {
        [AccountApi confirmRegistration:self.phoneNumber activationCode:@"1920" success:^(id response) {
            [self signInWithUserData:response];
        } failure:^(NSInteger code, NSString *message) {}];
    } failure:^(NSInteger code, NSString *message) {}];
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
    titleLabel.text = @"Подтвердите вход через WhatsApp:";
    titleLabel.width = 260;
    [titleLabel sizeToFit];
    titleLabel.centerX = self.view.centerX;
    titleLabel.y = 135;
    [sv addSubview:titleLabel];

    UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    infoLabel.backgroundColor = [UIColor clearColor];
    infoLabel.font = [UIFont robotoThin:15];
    infoLabel.textColor = [UIColor whiteColor];
    infoLabel.lineBreakMode = NSLineBreakByWordWrapping;
    infoLabel.numberOfLines = 0;
    infoLabel.textAlignment = NSTextAlignmentCenter;
    infoLabel.text = @"Откроется WhatsApp с готовым сообщением. Отправьте его с этого номера, чтобы войти.";
    infoLabel.width = 280;
    [infoLabel sizeToFit];
    infoLabel.centerX = self.view.centerX;
    infoLabel.y = titleLabel.bottom + 12;
    [sv addSubview:infoLabel];

    __weak WhatsAppLoginViewController *wSelf = self;

    openButton = [[AAButton alloc] initWithWidth:230 onTap:^(UIView *_self) {
        [wSelf openTapped];
    }];
    [openButton commonStyleButtonWithTitle:@"ОТКРЫТЬ WHATSAPP"];
    [openButton setTitleFont:[UIFont robotoRegular:18]];
    openButton.centerX = self.view.centerX;
    openButton.y = infoLabel.bottom + 24;
    openButton.hidden = YES;
    [sv addSubview:openButton];

    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    spinner.centerX = self.view.centerX;
    spinner.y = openButton.bottom + 24;
    [sv addSubview:spinner];

    statusLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    statusLabel.backgroundColor = [UIColor clearColor];
    statusLabel.font = [UIFont robotoThin:15];
    statusLabel.textColor = [UIColor whiteColor];
    statusLabel.lineBreakMode = NSLineBreakByWordWrapping;
    statusLabel.numberOfLines = 0;
    statusLabel.textAlignment = NSTextAlignmentCenter;
    statusLabel.width = 280;
    statusLabel.height = 60;
    statusLabel.centerX = self.view.centerX;
    statusLabel.y = spinner.bottom + 12;
    [sv addSubview:statusLabel];

    retryButton = [[AAButton alloc] initWithWidth:160 onTap:^(UIView *_self) {
        [wSelf retryTapped];
    }];
    [retryButton commonStyleButtonWithTitle:@"ПОВТОРИТЬ"];
    [retryButton setTitleFont:[UIFont robotoRegular:18]];
    retryButton.centerX = self.view.centerX;
    retryButton.y = statusLabel.bottom + 12;
    retryButton.hidden = YES;
    [sv addSubview:retryButton];

    if(kDEBUGMODE) {
        AAButton *debugButton = [[AAButton alloc] initWithWidth:220 onTap:^(UIView *_self) {
            [wSelf debugSkipTapped];
        }];
        [debugButton commonStyleButtonWithTitle:@"ПРОПУСТИТЬ (DEBUG)"];
        [debugButton setTitleFont:[UIFont robotoRegular:14]];
        debugButton.centerX = self.view.centerX;
        debugButton.y = retryButton.bottom + 40;
        [sv addSubview:debugButton];
    }
}

@end
