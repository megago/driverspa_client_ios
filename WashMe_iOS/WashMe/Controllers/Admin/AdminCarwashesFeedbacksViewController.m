//
//  AdminCarwashesFeedbacksViewController.m
//  WashMe
//
//  Created by Almas Adilbek on 10/21/14.
//  Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

#import "AdminCarwashesFeedbacksViewController.h"
#import "UIViewController+Ext.h"
#import "RowButtonDisclosureView.h"
#import "UIViewController+NavigationBar.h"

@interface AdminCarwashesFeedbacksViewController ()
@end

@implementation AdminCarwashesFeedbacksViewController

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

- (void)newFeedbacksTapped {

}

- (void)allFeedbacksTapped {

}

#pragma mark -

-(void)configUI
{
    [super configUI];
    [self setBlueBackground];
    [self setNavigationTitle:@"Отзывы"];
    [self showMenuButton];
    [self setNavigationBarTransparent];

    RowButtonDisclosureView *row1 = [[RowButtonDisclosureView alloc] initWithIcon:nil title:@"Новые отзывы (3)" target:self selector:@selector(newFeedbacksTapped)];
    row1.y = 30;
    [sv addSubview:row1];

    RowButtonDisclosureView *row2 = [[RowButtonDisclosureView alloc] initWithIcon:nil title:@"Все отзывы" target:self selector:@selector(allFeedbacksTapped)];
    row2.y = row1.bottom;
    [sv addSubview:row2];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc {

}

@end