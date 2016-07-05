//
//  AkciiViewController.m
//  WashMe
//
//  Created by Almas Adilbek on 10/11/15.
//  Copyright (c) 2015 Almas Adilbek. All rights reserved.
//

#import "AkciiViewController.h"
#import "UIViewController+Ext.h"
#import "UIViewController+NavigationBar.h"

@interface AkciiViewController ()
@end

@implementation AkciiViewController

-(void)initVars {}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configUI];
}

#pragma mark -

-(void)configUI
{
    [self setBlueBackground];
    [self setNavigationBarTransparent];
    self.title = @"Акции";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc {

}

@end