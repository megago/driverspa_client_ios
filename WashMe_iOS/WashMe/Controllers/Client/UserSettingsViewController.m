//
// Created by Almas Adilbek on 10/2/14.
// Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

#import "UserSettingsViewController.h"
#import "UIViewController+Ext.h"
#import "RowButtonDisclosureView.h"
#import "LangsViewController.h"
#import "AccountApi.h"
#import "UserApi.h"
#import "UserSettings.h"
#import "Localization.h"


@interface UserSettingsViewController ()
@end

@implementation UserSettingsViewController

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

#pragma mark -

-(void)configUI
{
    [super configUI];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setBlueBackground];
    [self setNavigationTitle:@"Настройки"];

    RowButtonDisclosureView *langsButton = [[RowButtonDisclosureView alloc] initWithIcon:nil title:[Localization ln:lnLANGUAGE] target:self selector:@selector(langsButtonTapped)];
    langsButton.y = 25;
    [sv addSubview:langsButton];

    RowButtonView *rateAppButton = [[RowButtonView alloc] initWithIcon:nil title:[Localization ln:lnRATE_APP] target:self selector:@selector(rateAppTapped)];
    rateAppButton.y = langsButton.bottom;
    [sv addSubview:rateAppButton];

    UILabel *notificationsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [ASize screenWidth] - 100, 1)];
    notificationsLabel.backgroundColor = [UIColor clearColor];
    notificationsLabel.font = [UIFont robotoRegular:15];
    notificationsLabel.textColor = [UIColor whiteColor];
    notificationsLabel.lineBreakMode = NSLineBreakByWordWrapping;
    notificationsLabel.numberOfLines = 0;
    notificationsLabel.text = @"Я согласен получать информационные уведомления";
    [notificationsLabel sizeToFit];
    notificationsLabel.x = kViewControllerPadding + 10;
    notificationsLabel.y = rateAppButton.bottom + 30;
    [sv addSubview:notificationsLabel];

    UISwitch *notificationsSwitch = [[UISwitch alloc] init];
    [notificationsSwitch addTarget:self action:@selector(apnsNotificationsStateChanged:) forControlEvents:UIControlEventValueChanged];
    notificationsSwitch.x = sv.width - notificationsSwitch.width - kViewControllerPadding;
    notificationsSwitch.centerY = notificationsLabel.centerY;
    [sv addSubview:notificationsSwitch];

    // Set default state of switch
    if([[UserSettings sharedInstance] issetSettings]) {
        NSDictionary *settings = [[UserSettings sharedInstance] settings];
        NSString *allowApns = [settings valueForKey:kSettingsKeyAllowAPNS];
        BOOL notificationsBool = [allowApns isEqual:@"1"];
        [notificationsSwitch setOn:notificationsBool];
    }
}

#pragma mark -
#pragma mark Actions

- (void)rateAppTapped {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@", kAppID]]];
}

- (void)langsButtonTapped {
    LangsViewController *v = [[LangsViewController alloc] init];
    [self.navigationController pushViewController:v animated:YES];
}

- (void)apnsNotificationsStateChanged:(UISwitch *)sender {
    [Toast showHudWait];
    [UserApi settingsSetValue:sender.isOn?@"1":@":del" forKey:kSettingsKeyAllowAPNS success:^(id response) {
        NSLog(@"settingsSetValue: %@", response);
    } failure:nil];
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc {

}

@end