//
//  StatisticsViewController.m
//  WashMe
//
//  Created by Almas Adilbek on 10/21/14.
//  Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

#import "StatisticsViewController.h"
#import "UIViewController+Ext.h"
#import "RowButtonDisclosureView.h"

@interface StatisticsViewController ()
@end

@implementation StatisticsViewController

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

- (void)alltimeTapped {

}

- (void)monthTapped {

}

- (void)weekTapped {

}

- (void)todayTapped {

}

#pragma mark -

-(void)configUI
{
    [super configUI];
    [self setBackButtonInNavigation];
    [self setBlueBackground];
    [self setNavigationTitle:@"Статистика"];

    RowButtonDisclosureView *row1 = [[RowButtonDisclosureView alloc] initWithIcon:nil title:@"За сегодня" target:self selector:@selector(todayTapped)];
    row1.y = 30;
    [sv addSubview:row1];

    RowButtonDisclosureView *row2 = [[RowButtonDisclosureView alloc] initWithIcon:nil title:@"За неделю" target:self selector:@selector(weekTapped)];
    row2.y = row1.bottom;
    [sv addSubview:row2];

    RowButtonDisclosureView *row3 = [[RowButtonDisclosureView alloc] initWithIcon:nil title:@"За месяц" target:self selector:@selector(monthTapped)];
    row3.y = row2.bottom;
    [sv addSubview:row3];

    RowButtonDisclosureView *row4 = [[RowButtonDisclosureView alloc] initWithIcon:nil title:@"За все время" target:self selector:@selector(alltimeTapped)];
    row4.y = row3.bottom;
    [sv addSubview:row4];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc {

}

@end