//
//  AdminBoxViewController.m
//  WashMe
//
//  Created by Almas Adilbek on 3/17/15.
//  Copyright (c) 2015 Almas Adilbek. All rights reserved.
//

#import "AdminBoxViewController.h"
#import "UIViewController+Ext.h"
#import "CarwashComplex.h"

@interface AdminBoxViewController ()
@end

@implementation AdminBoxViewController

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
    [self setBlueBackground];
    [self setNavigationTitle:[NSString stringWithFormat:@"Бокс #%i", self.boxIndex + 1]];
    [self setBackButtonInNavigation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc {

}

@end