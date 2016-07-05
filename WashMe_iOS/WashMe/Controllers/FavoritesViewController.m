//
//  FavoritesViewController.m
//  WashMe
//
//  Created by Almas Adilbek on 2/12/15.
//  Copyright (c) 2015 Almas Adilbek. All rights reserved.
//

#import <ConcisePureLayout/UIView+ConcisePureLayout.h>
#import "FavoritesViewController.h"
#import "UIViewController+Ext.h"
#import "ScrollViewControllerOld.h"
#import "Carwash.h"
#import "CarwashCell.h"
#import "CarwashViewController.h"
#import "UserApi.h"
#import "CarwashesHelper.h"
#import "UIScrollView+EmptyDataSet.h"
#import "ALView+PureLayout.h"
#import "UIViewController+NoContent.h"

@interface FavoritesViewController ()
@property(nonatomic, copy) NSArray *carwashes;
@end

@implementation FavoritesViewController {
    UITableView *list;
}

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
    [self addObservers];

    [Toast showHudLoading];
    [UserApi bookmarks:^(id response) {
        [self onCarwashesResponse:response];
    } failure:^(NSInteger code, NSString *message) {

    }];
}

#pragma mark -
#pragma mark Actions

- (void)onCarwashesResponse:(id)response
{
    _carwashes = [CarwashesHelper sortCarwashesByDistance:response];
    [list reloadData];
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
#pragma mark DZN

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    return YES;
}

- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView {

    UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [ASize screenWidth], 300)];

    /*UIView *view = [UIView newAutoLayoutView];
    [container addSubview:view];
    [view autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:container withMultiplier:0.7];
    [view aa_centerInSuperview];*/

    /*UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.filterParams ? @"iconSearchNoresult" : @"restaurante_icn"]];
    [iconView aa_setDimensions];
    [view addSubview:iconView];
    [iconView aa_superviewTop:0];
    [iconView aa_centerHorizontal];*/

    UILabel *titleLabel = [UILabel newAutoLayoutView];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textColor = [UIColor lightGrayColor];
    titleLabel.text = @"У Вас нет избранных автомоек";
    titleLabel.numberOfLines = 0;
    titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [container addSubview:titleLabel];
    [titleLabel aa_centerInSuperview];

    return container;
}

#pragma mark -
#pragma mark CarwashViewController

- (void)carwashAddedToFavorites:(NSNotification *)notification
{
    [self removeNoContentMessageIfExists];

    NSDictionary *userInfo = notification.userInfo;
    Carwash *carwash = userInfo[@"carwash"];

    for(Carwash *obj in _carwashes) {
        if([obj.carwashId isEqual:carwash.carwashId]) return;
    }

    NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:_carwashes];
    [mutableArray addObject:carwash];
    self.carwashes = mutableArray;

    [self loadCarwashesFromArray:_carwashes];
}

- (void)carwashRemovedFromFavorites:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    Carwash *carwash = userInfo[@"carwash"];

    NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:_carwashes];

    for(Carwash *obj in _carwashes) {
        if([obj.carwashId isEqual:carwash.carwashId]) {
            [mutableArray removeObject:obj];
            break;
        }
    }
    [self loadCarwashesFromArray:mutableArray];
    if(_carwashes.count == 0) {
        [self showNoContentMessage];
    }
}

#pragma mark -
#pragma mark Notifications

- (void)addObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(carwashAddedToFavorites:) name:kNotificationCarwashAddedToFavorites object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(carwashRemovedFromFavorites:) name:kNotificationCarwashRemovedFromFavorites object:nil];
}

- (void)removeObservers {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationCarwashAddedToFavorites object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationCarwashRemovedFromFavorites object:nil];
}

#pragma mark -

- (void)showNoContentMessage {
//    [self showNoContentMessage:@"У Вас нет избранных автомоек"];
}

- (void)loadCarwashesFromArray:(NSArray *)array {
    self.carwashes = [NSArray arrayWithArray:[CarwashesHelper sortCarwashesByDistance:array]];
    [list reloadData];
}

-(void)configUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    [self setBlueBackground];
    [self setNavigationTitle:@"Избранные"];

    // List
    CGFloat listY = 64;
    list = [[UITableView alloc] initWithFrame:CGRectMake(0, listY, [ASize screenWidth], [ASize screenHeight] - listY - 44) style:UITableViewStylePlain];
    list.delegate = self;
    list.dataSource = self;
    list.emptyDataSetSource = self;
    list.emptyDataSetDelegate = self;
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