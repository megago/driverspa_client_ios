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

#import "CarwashComplex.h"
#import "User.h"

@interface AdminOrdersViewController () <HTHorizontalSelectionListDataSource, HTHorizontalSelectionListDelegate>
@end

@implementation AdminOrdersViewController {
    HTHorizontalSelectionList *selectionList;
    NSArray *tabsMakes;

    AAButton *todayButton;
    AAButton *tomorrowButton;
    enum AdminOrdersTimeDay currentTableDay;
    UITableView *list;
    NSMutableArray *books;
}

-(id)init {
    self = [super init];
    if(self) {
        [self initVars];
    }
    return self;
}

-(void)initVars {
    currentTableDay = AdminOrdersTimeDayToday;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configUI];
    
    //Check autorized carwash
    CarwashComplex *complex = [CarwashComplex authorizedCarwashDataWithMobile:[User currentUser].mobile];
    
    [self loadBooks];
}

- (void)loadBooks
{
    [Toast showHudLoading];

    if(currentTableDay == AdminOrdersTimeDayToday) {
        [AdminApi ordersToday:^(id response) {
            [self onBooksResponse:response];
        } failure:^(NSInteger code, NSString *message) {

        }];
    } else {
        [AdminApi ordersTomorrow:^(id response) {
            [self onBooksResponse:response];
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

#pragma mark -
#pragma mark Actions

- (void)todayTapped {
    if(currentTableDay != AdminOrdersTimeDayToday) {
        currentTableDay = AdminOrdersTimeDayToday;
        todayButton.alpha = 1;
        tomorrowButton.alpha = 0.5;

        [self loadBooks];
    }
}

- (void)tomorrowTapped {
    if(currentTableDay != AdminOrdersTimeDayTomorrow) {
        currentTableDay = AdminOrdersTimeDayTomorrow;
        tomorrowButton.alpha = 1;
        todayButton.alpha = 0.5;

        [self loadBooks];
    }
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
//    if(currentTableDay == AdminOrdersTimeDayToday) {
//        [cell setTitle:[NSString stringWithFormat:@"В %@", [book localBookTime]]];
//    } else {
//        [cell setTitle:[NSString stringWithFormat:@"Завтра в %@", [book localBookTime]]];
//    }

    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    CarwashBook *book = books[indexPath.row];
    AdminBookViewController *v = [[AdminBookViewController alloc] init];
    v.delegate = self;
    v.book = book;
    [self.navigationController pushViewController:v animated:YES];
}

#pragma mark -

-(void)configUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    [self setBlueBackground];
    [self setNavigationTitle:@"Заказы"];
    [self showMenuButton];
    [self setNavigationBarTransparent];

//    // Tabs
//    CGFloat buttonWidth = (CGFloat) ([ASize screenWidth] * 0.5);
//    __weak AdminOrdersViewController *wSelf = self;
//    UIFont *font = [UIFont robotoCondensedLight:16];
//
//    todayButton = [[AAButton alloc] initWithWidth:buttonWidth onTap:^(UIView *_self) {
//        [wSelf todayTapped];
//    }];
//    todayButton.height = 30;
//    [todayButton noBorderStyleButtonWithTitle:@"Сегодня"];
//    [todayButton setTitleFont:font];
//    [todayButton.button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
//    todayButton.y = 70;
//    [self.view addSubview:todayButton];
//
//    tomorrowButton = [[AAButton alloc] initWithWidth:buttonWidth onTap:^(UIView *_self) {
//        [wSelf tomorrowTapped];
//    }];
//    tomorrowButton.height = todayButton.height;
//    [tomorrowButton noBorderStyleButtonWithTitle:@"Завтра"];
//    [tomorrowButton setTitleFont:font];
//    [tomorrowButton.button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
//    tomorrowButton.x = todayButton.right;
//    tomorrowButton.y = todayButton.y;
//    tomorrowButton.alpha = 0.5;
//    [self.view addSubview:tomorrowButton];
    
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
    CGFloat listY = selectionList.bottom;//tomorrowButton.bottom + 5;
    list = [[UITableView alloc] initWithFrame:CGRectMake(0, listY, [ASize screenWidth], [ASize screenHeight]-44 - listY) style:UITableViewStylePlain];
    list.delegate = self;
    list.dataSource = self;
    list.backgroundView = [[UIView alloc] init];
    list.backgroundColor = [UIColor clearColor];
    list.separatorColor = [UIColor clearColor];
    list.hidden = YES;
    [self.view addSubview:list];
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
    // update the view for the corresponding index
}

@end