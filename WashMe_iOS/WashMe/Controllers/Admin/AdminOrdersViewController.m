//
//  AdminOrdersViewController.m
//  WashMe
//
//  Created by Almas Adilbek on 11/18/14.
//  Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

#import <ObjectiveSugar/NSArray+ObjectiveSugar.h>
#import "AdminOrdersViewController.h"
#import "UIViewController+Ext.h"
#import "AdminApi.h"
#import "AAButton+Styles.h"
#import "BookAdminCell.h"
#import "CarwashBook.h"
#import "AdminBookViewController.h"
#import "UIViewController+NoContent.h"
#import "UIViewController+NavigationBar.h"
#import <HTHorizontalSelectionList/HTHorizontalSelectionList.h>
#import "UIFont+Custom.h"
#import "LGRefreshView.h"
#import "CarwashComplex.h"
#import "User.h"
#import "AppDelegate.h"
#import "UITabBarItem+CustomBadge.h"

@interface AdminOrdersViewController () <HTHorizontalSelectionListDataSource, HTHorizontalSelectionListDelegate>
@end

@implementation AdminOrdersViewController {
    LGRefreshView *refreshView;
    HTHorizontalSelectionList *selectionList;
    NSArray *tabsMakes;

    AAButton *todayButton;
    AAButton *tomorrowButton;
    enum AdminOrdersFilter currentTableFilter;
    UITableView *list;
    NSMutableArray *books;
    
    int badgeCount;
}

-(id)init {
    self = [super init];
    if(self) {
        [self initVars];
    }
    return self;
}

-(void)initVars {
    currentTableFilter = AdminOrdersInPending;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Request push notification permissions
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate requestPushAndLocalNotificationPermissions];
    
    [self configUI];
    [self loadBooks];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setTabBarVisible:YES animated:YES completion:nil];
    [self loadBooks];
}

- (void)loadBooks
{
    [Toast showHudLoading];

    if(currentTableFilter == AdminOrdersTimeDayToday) {
        [AdminApi ordersToday:^(id response) {
            [self onBooksResponse:response];
            [refreshView endRefreshing];
        } failure:^(NSInteger code, NSString *message) {

        }];
    } else  if (currentTableFilter == AdminOrdersInPending){
        [AdminApi ordersPending:^(id response) {
            [self onBooksResponse:response];
            [refreshView endRefreshing];
        } failure:^(NSInteger code, NSString *message) {

        }];
    } else if (currentTableFilter == AdminOrdersAll) {
        [AdminApi ordersAll:^(id response) {
            [self onBooksResponse:response];
            [refreshView endRefreshing];
        } failure:^(NSInteger code, NSString *message) {
            
        }];
    }
}

- (void)onBooksResponse:(id)response
{
    books = response;
    [self removeNoContentMessageIfExists];

    if(books && books.count > 0) {
        [list reloadData];
        list.hidden = NO;
    } else {
        list.hidden = YES;
        [self showNoContentMessage:@"Нет заказов" withButton:@"Обновить" selector:@selector(loadBooks)];
    }
}

- (void)updateBadge {
    badgeCount = 0;
    for (CarwashBook *book in books) {
        if (book.isPending || book.isApproved) {
            badgeCount++;
        }
    }
    if (badgeCount > 0) {
        [[[[[self tabBarController] tabBar] items] objectAtIndex:3] setCustomBadgeValue:[NSString stringWithFormat:@"%i", badgeCount] withFont:[UIFont robotoBold:12.f] andFontColor:[UIColor whiteColor] andBackgroundColor:[UIColor colorWithRed:37.f/255.f green:195.f/255.f blue:91.f/255.f alpha:1.f]];
        [UIApplication sharedApplication].applicationIconBadgeNumber = badgeCount;
    } else {
        [[[[[self tabBarController] tabBar] items] objectAtIndex:3] setBadgeValue:nil];
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    }
    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInt:badgeCount] forKey:@"badgeCountApplication"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


#pragma mark -
#pragma mark AdminBookViewController

