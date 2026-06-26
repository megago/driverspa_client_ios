//
//  AdminMainViewController.m
//  WashMe
//
//  Created by Almas Adilbek on 10/20/14.
//  Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

#import "AdminMainViewController.h"
#import "UIViewController+Ext.h"
#import "User.h"
#import "AppDelegate.h"
#import "RowButtonView.h"
#import "RowButtonDisclosureView.h"
#import "StatisticsViewController.h"
#import "AdminCarwashesFeedbacksViewController.h"
#import "AdminOrdersViewController.h"
#import "BoxSettingsListViewController.h"
#import "AdminCarwashBoxesSchedulesViewController.h"

@interface AdminMainViewController ()
@end

@implementation AdminMainViewController

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
#pragma mark Actions

- (void)ordersButtonTapped {
    AdminOrdersViewController *v = [[AdminOrdersViewController alloc] init];
    [self.navigationController pushViewController:v animated:YES];
}

- (void)statisticsButtonTapped {
    StatisticsViewController *v = [[StatisticsViewController alloc] init];
    [self.navigationController pushViewController:v animated:YES];
}

- (void)feedbacksButtonTapped {
    AdminCarwashesFeedbacksViewController *v = [[AdminCarwashesFeedbacksViewController alloc] init];
    [self.navigationController pushViewController:v animated:YES];
}

- (void)boxSettingsButtonTapped {
    BoxSettingsListViewController *v = [[BoxSettingsListViewController alloc] init];
    [self.navigationController pushViewController:v animated:YES];
}

- (void)ordersTableButtonTapped {
    AdminCarwashBoxesSchedulesViewController *v = [[AdminCarwashBoxesSchedulesViewController alloc] init];
    [self.navigationController pushViewController:v animated:YES];
}

#pragma mark -

-(void)configUI {
    [super configUI];
    [self setBlueBackground];
    [self setNavigationTitle:[User currentUser].companyName];

    // Row Buttons
    RowButtonDisclosureView *ordersButton = [[RowButtonDisclosureView alloc] initWithIcon:@"icon-orders" title:@"Заказы" target:self selector:@selector(ordersButtonTapped)];
    ordersButton.y = 30;
    [sv addSubview:ordersButton];

    RowButtonDisclosureView *ordersTableButton = [[RowButtonDisclosureView alloc] initWithIcon:@"icon-grid" title:@"Таблица броней" target:self selector:@selector(ordersTableButtonTapped)];
    ordersTableButton.y = ordersButton.bottom;
    [sv addSubview:ordersTableButton];

    RowButtonDisclosureView *boxSettingsButton = [[RowButtonDisclosureView alloc] initWithIcon:@"icon-settings-bold" title:@"Настройка боксов" target:self selector:@selector(boxSettingsButtonTapped)];
    boxSettingsButton.y = ordersTableButton.bottom;
    [sv addSubview:boxSettingsButton];

    RowButtonDisclosureView *feedbacksButton = [[RowButtonDisclosureView alloc] initWithIcon:@"icon-feedbacks" title:@"Отзывы" target:self selector:@selector(feedbacksButtonTapped)];
    feedbacksButton.y = boxSettingsButton.bottom;
    [sv addSubview:feedbacksButton];

    RowButtonDisclosureView *statisticsButton = [[RowButtonDisclosureView alloc] initWithIcon:@"icon-report" title:@"Статистика" target:self selector:@selector(statisticsButtonTapped)];
    statisticsButton.y = feedbacksButton.bottom;
    [sv addSubview:statisticsButton];

//    RowButtonDisclosureView *closeOrdersButton = [[RowButtonDisclosureView alloc] initWithIcon:@"icon-close-filled" title:@"Закрыть бронирования" target:self selector:@selector(closeOrdersButtonTapped)];
//    closeOrdersButton.y = statisticsButton.bottom;
//    [sv addSubview:closeOrdersButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc {

}

@end