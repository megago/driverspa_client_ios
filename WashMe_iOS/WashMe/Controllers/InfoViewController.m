//
//  InfoViewController.m
//  WashMe
//
//  Created by Ivan Korotkikh on 18.02.17.
//  Copyright © 2017 Almas Adilbek. All rights reserved.
//

#import "InfoViewController.h"
#import "UIViewController+Ext.h"
#import "UIViewController+NavigationBar.h"
#import "CenterTitle.h"

@interface InfoViewController ()

@end

@implementation InfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tabBarController.tabBar.hidden = YES;
    [self configUI];
}

-(void)configUI
{
    [super configUI];
    [self setBlueBackground];
    [self setNavigationBarTransparent];
    [self showMenuButton];
    [self buildUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)buildUI {
    CGFloat rowsSpacing = 10;
    CGFloat rowWidth = [ASize screenWidth] - 2*rowsSpacing;
    
    CenterTitle *subtitleLabel = [[CenterTitle alloc] initWithTitle:_message width:rowWidth];
    [subtitleLabel sizeToFit];
    subtitleLabel.centerX = sv.centerX;
    subtitleLabel.y = 100;
    [sv addSubview:subtitleLabel];
}

@end
