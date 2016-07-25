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


@interface WelcomeViewController ()
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
    [self gotoRegistration];
}

- (void)gotoRegistration {
    RegistrationViewController *v = [[RegistrationViewController alloc] init];
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

@end