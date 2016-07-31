//
//  CarwashesViewController.m
//  WashMe
//
//  Created by Almas Adilbek on 9/13/14.
//  Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

#import "CarwashesViewController.h"
#import "UIViewController+Ext.h"
#import "Version.h"
#import "CarwashCell.h"
#import "CarwashApi.h"
#import "Carwash.h"
#import "CarwashesMapViewController.h"
#import "LocationHelper.h"
#import "CarwashesHelper.h"
#import "AppDelegate.h"
#import "UserApi.h"
#import "SearchViewController.h"
#import "NavigationDropdownMenuView.h"
#import "UserSettings.h"
#import "City.h"
#import "UIViewController+NoContent.h"

@interface CarwashesViewController ()
@end

@implementation CarwashesViewController {
    UITableView *list;

    NSArray *carwashes;
    NSInteger page;
    NavigationDropdownMenuView *menuView;
}

-(id)init {
    self = [super init];
    if(self) {
        [self initVars];
    }
    return self;
}

-(void)initVars {
    page = 1;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configUI];
    [self addObservers];

    [[LocationHelper sharedInstance] requestLocation:^(CLLocation *currentLocation) {
        [self loadCarwashes];

        // Define or check the nearest city
        [UserSettings defineCurrentCity];

    } failed:^(INTULocationStatus status) {
        [self loadCarwashes];

        // Define or check the nearest city
        [UserSettings defineCurrentCity];
    }];
}

-(void)loadCarwashes
{
    // Remove no content message if any
    [self removeNoContentMessageIfExists];

    City *currentCity = [UserSettings currentCity];
    if(currentCity)
    {
        [Toast showHudLoading];
        [CarwashApi getCarwashes:^(id response) {
            carwashes = [CarwashesHelper sortCarwashesByDistance:response];
            if(carwashes.count == 0) {
                [self showNoContentMessageText];
            }
            [list reloadData];
        } failure:^(NSInteger code, NSString *message) {

        }];
    }
    else
    {
        [self loadNearbyCarwashes];
    }
}

- (void)loadNearbyCarwashes
{
    [Toast showHudLoading];
    [CarwashApi getCarwashes:page filterManager:nil success:^(id response) {
        carwashes = [CarwashesHelper sortCarwashesByDistance:response];
        if(carwashes.count == 0) {
            [self showNoContentMessageText];
        }
        [list reloadData];
    } failure:^(NSInteger code, NSString *message) {

    }];
}

#pragma mark -
#pragma mark Actions

-(void)mapTapped
{
    CarwashesMapViewController *v = [[CarwashesMapViewController alloc] init];
    v.carwashes = carwashes;

    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:v];
    [nc setNavigationBarHidden:YES];
    nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;

    [self presentViewController:nc animated:YES completion:nil];
}

- (void)searchTapped
{
    SearchViewController *v = [[SearchViewController alloc] init];
    [self.navigationController pushViewController:v animated:YES];
}

#pragma mark -
#pragma mark NavigationDropdownMenuView

- (void)navigationDropdownMenuViewNearbyTapped
{
    // Remove no content message if any
    [self removeNoContentMessageIfExists];
    [self loadNearbyCarwashes];
}

- (void)navigationDropdownMenuViewCityTapped:(City *)city
{
    // Set new selected city
    

    // Reload carwashes with new city
    [self loadCarwashes];
}

#pragma mark -
#pragma mark UITableView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return carwashes.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Carwash *carwash = carwashes[(NSUInteger) indexPath.row];
    return [CarwashCell cellHeight:carwash.name];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"cell";
    CarwashCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[CarwashCell alloc] initWithReuseIdentifier:CellIdentifier];
    }
    [cell setCarwash:carwashes[(NSUInteger) indexPath.row]];

    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    CarwashViewController *v = [[CarwashViewController alloc] init];
    v.carwash = carwashes[(NSUInteger) indexPath.row];
    [self.navigationController pushViewController:v animated:YES];
}

#pragma mark -
#pragma mark Notification

- (void)addObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cityChangedNotification:) name:kNotificationCityChanged object:nil];
}

- (void)removeObservers {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationCityChanged object:nil];
}

- (void)cityChangedNotification:(NSNotification *)notification {
    City *city = [notification object];
    if(city) {
        [menuView setTitle:city.title];
    }
    [self loadCarwashes];
}

#pragma mark -

- (void)showNoContentMessageText {
    [self showNoContentMessage:@"Нет моек"];
}

-(void)configUI
{
    [self setBlueBackground];

    [self createBarButtonAtLeft:NO buttonImage:@"icon-map" target:self selector:@selector(mapTapped)];
    [self createBarButtonAtLeft:YES buttonImage:@"icon-search" target:self selector:@selector(searchTapped)];

    // List
    CGFloat listY = 64;
    list = [[UITableView alloc] initWithFrame:CGRectMake(0, listY, [ASize screenWidth], [ASize screenHeight] - listY - 44) style:UITableViewStylePlain];
    list.delegate = self;
    list.dataSource = self;
    list.backgroundView = [[UIView alloc] init];
    list.backgroundColor = [UIColor clearColor];
    list.separatorColor = [UIColor clearColor];
    [self.view addSubview:list];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc {
    [self removeObservers];
}

@end