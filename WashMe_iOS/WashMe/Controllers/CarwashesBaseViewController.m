//
//  CarwashesBaseViewController.m
//  WashMe
//
//  Created by Almas Adilbek on 4/13/16.
//  Copyright (c) 2016 Almas Adilbek. All rights reserved.
//

#import <ConcisePureLayout/UIView+ConcisePureLayout.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "CarwashesBaseViewController.h"
#import "UserSettings.h"
#import "CarwashApi.h"
#import "UIViewController+Ext.h"
#import "CarwashViewController.h"
#import "UIViewController+NavigationBar.h"
#import "FilterManager.h"
#import "SearchFilterViewController.h"
#import "CarwashesMapViewController.h"
#import "CarwashCell.h"
#import "Carwash.h"
#import "UIScrollView+InfiniteScroll.h"

@interface CarwashesBaseViewController ()

@end

@implementation CarwashesBaseViewController {

}

-(void)initVars {
    self.page = 1;
    self.filterManager = [[FilterManager alloc] init];
}

- (void)viewDidLoad
{
    [self initVars];
    [self configUI];
    [self addObservers];
}

- (void)loadCarwashes:(BOOL)loadMore {

}

#pragma mark -
#pragma mark Actions

- (void)tapNavigationMenuButton {

}

- (void)tapMap {
    [SVProgressHUD showWithStatus:@"Загрузка"];
    [CarwashApi getComplexCarwashes:^(id response) {

        [SVProgressHUD dismiss];

        CarwashesMapViewController *v = [[CarwashesMapViewController alloc] init];
        v.carwashes = response;
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:v];
        [nc setNavigationBarHidden:YES];
        nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:nc animated:YES completion:nil];

    } failure:^(NSInteger code, NSString *message) {
        [SVProgressHUD dismiss];
    }];
}

#pragma mark -
#pragma mark UITableView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _carwashes.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Carwash *carwash = _carwashes[(NSUInteger) indexPath.row];
    return [CarwashCell cellHeight:carwash.name];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"cell";
    CarwashCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[CarwashCell alloc] initWithReuseIdentifier:CellIdentifier];
    }
    [cell setCarwash:_carwashes[(NSUInteger) indexPath.row]];

    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    CarwashViewController *v = [[CarwashViewController alloc] init];
    v.carwash = _carwashes[(NSUInteger) indexPath.row];
    [self.navigationController pushViewController:v animated:YES];
}

#pragma mark -
#pragma mark Notification

- (void)addObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cityChangedNotification:) name:kNotificationCityChanged object:nil];
}

- (void)cityChangedNotification:(NSNotification *)notification {
//    City *city = [notification object];
    [self loadCarwashes:NO];
}

#pragma mark -

- (void)setAllowInfiniteLoading:(BOOL)b {
    _allowInfiniteLoading = b;

    __weak CarwashesBaseViewController * weakSelf = self;
    if(_allowInfiniteLoading) {
        self.list.infiniteScrollIndicatorMargin = 23;
        self.list.infiniteScrollIndicatorStyle = UIActivityIndicatorViewStyleWhite;
        [self.list addInfiniteScrollWithHandler:^(UITableView *tableView) {
            ++ weakSelf.page;
            [weakSelf loadCarwashes:YES];
        }];
    } else {
        [self.list removeInfiniteScroll];
    }
}

-(void)configUI
{
    [self setBlueBackground];
    [self setNavigationBarTransparent];
    [self setNavigationButtonWithIcon:@"icon-map" atLeft:NO selector:@selector(tapMap)];
    [self showMenuButton];

    [self showNavigationMenuButton:@"Фильтр"];

    // List
    self.list = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _list.delegate = self;
    _list.dataSource = self;
    _list.backgroundView = [[UIView alloc] init];
    _list.backgroundColor = [UIColor clearColor];
    _list.separatorColor = [UIColor clearColor];
    [self.view addSubview:_list];
    [_list autoPinToTopLayoutGuideOfViewController:self withInset:0];
    [_list aa_superviewFitWidth];
    [_list autoPinToBottomLayoutGuideOfViewController:self withInset:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end