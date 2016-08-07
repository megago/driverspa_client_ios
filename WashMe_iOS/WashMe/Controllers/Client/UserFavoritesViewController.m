//
//  UserFavoritesViewController.m
//  WashMe
//
//  Created by Almas Adilbek on 10/11/15.
//  Copyright (c) 2015 Almas Adilbek. All rights reserved.
//

#import <ConcisePureLayout/UIView+ConcisePureLayout.h>
#import "UserFavoritesViewController.h"
#import "UIViewController+Ext.h"
#import "ALView+PureLayout.h"
#import "Carwash.h"
#import "CarwashCell.h"
#import "CarwashViewController.h"
#import "FavoritesViewController.h"
#import "CarwashesHelper.h"
#import "UserApi.h"
#import "UIViewController+NavigationBar.h"
#import "UIViewController+NoContent.h"
#import "LGRefreshView.h"

@interface UserFavoritesViewController ()
@property(nonatomic, strong) NSArray *carwashes;
@property(nonatomic, strong) LGRefreshView *refreshView;
@end

@implementation UserFavoritesViewController

-(void)initVars {}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configUI];
    [self addObservers];

    [Toast showHudLoading];
    [self refreshCarwashes];
}

-(void)refreshCarwashes {
    [UserApi bookmarks:^(id response) {
        [self onCarwashesResponse:response];
        [self.refreshView endRefreshing];
    } failure:^(NSInteger code, NSString *message) {
        
    }];
}

#pragma mark -
#pragma mark Actions

- (void)onCarwashesResponse:(id)response
{
    _carwashes = [CarwashesHelper sortCarwashesByDistance:response];
    [_list reloadData];

    if(_carwashes.count == 0) {
        [self showNoContentMessage];
    }
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
#pragma mark UITableView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _carwashes.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Carwash *carwash = _carwashes[(NSUInteger) indexPath.row];
    return [CarwashCell cellHeightWithCarwashName:carwash.name andAddress:carwash.address];
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
    [self showNoContentMessage:@"У Вас нет избранных автомоек"];
}

- (void)loadCarwashesFromArray:(NSArray *)array {
    self.carwashes = [NSArray arrayWithArray:[CarwashesHelper sortCarwashesByDistance:array]];
    [_list reloadData];
}

#pragma mark -

-(void)configUI
{
    [self setNavigationTitle:@"Избранное"];
    [self setBlueBackground];
    [self setNavigationBarTransparent];
    [self showMenuButton];

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
    
    __weak typeof(self) wself = self;
    _refreshView = [LGRefreshView refreshViewWithScrollView:_list
                                             refreshHandler:^(LGRefreshView *refreshView)
                    {
                        [wself refreshCarwashes];
                    }];
    _refreshView.tintColor = [UIColor whiteColor];
    _refreshView.backgroundColor = [UIColor clearColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