- (void)adminBookViewControllerBookStatusChanged:(CarwashBook *)book
{
    [books eachWithIndex:^(CarwashBook *object, NSUInteger index)
    {
        if([object.carwashBookId isEqual:book.carwashBookId]) {
            books[index] = book;
            [list reloadData];
        }
    }];
}

#pragma mark -
#pragma mark UITableView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return books.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CarwashBook *book = books[(NSUInteger) indexPath.row];
    return [BookAdminCell cellHeight:book];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"cell";
    BookAdminCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[BookAdminCell alloc] initWithReuseIdentifier:CellIdentifier];
    }

    CarwashBook *book = books[indexPath.row];
    [cell setCarwashBook:book];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    __weak CarwashBook *weakBook = books[indexPath.row];
    __weak AdminOrdersViewController * weakSelf = self;
    [self setTabBarVisible:NO animated:YES completion:^(BOOL finished) {
        AdminBookViewController *v = [[AdminBookViewController alloc] init];
        v.delegate = weakSelf;
        v.book = weakBook;
        [weakSelf.navigationController pushViewController:v animated:YES];
    }];
}

#pragma mark -

-(void)configUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    [self setBlueBackground];
    [self setNavigationTitle:@"Заказы"];
    [self showMenuButton];
    [self setNavigationBarTransparent];
    
    selectionList = [[HTHorizontalSelectionList alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 30)];
    selectionList.delegate = self;
    selectionList.dataSource = self;
    selectionList.backgroundColor = [UIColor clearColor];
    selectionList.selectionIndicatorColor = [UIColor whiteColor];
    selectionList.bottomTrimColor = [[UIColor whiteColor] colorWithAlphaComponent:0.25f];
    selectionList.bottomTrimHidden = YES;
    [selectionList setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.25f] forState:UIControlStateNormal];
    [selectionList setTitleFont:[UIFont robotoBold:14.f] forState:UIControlStateNormal];
    
    [self.view  addSubview:selectionList];
    
    tabsMakes = @[@" В ОБРАБОТКЕ  ",
                      @" СЕГОДНЯ  ",
                      @" ВСЕ  ",
                      ];
    
    // List
    CGFloat listY = selectionList.bottom;
    list = [[UITableView alloc] initWithFrame:CGRectMake(0, listY, [ASize screenWidth], [ASize screenHeight]-44 - listY) style:UITableViewStylePlain];
    list.delegate = self;
    list.dataSource = self;
    list.backgroundView = [[UIView alloc] init];
    list.backgroundColor = [UIColor clearColor];
    list.separatorColor = [UIColor clearColor];
    list.hidden = YES;
    [self.view addSubview:list];
    
    __weak typeof(self) wself = self;
    refreshView = [LGRefreshView refreshViewWithScrollView:list
                                             refreshHandler:^(LGRefreshView *refreshView)
                    {
                        [wself loadBooks];
                    }];
    refreshView.tintColor = [UIColor whiteColor];
    refreshView.backgroundColor = [UIColor clearColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc {

}

#pragma mark - HTHorizontalSelectionListDataSource Protocol Methods

- (NSInteger)numberOfItemsInSelectionList:(HTHorizontalSelectionList *)selectionList {
    return tabsMakes.count;
}

- (NSString *)selectionList:(HTHorizontalSelectionList *)selectionList titleForItemWithIndex:(NSInteger)index {
    return tabsMakes[index];
}

#pragma mark - HTHorizontalSelectionListDelegate Protocol Methods

- (void)selectionList:(HTHorizontalSelectionList *)selectionList didSelectButtonWithIndex:(NSInteger)index {
    if (index == AdminOrdersInPending){
        currentTableFilter = AdminOrdersInPending;
    } else if (index == AdminOrdersTimeDayToday){
        currentTableFilter = AdminOrdersTimeDayToday;
    } else if (index == AdminOrdersAll){
        currentTableFilter = AdminOrdersAll;
    }
    [self loadBooks];
}

@end
