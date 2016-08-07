//
// Created by Almas Adilbek on 9/7/14.
// Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

#import "WelcomeViewController.h"
#import "UIImage+Extensions.h"
#import "UIView+Animation.h"
#import "NSObject+PWObject.h"
#import "UIFont+Custom.h"
#import "AAButton.h"
#import "AAButton+Styles.h"
#import "RegistrationViewController.h"
#import "UIViewController+Ext.h"
#import "UserSettings.h"
#import <EAIntroView/EAIntroView.h>
#import "AdminDummyViewControlller.h"

@interface WelcomeViewController () <EAIntroDelegate>
@end

@implementation WelcomeViewController {
    UIView *fader;
    UILabel *welcomeLabel;
    AAButton *userButton;
    AAButton *clientButton;
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

    [[self whiteLogo] fadeBottomTop:^(BOOL finished) {
        [fader fadeInToAlpha:0.7 completed:^(BOOL finished) {
            [welcomeLabel fadeBottomTop:^(BOOL finished) {
                [userButton fadeBottomTop:^(BOOL finished) {
                    [clientButton fadeBottomTop:^(BOOL finished) {

                    }];
                }];
            }];
        }];
    }];
    
    //[self showIntro];
}

- (void)configAction
{

}

#pragma mark -
#pragma mark Actions

- (void)userButtonTapped
{
    [UserSettings setIsAdmin:NO];
    [self gotoRegistration];
}

- (void)carwashButtonTapped
{
    [UserSettings setIsAdmin:YES];
    //[self gotoRegistration];
    [self gotoDummy];
}

- (void)gotoRegistration {
    RegistrationViewController *v = [[RegistrationViewController alloc] init];
    [self.navigationController pushViewController:v animated:YES];
}

- (void)gotoDummy {
    AdminDummyViewControlller *v = [[AdminDummyViewControlller alloc] init];
    [self.navigationController pushViewController:v animated:YES];
}

#pragma mark -

-(void)configUI
{
    self.view.backgroundColor = [UIColor whiteColor];

    __weak WelcomeViewController *wSelf = self;

    UIImageView *bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"welcome-vc-bg"]];
    bgView.width = [ASize screenWidth];
    bgView.height = [ASize screenHeight];
    [self.view addSubview:bgView];

    [self createWashMeWhiteLogo];
    [self whiteLogo].alpha = 0;

    fader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [ASize screenWidth], 278)];
    fader.y = [ASize screenHeight] - fader.height;
    fader.backgroundColor = [UIColor fromRGB:0x231f20];
    fader.alpha = 0;
    [self.view addSubview:fader];

    welcomeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    welcomeLabel.alpha = 0;
    welcomeLabel.backgroundColor = [UIColor clearColor];
    welcomeLabel.font = [UIFont robotoThin:28];
    welcomeLabel.textColor = [UIColor whiteColor];
    welcomeLabel.text = @"Добро пожаловать!";
    [welcomeLabel sizeToFit];
    welcomeLabel.centerX = self.view.centerX;
    welcomeLabel.y = fader.y + 25;
    [self.view addSubview:welcomeLabel];

    userButton = [[AAButton alloc] initWithWidth:250 onTap:^(UIView *_self) {
        [wSelf userButtonTapped];
    }];
    userButton.alpha = 0;
    [userButton commonStyleButtonWithTitle:@"Я АВТОМОБИЛИСТ, ХОЧУ\nПОМЫТЬ МАШИНУ"];
    [userButton setTitleFont:[UIFont robotoRegular:18]];
    userButton.centerX = self.view.centerX;
    userButton.y = welcomeLabel.bottom + 40;
    userButton.height = 74;
    [self.view addSubview:userButton];

    clientButton = [[AAButton alloc] initWithWidth:userButton.width onTap:^(UIView *_self) {
        [wSelf carwashButtonTapped];
    }];
    clientButton.alpha = 0;
    [clientButton commonStyleButtonWithTitle:@"Я АДМИНИСТРАТОР\nАВТОМОЙКИ"];
    [clientButton setTitleFont:[UIFont robotoRegular:18]];
    clientButton.centerX = self.view.centerX;
    clientButton.y = userButton.bottom + 10;
    clientButton.height = 50;
    [self.view addSubview:clientButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc {

}

#pragma mark - EAIntro

- (void) showIntro
{
    UIFont *descFont = [UIFont fontWithName:@"Helvetica Neue" size:18];
    //CGFloat descPositionY = 250;
    
    EAIntroPage *page1 = [EAIntroPage page];
    page1.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"intro_1"]];
    
    page1.desc = @"Привлекайте дополнительных клиентов, сообщайте об акциях и новостях!";
    page1.descFont = descFont;
    page1.descColor = [UIColor whiteColor];
    //page1.descPositionY = descPositionY;
    
    EAIntroPage *page2 = [EAIntroPage page];
    page2.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"intro_2"]];
    page2.desc = @"Сравнивайте цены и качество обслуживания в автомойках вашего города";
    page2.descFont = descFont;
    page2.descColor = [UIColor whiteColor];
    //page2.descPositionY = descPositionY;
    
    EAIntroPage *page3 = [EAIntroPage page];
    page3.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"intro_3"]];
    page3.desc = @"Находите ближайщие автомойки и бронируйте удобное для вас время заранее!";
    page3.descFont = descFont;
    page3.descColor = [UIColor whiteColor];
    //page3.descPositionY = descPositionY;
    
    
    
    EAIntroView *intro = [[EAIntroView alloc] initWithFrame:self.view.bounds
                                                   andPages:
                          @[
                            page1,
                            page2,
                            page3,
                            
                            ]];
    intro.backgroundColor = [UIColor blackColor];
    UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    backgroundView.image = [UIImage imageNamed:@"blue-bg"];
    backgroundView.contentMode = UIViewContentModeScaleAspectFill;
    [intro addSubview:backgroundView];
    [intro sendSubviewToBack:backgroundView];
    
    
    //intro.pageControlY = 80.0f;
    //intro.skipButtonY = 40;
    //intro.skipButtonAlignment = EAViewAlignmentCenter;
    intro.skipButton = nil;
    
    [intro setDelegate:self];
    [intro showInView:self.view];
}

- (void)intro:(EAIntroView *)introView pageAppeared:(EAIntroPage *)page withIndex:(NSUInteger)pageIndex
{
    UIView *header = [introView viewWithTag:101];
    if (header){
        [UIView animateWithDuration:0.3 animations:^{
            header.alpha = 1.f;
        }];
        [header removeFromSuperview];
    }
    
    UILabel *lblHeader = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [ASize screenWidth], 80)];
    lblHeader.textAlignment = NSTextAlignmentCenter;
    lblHeader.font = [UIFont fontWithName:@"Helvetica Neue" size:24.f];
    lblHeader.textColor = [UIColor whiteColor];
    lblHeader.text = pageIndex == 0 ? @"Владельцам автомоек" : @"Автомобилистам";
    lblHeader.tag = 101;
    lblHeader.alpha = 1.f;
    [introView addSubview:lblHeader];
    
    [UIView animateWithDuration:0.3 animations:^{
        header.alpha = 0.f;
    }];
}

- (void)introDidFinish:(EAIntroView *)introView
{
    [introView removeFromSuperview];
}

@end