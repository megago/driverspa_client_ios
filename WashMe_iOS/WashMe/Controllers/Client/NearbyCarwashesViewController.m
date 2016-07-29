//
//  NearbyCarwashesViewController.m
//  WashMe
//
//  Created by Almas Adilbek on 10/11/15.
//  Copyright (c) 2015 Almas Adilbek. All rights reserved.
//

#import <ConcisePureLayout/UIView+ConcisePureLayout.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "NearbyCarwashesViewController.h"
#import "UIViewController+Ext.h"
#import "Carwash.h"
#import "CarwashCell.h"
#import "CarwashViewController.h"
#import "UIViewController+NavigationBar.h"
#import "CarwashesMapViewController.h"
#import "SearchViewController.h"
#import "City.h"
#import "UserSettings.h"
#import "CarwashApi.h"
#import "CarwashesHelper.h"
#import "LocationHelper.h"
#import "SearchFilterViewController.h"
#import "UIViewController+NoContent.h"
#import "SVProgressHUD+Ext.h"
#import "UIScrollView+InfiniteScroll.h"

@interface NearbyCarwashesViewController ()
@end

@implementation NearbyCarwashesViewController {
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [[LocationHelper sharedInstance] requestLocation:^(CLLocation *currentLocation) {
        [self loadCarwashes:NO];

        // Define or check the nearest city
        [UserSettings defineCurrentCity];

    } failed:^(INTULocationStatus status) {
        [self loadCarwashes:NO];

        // Define or check the nearest city
        [UserSettings defineCurrentCity];
    }];

    self.allowInfiniteLoading = YES;
}

-(void)loadCarwashes:(BOOL)loadingMore
{
    // Remove no content message if any
    [self removeNoContentMessageIfExists];

    if(!loadingMore) [SVProgressHUD showLoading];
    
    [CarwashApi getPublicCarwashes:nil success:^(NSArray *response) {
    //[CarwashApi getCarwashes:self.page filterManager:self.filterManager success:^(NSArray *response) {

        [SVProgressHUD dismiss];
        [self.list finishInfiniteScroll];

        if(response && response.count == 0) {
            self.allowInfiniteLoading = NO;
        }

        if(!self.carwashes) {
            self.carwashes = [[NSMutableArray alloc] init];
        }

        if(!loadingMore) {
            self.carwashes = [response mutableCopy];
        } else {
            [self.carwashes addObjectsFromArray:response];
        }
        if(self.carwashes.count == 0) {
            [self showNoContentMessage:@"Ничего не найдено"];
        }
        [self.list reloadData];

    } failure:^(NSInteger code, NSString *message) {
        [SVProgressHUD dismiss];
    }];
}

#pragma mark -
#pragma mark Actions

- (void)tapNavigationMenuButton {
    SearchFilterViewController *v = [SearchFilterViewController new];
    v.delegate = self;
    v.filterManager = self.filterManager;
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:v];
    [self presentViewController:nc animated:YES completion:nil];
}

#pragma mark -
#pragma mark SearchFilterViewController

- (void)SearchFilterViewControllerSearchWithFilter:(FilterManager *)filterManager {
    self.filterManager = filterManager;
    [self dismissViewControllerAnimated:YES completion:^{
        [self loadCarwashes:NO];
    }];
}

#pragma mark -

-(void)configUI
{
    [super configUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc {

}

@end