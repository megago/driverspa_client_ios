//
//  FreeCarwashesViewController.m
//  WashMe
//
//  Created by Almas Adilbek on 10/11/15.
//  Copyright (c) 2015 Almas Adilbek. All rights reserved.
//

#import <SVProgressHUD/SVProgressHUD.h>
#import <UIScrollView-InfiniteScroll/UIScrollView+InfiniteScroll.h>
#import "FreeCarwashesViewController.h"
#import "LocationHelper.h"
#import "UserSettings.h"
#import "UIViewController+NoContent.h"
#import "CarwashesHelper.h"
#import "CarwashApi.h"
#import "SVProgressHUD+Ext.h"
#import "FilterManager.h"

@interface FreeCarwashesViewController ()
@end

@implementation FreeCarwashesViewController {
}

-(void)initVars {
    [super initVars];

    self.filterManager.free = @"true";
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
}

-(void)loadCarwashes:(BOOL)loadingMore
{
    // Remove no content message if any
    [self removeNoContentMessageIfExists];

    if(!loadingMore) [SVProgressHUD showLoading];
    [CarwashApi getCarwashes:self.page filterManager:self.filterManager success:^(NSArray *response) {

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